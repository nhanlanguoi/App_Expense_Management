import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../components/cardshowvalue/CardShowHistoryTrade.dart';
import '../../core/data/service/authservice.dart';
import '../../core/data/service/transactionservice.dart';
import '../../core/model/transactions.dart';
import '../../configs/theme/icon.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';


class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);

    String dateString =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    if (aDate == today) return "history.today".tr() + " $dateString";
    if (aDate == yesterday) return "history.yesterday".tr() + " $dateString";
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.floor_background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Responsive.w(10), top: Responsive.h(10)),
              child: IconButton(
                icon: Icon(Icons.close, size: Responsive.w(28), color: Colors.black87),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Text(
                "Tất cả giao dịch",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.sp(24),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BeVietnamPro',
                ),
              ),
            ),
            SizedBox(height: Responsive.h(15)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(8)),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Responsive.w(20)),
                      border: Border.all(color: Colors.blue.withOpacity(0.5)),
                    ),
                    child: Text(
                      "Tất cả",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('transactions').listenable(),
                builder: (context, box, child) {
                  final currentUser = AuthService().currentUser;
                  if (currentUser == null) {
                    return const Center(child: Text("Vui lòng đăng nhập"));
                  }

                  final transService = TransactionService();
                  List<TransactionRecord> allTransactions = transService.getAllUserTransactions(currentUser.email);
                  allTransactions.sort((a, b) => b.date.compareTo(a.date));
                  Map<String, List<TransactionRecord>> groupedTrans = {};
                  for (var t in allTransactions) {
                    String dateKey = formatDate(t.date);
                    if (!groupedTrans.containsKey(dateKey)) {
                      groupedTrans[dateKey] = [];
                    }
                    groupedTrans[dateKey]!.add(t);
                  }
                  final dateKeys = groupedTrans.keys.toList();

                  if (allTransactions.isEmpty) {
                    return const Center(
                      child: Text("Không có giao dịch nào", style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(10)).copyWith(bottom: Responsive.h(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Responsive.w(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: Responsive.w(2),
                          blurRadius: Responsive.w(8),
                          offset: Offset(0, Responsive.h(4)),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(Responsive.w(15)),
                      itemCount: dateKeys.length,
                      itemBuilder: (context, index) {
                        String currentDate = dateKeys[index];
                        List<TransactionRecord> dailyTrans = groupedTrans[currentDate]!;

                        List<Map<String, dynamic>> mappedTransactions = dailyTrans.map((t) {
                          String minute = t.date.minute.toString().padLeft(2, '0');
                          String timeString = "${t.date.hour}:$minute";
                          String tSign = t.type == 'income' ? '+' : '-';

                          return {
                            "id": t.id,
                            "title": t.title,
                            "time": timeString,
                            "money": "$tSign${Format.formatnumber(t.amount)} đ",
                            "icon": AppIcons.getIconFromData(t.icon),
                            "color": t.type == 'income' ? Colors.green : Colors.red,
                          };
                        }).toList();

                        return Cardshowhistorytrade(
                          date: currentDate,
                          transactions: mappedTransactions,
                          onSelect: (id, val) {},
                          onSelectAll: (val) {},
                          onLongPress: (id) {},
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}