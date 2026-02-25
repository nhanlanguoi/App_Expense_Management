import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../components/cardshowvalue/CardShowHistoryTrade.dart';
import '../../core/data/service/authservice.dart';
import '../../core/data/service/transactionservice.dart';
import '../../core/model/transactions.dart';
import '../../configs/theme/color.dart';
import '../../configs/theme/icon.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);

    String dateString = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    if (aDate == today) return "history.today".tr() + "$dateString";
    if (aDate == yesterday) return "history.yesterday".tr() + "$dateString";
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ValueListenableBuilder(
        valueListenable: Hive.box('transactions').listenable(),
        builder: (context, box, child) {
          final currentUser = AuthService().currentUser;
          if (currentUser == null) {
            return Center(child: Text("history.please_login".tr()));
          }
          final transService = TransactionService();
          List<TransactionRecord> allTransactions = transService.getAllUserTransactions(currentUser.email);
          double totalAmount = transService.getTotalNetBalance(allTransactions);
          String sign = totalAmount > 0 ? '+' : (totalAmount < 0 ? '-' : '');
          String totalAmountStr = "$sign${totalAmount.abs().toStringAsFixed(0)} đ";
          Map<String, List<TransactionRecord>> groupedTrans = {};
          for (var t in allTransactions) {
            String dateKey = formatDate(t.date);
            if (!groupedTrans.containsKey(dateKey)) {
              groupedTrans[dateKey] = [];
            }
            groupedTrans[dateKey]!.add(t);
          }
          final dateKeys = groupedTrans.keys.toList();

          return Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.shade100,
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "history.title".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BeVietnamPro',
                          ),
                        ),
                        const SizedBox(height: 35),
                        Text(
                          "history.total".tr(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'BeVietnamPro',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          totalAmountStr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'BeVietnamPro',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: allTransactions.isEmpty
                    ? Center(child: Text("history.no_transaction".tr(), style: const TextStyle(color: Colors.grey)))
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                          "money": "$tSign${t.amount.toStringAsFixed(0)} đ",
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}