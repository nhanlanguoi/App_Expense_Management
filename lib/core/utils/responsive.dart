
import 'package:flutter/material.dart';

class Responsive {
  static late double _w;
  static late double _h;
  static late double _sp;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;

    _w = size.width / 375;   // design width
    _h = size.height / 812;  // design height
    _sp = _w / textScale;
  }

  static double w(double v) => v * _w;
  static double h(double v) => v * _h;
  static double sp(double v) => v * _sp;
}