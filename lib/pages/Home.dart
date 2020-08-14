import 'dart:convert';

import 'package:crypto_pay/custom_widgets/cards/HeadedCard.dart';
import 'package:crypto_pay/utils/ColorCombo.dart';
import 'package:crypto_pay/utils/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pendingTransactions = [];
  Database db;
  String auth_token;

  String baseURL = "http://10.0.2.2:8001/";
  Map inData;

  void initializeDB() async {
//    Map inData = ModalRoute.of(context).settings.arguments;
    Future<Database> database = openDatabase(
      join(
        await getDatabasesPath(),
        'cryptoPay_database.db',
      ),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE user(email TEXT, token TEXT)");
      },
      version: 1,
    );

    this.db = await database;
    String token = (await db.query('user'))[0]['token'];
    this.auth_token = token;

    getAndUpdatePendingTransactions();
  }

  void getAndUpdatePendingTransactions() async {
    String token = this.auth_token;

    Map<String, String> reqHeaders = {
      "Content-type": "application/json",
      "Authorization": "Token ${token}",
    };

    String reqUrl = this.baseURL + 'transactions/pending/';

    while (true) {
//      print('running the update function');
      Response res = await get(
        reqUrl,
        headers: reqHeaders,
      );

//      print(jsonDecode(res.body));

      List transactions = jsonDecode(res.body)['transactions'];
//      print(transactions);

      bool outFlag = false;

      if (pendingTransactions.length == 0 && transactions.length != 0) {
        setState(() {
          pendingTransactions = transactions;
        });
      }

      for (int i = 0; i < transactions.length; i++) {
        bool inFlag = false;

        String new_code = transactions[i]['checkout_code'];
        for (int j = 0; j < pendingTransactions.length; j++) {
          String existing_code = pendingTransactions[j]['checkout_code'];

          if (new_code == existing_code) {
//            print('Found a match');
            inFlag = false;
            break;
          } else {
            print('did not find a match');
            inFlag = true;
          }
        }

        if (inFlag) {
          outFlag = true;
          setState(() {
            print(transactions[i]);
            this.pendingTransactions += [transactions[i]];
          });
          print('Updating the tiles');
        }
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    super.initState();
    this.initializeDB();
//    this.getAndUpdatePendingTransactions();
  }

  @override
  Widget build(BuildContext context) {
    this.inData = ModalRoute.of(context).settings.arguments;
    this.baseURL = this.inData['baseURL'];

    String baseURL = this.inData['baseURL'];

    print('BaseURL: ${this.baseURL}');
    HexColor hxc = HexColor();
    return Scaffold(
      backgroundColor: hxc.getColor("#1e3c60"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Your Outstanding Payments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: this.pendingTransactions.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  String amt = "";
                  if (this.pendingTransactions[index]['chain'] == 1) {
                    amt += "ARDR ";
                  } else {
                    amt += "IGNIS ";
                  }

                  amt += '${this.pendingTransactions[index]['amount']}';

                  String checkout_code =
                      this.pendingTransactions[index]['checkout_code'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HeadedCard(
                      colorScheme: ColorCombo(
                          backgoundColor: Colors.white,
                          textColor: Colors.black),
                      headContent: Center(
                        child: Text(
                          amt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                      bodyContent: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Checkout Code:',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005,
                          ),
                          Text(
                            checkout_code,
                            style: TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      cardPress: () async {
                        dynamic conf_res = await Navigator.pushNamed(
                          context,
                          '/confirm_transaction',
                          arguments: {
                            "transaction": this.pendingTransactions[index],
                            "baseURL": baseURL,
                          },
                        );

                        if (conf_res['status'] == true) {
                          setState(() {
                            this.pendingTransactions.removeAt(index);
                          });
                        }
                      },
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.all(12),
              child: Text(
                '+ New Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              color: Colors.deepOrange,
              onPressed: () {
                Navigator.pushNamed(context, '/confirm_transaction');
              },
            ),
          ],
        ),
      ),
    );
  }
}
