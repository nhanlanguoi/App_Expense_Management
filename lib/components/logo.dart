import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class logo extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconsize;
  final double bordersize;
  final Color color;

  const logo({
    super.key,
    required this.icon,
    required this.iconsize,
    required this.bordersize,
    this.color = const Color(0xFF6D31D1),
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: color,
          width: bordersize,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.9),
            blurRadius: Responsive.w(15),
            offset: Offset(0, Responsive.h(5)),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconsize,
          color: Colors.white,
        ),
      ),
    );
  }
}