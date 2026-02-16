import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  final List<IconData> listicon;

  const Bottomnavbar({super.key, required this.listicon});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {

    return AnimatedBottomNavigationBar.builder(
      itemCount: widget.listicon.length,
      tabBuilder: (int index, bool isActive) {
        return Icon(
          widget.listicon[index],
          size: 24,
          color: isActive ? Colors.blue : Colors.grey,
        );
      },

      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },
    );
  }
}