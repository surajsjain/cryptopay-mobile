import 'dart:convert';

import 'package:crypto_pay/pages/login/widget/button.dart';
import 'package:crypto_pay/pages/login/widget/inputEmail.dart';
import 'package:crypto_pay/pages/login/widget/password.dart';
import 'package:crypto_pay/pages/login/widget/textLogin.dart';
import 'package:crypto_pay/pages/login/widget/verticalText.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Database db;

//  String baseURL = "http://10.0.2.2:8001/";
  String baseURL = "http://192.168.1.9:8001/";

  bool failedLogin = false;

  BuildContext context;

  void logIn(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    Map<String, String> reqData = {
      "email": email,
      "password": password,
    };
    Map<String, String> reqHeaders = {
      "Content-type": "application/json",
    };
    String loginURL = this.baseURL + 'phoneservice/login/';
    Response res = await post(
      loginURL,
      body: jsonEncode(reqData),
      headers: reqHeaders,
    );

    Map resp = jsonDecode(res.body);
    if (resp['auth_status'] == true) {
      this.db.insert(
        'user',
        {
          'email': email,
          'token': resp['auth_token'],
        },
      );
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'baseURL': this.baseURL,
      });
    } else {
      setState(() {
        this.failedLogin = true;
      });
    }
  }

  void checkAndCreateDB() async {
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
//    await this.db.insert(
//      'user',
//      {
//        "email": "surajsjain@hotmail.com",
//        "token": "hello1234",
//      },
//    );

//    await db.delete('user',
//        where: "email = ?", whereArgs: ['surajsjain@hotmail.com']);

//    print(await (db.query('user')));

    List users = await db.query('user');
    if (users.length > 0) {
      Navigator.pushReplacementNamed(this.context, '/home', arguments: {
        'baseURL': this.baseURL,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkAndCreateDB();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    VerticalText(),
                    TextLogin(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Looks like your email or the password is incorrect. Please try again',
                    style: TextStyle(
                      fontSize: (this.failedLogin) ? 24 : 0,
                      color: Colors.deepOrange,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                InputEmail(
                  controller: this.emailController,
                ),
                PasswordInput(
                  controller: this.passwordController,
                ),
                ButtonLogin(
                  onPressedAction: () {
                    this.logIn(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
