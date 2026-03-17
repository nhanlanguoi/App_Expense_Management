import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';
import 'package:expense_management/core/utils/responsive.dart';

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
        borderRadius: BorderRadius.circular(Responsive.r(20)),
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
            "statistic.overview_total_expense_month".tr(namedArgs: {'month': currentMonth.toString()}),
            style: TextStyle(color: Colors.white70, fontSize: Responsive.sp(14), fontFamily: 'BeVietnamPro'),
          ),
          SizedBox(height: Responsive.h(8)),
          Text(
            "${Format.formatnumber(totalExpense)} đ",
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.sp(32),
              fontWeight: FontWeight.bold,
              fontFamily: 'BeVietnamPro',
            ),
          ),
          SizedBox(height: Responsive.h(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("statistic.average_per_day".tr(), style: TextStyle(color: Colors.white70, fontSize: Responsive.sp(13))),
                    ],
                  ),
                  SizedBox(height: Responsive.h(8)),
                  Text(
                    "${Format.formattext(Format.formatnumber(averagePerDay))} đ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.sp(18),
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
                      Text("statistic.max_expense".tr(), style: TextStyle(color: Colors.white70, fontSize: Responsive.sp(13))),
                    ],
                  ),
                  SizedBox(height: Responsive.h(8)),
                  Text(
                    "${Format.formattext(Format.formatnumber(maxExpense))} đ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.sp(18),
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