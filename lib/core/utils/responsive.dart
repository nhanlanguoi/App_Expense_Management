import 'package:flutter/material.dart';

class Responsive {
  static late double _w;
  static late double _h;
  static late double _sp;


  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  static void init(BuildContext context) {

    final size = MediaQuery.sizeOf(context);


    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    _w = size.width / _designWidth;
    _h = size.height / _designHeight;


    _sp = (textScale > 0) ? (_w / textScale) : _w;
  }


  static double w(double v) => v * _w;
  static double h(double v) => v * _h;
  static double sp(double v) => v * _sp;


  static double r(double v) => v * (_w < _h ? _w : _h);
}