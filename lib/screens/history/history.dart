import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/cardshowvalue/CardShowHistoryTrade.dart';
import '../../data/service/authservice.dart';
import '../../data/service/transactionservice.dart';
import '../../data/service/walletservice.dart';
import '../../model/transactions.dart';
import '../../configs/theme/icon.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime _selectedMonth = DateTime.now();
  bool _isExpense = true;

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);

    String dateString = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    if (aDate == today) return "history.today".tr() + " $dateString";
    if (aDate == yesterday) return "history.yesterday".tr() + " $dateString";
    return dateString;
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + offset, 1);
    });
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
          final walletService = WalletService();

          List<TransactionRecord> allTransactions = transService.getAllUserTransactions(currentUser.email);

          final userWallets = walletService.getWallets(currentUser.email);
          Map<String, String> walletIdToName = {};
          for (var w in userWallets) {
            walletIdToName[w.id ?? ''] = w.name ?? 'Ví không tên';
          }
          List<TransactionRecord> monthlyTransactions = allTransactions.where((t) {
            return t.date.month == _selectedMonth.month && t.date.year == _selectedMonth.year;
          }).toList();

          Map<String, double> chartData = {};
          double totalChartAmount = 0;

          for (var t in monthlyTransactions) {
            if ((_isExpense && t.type == 'expense') || (!_isExpense && t.type == 'income')) {
              String walletName = walletIdToName[t.walletId] ?? 'Ví khác';
              chartData[walletName] = (chartData[walletName] ?? 0) + t.amount;
              totalChartAmount += t.amount;
            }
          }

          final List<Color> sectionColors = [
            Colors.blue, Colors.orange, Colors.purple,
            Colors.green, Colors.redAccent, Colors.teal, Colors.cyan
          ];
          Map<String, Color> walletColors = {};
          int colorIndex = 0;
          for (var key in chartData.keys) {
            walletColors[key] = sectionColors[colorIndex % sectionColors.length];
            colorIndex++;
          }
          List<TransactionRecord> sortedTransactions = List.from(allTransactions);
          sortedTransactions.sort((a, b) => b.date.compareTo(a.date));

          List<TransactionRecord> recentTransactions = sortedTransactions.take(5).toList();

          Map<String, List<TransactionRecord>> groupedRecentTrans = {};
          for (var t in recentTransactions) {
            String dateKey = formatDate(t.date);
            if (!groupedRecentTrans.containsKey(dateKey)) {
              groupedRecentTrans[dateKey] = [];
            }
            groupedRecentTrans[dateKey]!.add(t);
          }
          final recentDateKeys = groupedRecentTrans.keys.toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. PHẦN TRÊN: BIỂU ĐỒ
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 25, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "history.title".tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BeVietnamPro',
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Tổng quan",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'BeVietnamPro',
                            ),
                          ),
                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(() => _isExpense = true),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                              color: _isExpense ? Colors.red : Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text("Chi", style: TextStyle(
                                                  color: _isExpense ? Colors.white : Colors.black54,
                                                  fontWeight: FontWeight.bold
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(() => _isExpense = false),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                              color: !_isExpense ? Colors.green : Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text("Thu", style: TextStyle(
                                                  color: !_isExpense ? Colors.white : Colors.black54,
                                                  fontWeight: FontWeight.bold
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: () => _changeMonth(-1),
                                    ),
                                    Text(
                                      "Tháng ${_selectedMonth.month}, ${_selectedMonth.year}",
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.chevron_right),
                                      onPressed: () => _changeMonth(1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                SizedBox(
                                  height: 300,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      PieChart(
                                        PieChartData(
                                          sectionsSpace: 2,
                                          centerSpaceRadius: 90,
                                          sections: _buildChartSections(chartData, walletColors),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_isExpense ? "Tổng chi" : "Tổng thu",
                                              style: const TextStyle(fontSize: 20, color: Colors.black)),
                                          Text(
                                            "${totalChartAmount.toStringAsFixed(0)} đ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: _isExpense ? Colors.red : Colors.green
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: chartData.keys.map((walletName) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: walletColors[walletName],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(walletName, style: const TextStyle(fontSize: 14)),
                                          ),
                                          Text(
                                            "${chartData[walletName]?.toStringAsFixed(0)} đ",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Giao dịch gần đây",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Chuyển sang trang xem tất cả giao dịch");
                        },
                        child: const Text(
                          "Xem tất cả",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ĐÃ BỎ Expanded, THÊM shrinkWrap VÀ physics
                recentTransactions.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Text("Không có giao dịch nào", style: const TextStyle(color: Colors.grey)),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: recentDateKeys.length,
                    itemBuilder: (context, index) {
                      String currentDate = recentDateKeys[index];
                      List<TransactionRecord> dailyTrans = groupedRecentTrans[currentDate]!;

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
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(Map<String, double> data, Map<String, Color> colors) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 1,
          title: '',
          radius: 30,
        )
      ];
    }

    return data.entries.map((entry) {
      return PieChartSectionData(
        color: colors[entry.key]!,
        value: entry.value,
        title: '',
        radius: 30,
      );
    }).toList();
  }
}