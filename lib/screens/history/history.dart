import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/service/authservice.dart';
import '../../data/service/transactionservice.dart';
import '../../data/service/walletservice.dart';
import '../../model/transactions.dart';

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
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: Hive.box('transactions').listenable(),
        builder: (context, box, child) {
          final currentUser = AuthService().currentUser;
          if (currentUser == null) {
            return Center(child: Text("history.please_login".tr()));
          }
          final transService = TransactionService();
          final walletService = WalletService(); // Khởi tạo WalletService

          List<TransactionRecord> allTransactions = transService.getAllUserTransactions(currentUser.email);

          final userWallets = walletService.getWallets(currentUser.email);
          Map<String, String> walletIdToName = {};
          for (var w in userWallets) {

            walletIdToName[w.id ?? ''] = w.name ;
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

          List<TransactionRecord> displayTransactions = monthlyTransactions.where((t) {
            if (_isExpense) return t.type == 'expense';
            return t.type == 'income';
          }).toList();

          Map<String, List<TransactionRecord>> groupedTrans = {};
          for (var t in displayTransactions) {
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
                        Text(
                          "Tổng quan",
                          style: const TextStyle(
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
                                height: 160,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 55,
                                        sections: _buildChartSections(chartData, walletColors),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(_isExpense ? "Tổng chi" : "Tổng thu",
                                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
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

                              // 3. ĐÃ CHUYỂN THÀNH LIST DỌC BẰNG COLUMN THAY VÌ WRAP
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
                                        // Tên ví căn trái
                                        Expanded(
                                          child: Text(walletName, style: const TextStyle(fontSize: 14)),
                                        ),
                                        // Tổng tiền của ví căn phải (tôi thêm vào để giao diện đẹp và rõ ràng hơn)
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
            ],
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
          radius: 20,
        )
      ];
    }

    return data.entries.map((entry) {
      return PieChartSectionData(
        color: colors[entry.key]!,
        value: entry.value,
        title: '',
        radius: 20,
      );
    }).toList();
  }
}