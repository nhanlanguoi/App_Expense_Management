import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

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
    );
  }
}
