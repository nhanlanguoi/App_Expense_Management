import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cardgeneraltotal extends StatelessWidget {
  const Cardgeneraltotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: 200,
      child: Column(
        children: [
          Text("Đã chi tiêu"),
          Text("3254325"),
          Container(),
          Container(
            child: Row(children: [Text("Còn lại:"), Text("4553235241")]),
          ),
        ],
      ),
    );
  }
}
