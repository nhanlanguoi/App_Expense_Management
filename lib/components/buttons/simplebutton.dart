import 'package:flutter/material.dart';

class simplebutton extends StatefulWidget {
  final String? label;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final IconData? iconData;



  const simplebutton({
    super.key,
    required this.label,
    this.onPressed,
    this.textStyle,
    this.primaryColor,
    this.secondaryColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.iconData
  });

  @override
  State<simplebutton> createState() => _simplebuttonState();
}

class _simplebuttonState extends State<simplebutton> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
