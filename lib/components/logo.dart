import 'dart:math';

import 'package:flutter/material.dart';

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
    this.color  = const Color(0xFF6D31D1),
    required this.size,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size*0.3),
        border: Border.all(
          color: color,
          width: bordersize,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.9),
            // color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
