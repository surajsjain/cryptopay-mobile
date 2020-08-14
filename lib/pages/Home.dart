import 'package:crypto_pay/custom_widgets/cards/HeadedCard.dart';
import 'package:crypto_pay/utils/ColorCombo.dart';
import 'package:crypto_pay/utils/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                itemCount: 1,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HeadedCard(
                      colorScheme: ColorCombo(
                          backgoundColor: Colors.white,
                          textColor: Colors.black),
                      headContent: Center(
                        child: Text(
                          'ARDR 15',
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
                            'Transaction Code:',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005,
                          ),
                          Text(
                            'CSports-18',
                            style: TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      cardPress: () {},
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
