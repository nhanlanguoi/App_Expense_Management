import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:expense_management/core/utils/responsive.dart';

class CardGeneralTotal extends StatelessWidget {
  final double total;
  final double income;
  final double expense;

  const CardGeneralTotal({
    super.key,
    required this.total,
    required this.income,
    required this.expense,
  });

  String money(double value) {
    return "${NumberFormat("#,###", "vi_VN").format(value)} ₫";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9C61E7),
            Color(0xFF756AE4),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "home.total_balance".tr(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: Responsive.sp(12),
            ),
          ),

          SizedBox(height: Responsive.h(5)),

          Text(
            money(total),
            style: TextStyle(
              fontSize: Responsive.sp(26),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: Responsive.h(10)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.green),
                  SizedBox(width: Responsive.w(5)),
                  Text(
                    "${"home.savings".tr()}: ${money(income)}",
                    style: TextStyle(color: Colors.white, fontSize: Responsive.sp(12)),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.orange),
                  SizedBox(width: Responsive.w(5)),
                  Text(
                    "${"home.spent".tr()}: ${money(expense)}",
                    style: TextStyle(color: Colors.white, fontSize: Responsive.sp(12)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}