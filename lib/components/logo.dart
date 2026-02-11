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
    required this.size,
    required this.iconsize,
    required this.bordersize,
    this.color  = const Color(0xFF6D31D1),
  });

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(size / 3),
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
      duration:const Duration(milliseconds: 500),
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
