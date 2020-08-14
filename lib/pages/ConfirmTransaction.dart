import 'dart:convert';

import 'package:crypto_pay/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ConfirmTransaction extends StatefulWidget {
  @override
  _ConfirmTransactionState createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  HexColor hxc = HexColor();
  String passphrase = "";
  String checkoutCode = "";
  String baseURL = "";
  int chain = 1;
  double amt = 0.0;

  void setPassphrase() async {
    String passphrase = await scanner.scan();
    print('\n\n${this.passphrase}\n\n');

    setState(() {
      this.passphrase = passphrase;
    });
  }

  void initVars() async {
    await Future.delayed(Duration(seconds: 1));
    print('\n\n${ModalRoute.of(context).settings.arguments}\n\n');
    Map inData = ModalRoute.of(context).settings.arguments;
    setState(() {
      this.baseURL = inData['baseURL'];
      this.checkoutCode = inData['transaction']['checkout_code'];
      this.amt = inData['transaction']['amount'];
      this.chain = inData['transaction']['chain'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.initVars();
  }

  void confirmTransaction() async {
    if (this.passphrase == '' || this.checkoutCode == '') {
      return;
    }
    Map<String, String> reqHeaders = {
      "Content-type": "application/json",
    };

    String reqUrl = this.baseURL + 'transactions/confirm/';

    Map<String, String> reqData = {
      "checkout_code": this.checkoutCode,
      "passphrase": this.passphrase,
    };

    Response res = await post(
      reqUrl,
      body: jsonEncode(reqData),
      headers: reqHeaders,
    );

    Map resp = jsonDecode(res.body);
    if (resp['transaction_status'] == 'executed') {
      Navigator.pop(context, {
        'status': true,
      });
    } else {
      Navigator.pop(context, {
        'status': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, {
              'status': false,
            });
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: hxc.getColor("#1e3c60"),
          ),
        ),
        title: Center(
          child: Text(
            'Confirm Transaction',
            style: TextStyle(
              color: hxc.getColor("#1e3c60"),
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    'Checkout Code: ${this.checkoutCode}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Please take a picture of your Passphrase\'s QR code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.white,
                        onPressed: () {
                          this.setPassphrase();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text('Scan'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      (this.passphrase != '')
                          ? 'You have scanned: ${this.passphrase}'
                          : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Center(
                    child: Text(
                      'ARDR ${this.amt}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 54,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                this.confirmTransaction();
              },
              child: Container(
                padding: EdgeInsets.all(18.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 1.5, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
