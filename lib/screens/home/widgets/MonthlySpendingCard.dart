import 'package:expense_management/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlySpendingCard extends StatelessWidget {
  final double spent;
  final double total;
  final bool collapsed;

  const MonthlySpendingCard({
    super.key,
    required this.spent,
    required this.total,
    required this.collapsed,
  });

  String money(double value) {
    return "${NumberFormat("#,###", "vi_VN").format(value)} ₫";
  }

  @override
  Widget build(BuildContext context) {
    double percent = total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;
    double remain = total;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.all(collapsed ? Responsive.r(10) : Responsive.r(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        gradient: const LinearGradient(
          colors: [Color(0xFF7A6FF0), Color(0xFF5A5BD6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: Responsive.r(10),
            offset: Offset(0, Responsive.h(5)),
          )
        ],
      ),
      child: collapsed
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.r(10)),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: Responsive.h(8),
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: Responsive.h(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                money(spent),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(14),
                ),
              ),
              Text(
                "${(percent * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(14),
                ),
              )
            ],
          )
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Đã chi tiêu",
                style: TextStyle(
                    fontSize: Responsive.sp(15),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BeVietnamPro',
                    color: Colors.white70),
              ),
              Container(
                width: Responsive.r(50),
                height: Responsive.r(50),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(14),
                  ),
                ),
              )
            ],
          ),
          Text(
            money(spent),
            style: TextStyle(
              fontSize: Responsive.sp(26),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Responsive.h(5)),
          ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.r(10)),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: Responsive.h(8),
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: Responsive.h(5)),
          Text(
            "Số tiền trong ví thật : ${money(remain)}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: Responsive.sp(13),
            ),
          )
        ],
      ),
    );
  }
}