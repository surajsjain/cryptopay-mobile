import 'package:crypto_pay/pages/login/widget/button.dart';
import 'package:crypto_pay/pages/login/widget/inputEmail.dart';
import 'package:crypto_pay/pages/login/widget/password.dart';
import 'package:crypto_pay/pages/login/widget/textLogin.dart';
import 'package:crypto_pay/pages/login/widget/verticalText.dart';
import 'package:flutter/material.dart';
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

  void logIn() async {
    print('Hello! ${this.emailController.text}');
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
  }

  @override
  void initState() {
    super.initState();
    checkAndCreateDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
//          gradient: LinearGradient(
//              begin: Alignment.topRight,
//              end: Alignment.bottomLeft,
//              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
          color: Colors.deepOrange,
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                InputEmail(
                  controller: this.emailController,
                ),
                PasswordInput(
                  controller: this.passwordController,
                ),
                ButtonLogin(
                  onPressedAction: () {
                    this.logIn();
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
