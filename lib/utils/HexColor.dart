import 'package:flutter/material.dart';

class HexColor {
  Color getColor(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
