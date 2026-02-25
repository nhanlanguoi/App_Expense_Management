import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Circleavatar extends StatelessWidget {
  const Circleavatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 10),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 24,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 22,
          child: Icon(Icons.person),
        )
      ),
    );
  }
}
