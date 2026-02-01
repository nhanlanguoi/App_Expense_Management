import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cardgeneraltotal extends StatelessWidget {
  final double? kichthuocmain1;
  final double? kichthuocmain2;
  final double? kichthuocphu11;
  final double? kichthuocphu12;
  final Color? colormain;
  final String? Tongsodu;
  final String? Tietkiem;
  final String? Chitieu;

  const Cardgeneraltotal({
    super.key,
    this.kichthuocmain1,
    this.kichthuocmain2,
    this.kichthuocphu11,
    this.kichthuocphu12,
    this.colormain,
    this.Tongsodu,
    this.Tietkiem,
    this.Chitieu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(left: 10, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng số dư",
                  style: TextStyle(
                    fontSize: kichthuocmain1 ?? 12,
                    color: colormain ?? Colors.white,
                  ),
                ),
                Text(
                  Tongsodu ?? "3.254.325" + " ₫",
                  style: TextStyle(
                    fontSize: kichthuocmain2 ?? 30,
                    fontWeight: FontWeight.bold,
                    color: colormain ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          "Tiết kiệm: ",
                          style: TextStyle(color: colormain ?? Colors.white),
                        ),
                        Text(
                          Tietkiem ??"4.553.235.241" + " ₫",
                          style: TextStyle(color: colormain ?? Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Colors.red),
                        SizedBox(width: 6),
                        Text(
                          "Đã tiêu: ",
                          style: TextStyle(color: colormain ?? Colors.white),
                        ),

                        Text(
                          Chitieu ?? "4.553.235.241" + " ₫",
                          style: TextStyle(color: colormain ?? Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
