import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

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
        borderRadius: BorderRadius.circular(20),
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            money(total),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.green),
                  const SizedBox(width: 5),
                  Text(
                    "${"home.savings".tr()}: ${money(income)}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.orange),
                  const SizedBox(width: 5),
                  Text(
                    "${"home.spent".tr()}: ${money(expense)}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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