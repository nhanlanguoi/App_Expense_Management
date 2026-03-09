import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/service/authservice.dart';
import '../../data/service/transactionservice.dart';
import '../../model/transactions.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box('transactions').listenable(),
          builder: (context, box, child) {
            final currentUser = AuthService().currentUser;
            if (currentUser == null) {
              return const Center(child: Text("Vui lòng đăng nhập"));
            }

            final transService = TransactionService();
            List<TransactionRecord> allTransactions = transService.getAllUserTransactions(currentUser.email);

            DateTime now = DateTime.now();
            List<TransactionRecord> currentMonthTrans = allTransactions.where((t) {
              return t.date.month == now.month && t.date.year == now.year;
            }).toList();
            double totalMonthExpense = 0;
            double maxExpense = 0;

            for (var t in currentMonthTrans) {
              if (t.type == 'expense') {
                totalMonthExpense += t.amount;
                if (t.amount > maxExpense) {
                  maxExpense = t.amount;
                }
              }
            }
            int currentDay = now.day;
            double averagePerDay = currentDay > 0 ? (totalMonthExpense / currentDay) : 0;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverviewCard(
                      currentMonth: now.month,
                      totalExpense: totalMonthExpense,
                      averagePerDay: averagePerDay,
                      maxExpense: maxExpense,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
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
        gradient: const LinearGradient(
          colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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