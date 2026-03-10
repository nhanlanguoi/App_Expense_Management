import 'package:flutter/material.dart';

class TextStyles {
  static const String fontFamily = 'BeVietnamPro';

  // dungf cho tên trang hoặc title của một bậc
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w500
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );



  ////////
  static const TextStyle nameuser = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle emailuser = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
  );

  //dungf cho các chữ trong các nút
  static const TextStyle buttonsetting =TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'BeVietnamPro',
  );
}