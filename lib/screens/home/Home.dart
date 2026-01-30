import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';

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
        leadingWidth: 200,
        backgroundColor: Colors.blueAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(children: [const Circleavatar(),const SizedBox(width: 10,), const CardInfo()]),
        ),
      ),
    );
  }
}
