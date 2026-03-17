import 'package:expense_management/core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

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
                        borderRadius: BorderRadius.circular(Responsive.r(10)),
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
                    SizedBox(width: Responsive.w(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Format.formattext(widget.title ?? "Ăn uống"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.sp(15),
                          ),
                        ),
                        Text(
                          (widget.time ?? "8:30"),
                          style: TextStyle(fontSize: Responsive.sp(14)),
                        ),
                      ],
                    ),
                  ],
                ),

                Text(
                  (Format.formattext(widget.allmoney?? "-25.000 đ") ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(16),
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
