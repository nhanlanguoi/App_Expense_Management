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
          backgroundColor: Colors.blueAccent,
          leading: Circleavatar(),
        ),
    );
  }
}
