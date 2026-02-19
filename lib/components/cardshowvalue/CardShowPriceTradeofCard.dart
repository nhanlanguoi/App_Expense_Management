import 'package:flutter/material.dart';

class Cardshowpricetrade extends StatefulWidget {
  final String? title;
  final String? time;
  final String? allmoney;
  final double? percen;
  final IconData? Icon;
  final Color? Iconcolor;

  const Cardshowpricetrade({
    super.key,
    this.title,
    this.time,
    this.allmoney,
    this.percen,
    this.Icon,
    this.Iconcolor,
  });

  @override
  State<Cardshowpricetrade> createState() => _CardmanagerexpenseState();
}

class _CardmanagerexpenseState extends State<Cardshowpricetrade> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color:
                            widget.Iconcolor?.withValues(alpha: 0.2) ??
                            Colors.orange[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          widget.Icon ?? Icons.fastfood,
                          size: 30,
                          color: widget.Iconcolor ?? Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title ?? "Ăn uống",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          (widget.time ?? "8:30"),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),

                Text(
                  (widget.allmoney ?? "-25.000 đ"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.Iconcolor ?? Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
