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
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                  (Tongsodu ?? "3.254.325") + " ₫",
                  style: TextStyle(
                    fontSize: kichthuocmain2 ?? 30,
                    fontWeight: FontWeight.bold,
                    color: colormain ?? Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.green),
                        const SizedBox(width: 3),
                        const Text("Tiết kiệm: ", style: TextStyle(color: Colors.white, fontSize: 10)),

                        Flexible(
                          child: Text(
                            Tietkiem ?? "14.553.235 ₫",
                            style: TextStyle(color: colormain ?? Colors.white ,fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),


                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.red),
                        const SizedBox(width: 3),
                        const Text("Đã tiêu: ", style: TextStyle(color: Colors.white, fontSize: 10)),
                        Flexible(
                          child: Text(
                            Chitieu ?? "4.553.235.241 ₫",
                            style: TextStyle(color: colormain ?? Colors.white ,fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
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
