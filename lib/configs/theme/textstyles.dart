import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class TextStyles {
  static const String fontFamily = 'BeVietnamPro';

  // dungf cho tên trang hoặc title của một bậc
  static final TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(30),
    fontWeight: FontWeight.w500
  );

  static final TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(23),
  );

  static final TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(18),
  );

  static final TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(15),
  );

  ////////
  static final TextStyle nameuser = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(18),
    fontWeight: FontWeight.bold,
  );

  static final TextStyle emailuser = TextStyle(
    fontFamily: fontFamily,
    fontSize: Responsive.sp(15),
  );

  //dungf cho các chữ trong các nút
  static final TextStyle buttonsetting =TextStyle(
    fontSize: Responsive.sp(16),
    fontWeight: FontWeight.w600,
    fontFamily: 'BeVietnamPro',
  );
}