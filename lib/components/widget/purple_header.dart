import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class PurpleHeader extends StatelessWidget {
  final double height;

  const PurpleHeader({
    super.key,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      width: double.infinity,
      height: Responsive.h(height),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7F3DFF),
            Color(0xFF5B2EFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Responsive.w(40)),
          bottomRight: Radius.circular(Responsive.w(40)),
        ),
      ),
    );
  }
}