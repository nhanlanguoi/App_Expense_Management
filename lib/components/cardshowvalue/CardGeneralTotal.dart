import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cardgeneraltotal extends StatelessWidget {
  const Cardgeneraltotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("Đã chi tiêu"),
          Text("3254325"),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(children: [Text("Còn lại:"), Text("4553235241")]),
            ),
          ),
        ],
      ),
    );
  }
}
