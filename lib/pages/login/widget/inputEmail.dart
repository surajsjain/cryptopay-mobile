import 'package:flutter/material.dart';

class InputEmail extends StatefulWidget {
  @override
  _InputEmailState createState() => _InputEmailState();

  TextEditingController controller;

  InputEmail({@required this.controller});
}

class _InputEmailState extends State<InputEmail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.white,
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
