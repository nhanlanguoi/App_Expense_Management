import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatelessWidget {
  final List<IconData> listicon;
  final int activeIndex;
  final Function(int) onTap;

  const Bottomnavbar({
    super.key,
    required this.listicon,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: listicon.length,
      tabBuilder: (int index, bool isActive) {
        return Icon(
          listicon[index],
          size: 24,
          color: isActive ? Colors.blue : Colors.grey,
        );
      },
      activeIndex: activeIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: onTap,
    );
  }
}