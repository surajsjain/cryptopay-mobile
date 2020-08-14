import 'package:crypto_pay/pages/login/widget/buttonNewUser.dart';
import 'package:crypto_pay/pages/login/widget/newEmail.dart';
import 'package:crypto_pay/pages/login/widget/newName.dart';
import 'package:crypto_pay/pages/login/widget/password.dart';
import 'package:crypto_pay/pages/login/widget/singup.dart';
import 'package:crypto_pay/pages/login/widget/textNew.dart';
import 'package:crypto_pay/pages/login/widget/userOld.dart';
import 'package:flutter/material.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                NewNome(),
                NewEmail(),
                PasswordInput(),
                ButtonNewUser(),
                UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
