import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color background = Colors.white;
  static const Color textGray = Colors.grey;
  static const Color borderLight = Color(0xFFEEEEEE);

  static const List<Color> defaultWalletColors = [
    Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFEF4444),
    Color(0xFFF97316), Color(0xFFA855F7),
  ];

  static const List<Color> extendedWalletColors = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
    Colors.brown, Colors.blueGrey, Colors.black87, Colors.tealAccent
  ];

  static String colorToHex(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static Color getColorFromHex(String hexColor) {
    try {
      String formattedHex = hexColor.replaceAll('#', '0xFF');
      if (!formattedHex.startsWith('0x')) {
        formattedHex = '0xFF$formattedHex';
      }
      return Color(int.parse(formattedHex));
    } catch (e) {
      return primary;
    }
  }
}