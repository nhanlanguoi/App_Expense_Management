import 'package:expense_management/configs/theme/color.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final int currentMonth;
  final double totalExpense;
  final double averagePerDay;
  final double maxExpense;

  const OverviewCard({
    required this.currentMonth,
    required this.totalExpense,
    required this.averagePerDay,
    required this.maxExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.gradientcard,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6448FE).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Tổng chi tiêu tháng $currentMonth",
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'BeVietnamPro'),
          ),
          const SizedBox(height: 8),
          Text(
            "${totalExpense.toStringAsFixed(0)} đ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'BeVietnamPro',
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Trung bình/ngày", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${averagePerDay.toStringAsFixed(0)} đ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Khoản lớn nhất", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${maxExpense.toStringAsFixed(0)} đ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                    ),
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