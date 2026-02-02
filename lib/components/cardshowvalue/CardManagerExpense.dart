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
      decoration: BoxDecoration(
          color: Colors.green,
        borderRadius: BorderRadius.circular(15)
      ),

      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.fastfood, size: 30),
                      ),
                    ),
                    SizedBox(width: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ăn uống",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "15" + "giao dịch",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "232,43243324.234",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("23%", style: TextStyle(fontSize: 14,color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(
              left: 12,
              right: 12,
              top: 5,
              bottom: 15,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(

                value: 0.4, 
                backgroundColor: Colors.grey[200],
                color: Colors.orange,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
