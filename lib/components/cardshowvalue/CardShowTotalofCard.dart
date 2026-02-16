import 'package:flutter/material.dart';

class Cardshowtotalofcard extends StatefulWidget {
  final String? total;
  final double? percen;
  final IconData? Icon;
  final Color? Iconcolor;
  final Color? Background;

  const Cardshowtotalofcard({
    super.key,
    this.total,
    this.percen,
    this.Icon,
    this.Iconcolor,
    this.Background,
  });

  @override
  State<Cardshowtotalofcard> createState() => _CardmanagerexpenseState();
}

class _CardmanagerexpenseState extends State<Cardshowtotalofcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.Background ?? Colors.grey[150],
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
            padding: EdgeInsetsGeometry.all(20),
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
                          "Thống kê",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          (widget.total ?? "15") + " giao dịch",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Tỉ trọng",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "${((widget.percen ?? 0.23) * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.Iconcolor ?? Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
