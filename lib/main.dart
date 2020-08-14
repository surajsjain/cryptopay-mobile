import 'package:crypto_pay/pages/Home.dart';
import 'package:crypto_pay/pages/login/pages/LoginPage.dart';
import 'package:crypto_pay/utils/HexColor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HexColor hxc = HexColor();

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => Home(),
//        '/workout_session_details': (context) => WorkoutSessionDetails(),
//        '/exercise_details': (context) => ExerciseDetails(),
      },
    );
  }
}
