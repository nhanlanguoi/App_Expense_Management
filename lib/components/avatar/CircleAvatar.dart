import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Circleavatar extends StatelessWidget {
  const Circleavatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(

        backgroundColor: Colors.greenAccent[400],
        radius: 100,
        child: Text("Nhan"),
      ),
    );
  }
}
