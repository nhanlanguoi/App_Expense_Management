import 'package:flutter/material.dart';

class PurpleHeader extends StatelessWidget {
  final double height;
  final Color? color;

  const PurpleHeader({super.key, this.height = 300, this.color});

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
        // gradient: LinearGradient(
        //   colors: [Color(0xFF7F3DFF), Color(0xFF5B2EFF)],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}
