// lib/components/gradientbackground.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:expense_management/core/utils/responsive.dart';

class gradientbackground extends StatelessWidget {
  final Widget child;

  const gradientbackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: Responsive.h(120),
            left: Responsive.w(100),
            child: Container(
              width: Responsive.w(300),
              height: Responsive.w(300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: Responsive.h(-50),
            right: Responsive.w(-50),
            child: Container(
              width: Responsive.w(250),
              height: Responsive.w(250),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            top: Responsive.h(200),
            right: Responsive.w(50),
            child: Container(
              width: Responsive.w(150),
              height: Responsive.w(150),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.2),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: Responsive.w(100),
                sigmaY: Responsive.w(100),
              ),
              child: Container(
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
          SafeArea(
            child: SizedBox.expand(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}