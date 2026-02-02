import 'package:flutter/material.dart';

class Cardmanagerexpense extends StatefulWidget {
  const Cardmanagerexpense({super.key});

  @override
  State<Cardmanagerexpense> createState() => _CardmanagerexpenseState();
}

class _CardmanagerexpenseState extends State<Cardmanagerexpense> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    child: Icon(Icons.fastfood),
                  ),
                  Column(
                    children: [
                      Text("Ăn uống"),
                      Text("15" + "giao dịch")
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Text("232,43243324.234"),
                  Text("23%")
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
