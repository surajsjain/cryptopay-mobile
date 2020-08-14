import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();

  TextEditingController controller;

  PasswordInput({@required this.controller});
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
