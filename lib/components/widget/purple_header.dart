import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class PurpleHeader extends StatelessWidget {
  final double height;
  final Color? color;

  const PurpleHeader({super.key, required this.height, this.color});

  @override
  Widget build(BuildContext context) {

    final color1 = color ?? const Color(0xFF7F3DFF);
    final color2 = Color.lerp(color1, Colors.black, 0.2) ?? color1;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Responsive.w(35)),
          bottomRight: Radius.circular(Responsive.w(35)),
        ),
      ),
    );
  }
}