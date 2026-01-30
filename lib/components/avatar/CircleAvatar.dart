import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Circleavatar extends StatelessWidget {
  const Circleavatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(

        backgroundColor: Colors.white,
        radius: 29,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 19,
          child: Icon(Icons.person),
        )
      ),
    );
  }
}
