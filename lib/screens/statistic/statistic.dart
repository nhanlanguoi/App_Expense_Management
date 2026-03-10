import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/textstyles.dart';
import 'package:expense_management/screens/statistic/widgets/BalanceChartWidget.dart';
import 'package:expense_management/screens/statistic/widgets/BarChartWidget.dart';
import 'package:expense_management/screens/statistic/widgets/OverviewCard.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/service/authservice.dart';
import '../../data/service/transactionservice.dart';
import '../../model/transactions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:expense_management/configs/theme/textstyles.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.floor_background,
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
                    Text(
                      "Thu nhập và Chi tiêu",
                      style: TextStyles.h2.copyWith(color: Colors.black)
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(transactions: allTransactions),
                    const SizedBox(height: 30),
                    Text(
                      "Biến động số dư",
                      style: TextStyles.h2.copyWith(color: Colors.black)
                    ),
                    const SizedBox(height: 10),
                    BalanceChartWidget(transactions: allTransactions),
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

