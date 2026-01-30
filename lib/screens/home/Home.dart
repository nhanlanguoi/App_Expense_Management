import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_management/components/avatar/CircleAvatar.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        leadingWidth: 50,
        backgroundColor: Colors.blueAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20)
          )
        ),
        leading: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: const Circleavatar(),

        ),
        title: Container(
          height: 135,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 10),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Xin chào,",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 4),
              Text(
                "Nhan",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
