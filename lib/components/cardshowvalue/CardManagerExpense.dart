import 'package:flutter/material.dart';

class Cardmanagerexpense extends StatefulWidget {
  final String? title;
  final String? total;
  final String? allmoney;
  final double? percen;
  final IconData? Icon;
  final Color? Iconcolor;


  const Cardmanagerexpense({
    super.key,
    this.title,
    this.total,
    this.allmoney,
    this.percen,
    this.Icon, this.Iconcolor,
  });

  @override
  State<Cardmanagerexpense> createState() => _CardmanagerexpenseState();
}

class _CardmanagerexpenseState extends State<Cardmanagerexpense> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[150],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
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
                        color:widget.Iconcolor?.withValues(alpha: 0.2) ?? Colors.orange[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          widget.Icon ?? Icons.fastfood,
                          size: 30,
                          color: widget.Iconcolor??Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title??"Ăn uống",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          (widget.total??"15") + " giao dịch",
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
                      widget.allmoney ??"232,43243324.234",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      (widget.percen.toString() ??"23") + "%",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
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
                value: widget.percen ?? 0.4,
                backgroundColor: Colors.grey[200],
                color: widget.Iconcolor ?? Colors.orange,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
