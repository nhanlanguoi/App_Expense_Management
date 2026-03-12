import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/cardshowvalue/CardShowHistoryTrade.dart';
import '../../core/data/service/authservice.dart';
import '../../core/data/service/transactionservice.dart';
import '../../core/data/service/walletservice.dart';
import '../../core/model/transactions.dart';
import '../../configs/theme/icon.dart';
import '../../core/utils/responsive.dart';
import 'all_transactions.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  DateTime _selectedMonth = DateTime.now();
  bool _isExpense = true;
  late AnimationController _bottomSheetController;


  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds:600),
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

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

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.floor_background,
      body: ValueListenableBuilder(
        valueListenable: Hive.box('transactions').listenable(),
        builder: (context, box, child) {
          final currentUser = AuthService().currentUser;
          if (currentUser == null) {
            return Center(child: Text("history.please_login".tr()));
          }
          final transService = TransactionService();
          final walletService = WalletService();

          List<TransactionRecord> allTransactions = transService
              .getAllUserTransactions(currentUser.email);

          final userWallets = walletService.getWallets(currentUser.email);
          Map<String, String> walletIdToName = {};
          for (var w in userWallets) {
            walletIdToName[w.id ?? ''] = w.name ?? 'Ví không tên';
          }
          List<TransactionRecord> monthlyTransactions = allTransactions.where((
              t,
              ) {
            return t.date.month == _selectedMonth.month &&
                t.date.year == _selectedMonth.year;
          }).toList();

          Map<String, double> chartData = {};
          double totalChartAmount = 0;

          for (var t in monthlyTransactions) {
            if ((_isExpense && t.type == 'expense') ||
                (!_isExpense && t.type == 'income')) {
              String walletName = walletIdToName[t.walletId] ?? 'Ví khác';
              chartData[walletName] = (chartData[walletName] ?? 0) + t.amount;
              totalChartAmount += t.amount;
            }
          }

          final List<Color> sectionColors = [
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.green,
            Colors.redAccent,
            Colors.teal,
            Colors.cyan,
          ];
          Map<String, Color> walletColors = {};
          int colorIndex = 0;
          for (var key in chartData.keys) {
            walletColors[key] =
            sectionColors[colorIndex % sectionColors.length];
            colorIndex++;
          }
          List<TransactionRecord> sortedTransactions = List.from(
            allTransactions,
          );
          sortedTransactions.sort((a, b) => b.date.compareTo(a.date));

          List<TransactionRecord> recentTransactions = sortedTransactions
              .take(5)
              .toList();

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
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.h(15),
                      bottom: Responsive.h(25),
                      left: Responsive.w(20),
                      right: Responsive.w(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "history.title".tr(),
                            style: TextStyles.h1.copyWith(color: Colors.black)
                        ),
                        SizedBox(height: Responsive.h(30)),
                        Text(
                            "Tổng quan",
                            style: TextStyles.h2.copyWith(color: Colors.black)
                        ),
                        SizedBox(height: Responsive.h(15)),

                        Container(
                          padding: EdgeInsets.all(Responsive.w(16)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Responsive.w(20)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: Responsive.h(45),
                                padding: EdgeInsets.all(Responsive.w(4)),
                                decoration: BoxDecoration(
                                  color: AppColors.floor_background,
                                  borderRadius: BorderRadius.circular(Responsive.w(30)),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      duration: const Duration(milliseconds: 550),
                                      curve: Curves.easeInOut,
                                      alignment: _isExpense ? Alignment.centerLeft : Alignment.centerRight,
                                      child: FractionallySizedBox(
                                        widthFactor: 0.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(Responsive.w(25)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(50),
                                                blurRadius: Responsive.w(4),
                                                offset: Offset(0, Responsive.h(2)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => _isExpense = true),
                                            child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 250),
                                                style: TextStyle(
                                                  color: _isExpense ? Colors.white : Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'BeVietnamPro',
                                                  fontSize: Responsive.sp(14),
                                                ),
                                                child: const Text("Chi tiêu"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => _isExpense = false),
                                            child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 250),
                                                style: TextStyle(
                                                  color: !_isExpense ? Colors.white : Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'BeVietnamPro',
                                                  fontSize: Responsive.sp(14),
                                                ),
                                                child: const Text("Thu nhập"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Responsive.h(15)),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left_rounded , size: Responsive.w(30), color: Colors.grey,),
                                    onPressed: () => _changeMonth(-1),
                                  ),
                                  Text(
                                    "Tháng ${_selectedMonth.month}, ${_selectedMonth.year}",
                                    style: TextStyle(
                                      fontSize: Responsive.sp(16),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right_rounded ,size: Responsive.w(30),color: Colors.grey,),
                                    onPressed: () => _changeMonth(1),
                                  ),
                                ],
                              ),
                              SizedBox(height: Responsive.h(10)),

                              SizedBox(
                                height: Responsive.h(300),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: Responsive.w(2),
                                        centerSpaceRadius: Responsive.w(90),
                                        sections: _buildChartSections(
                                          chartData,
                                          walletColors,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _isExpense
                                              ? "Tổng chi"
                                              : "Tổng thu",
                                          style: TextStyle(
                                            fontSize: Responsive.sp(20),
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${totalChartAmount.toStringAsFixed(0)} đ",
                                          style: TextStyle(
                                            fontSize: Responsive.sp(16),
                                            fontWeight: FontWeight.bold,
                                            color: _isExpense
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Responsive.h(20)),
                              Column(
                                children: chartData.keys.map((walletName) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: Responsive.h(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: Responsive.w(12),
                                          height: Responsive.h(12),
                                          decoration: BoxDecoration(
                                            color: walletColors[walletName],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: Responsive.w(8)),
                                        Expanded(
                                          child: Text(
                                            walletName,
                                            style: TextStyle(
                                              fontSize: Responsive.sp(14),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${chartData[walletName]?.toStringAsFixed(0)} đ",
                                          style: TextStyle(
                                            fontSize: Responsive.sp(14),
                                            fontWeight: FontWeight.bold,
                                          ),
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

                Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.w(20),
                    right: Responsive.w(20),
                    top: Responsive.h(20),
                    bottom: Responsive.h(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "Giao dịch gần đây",
                          style: TextStyles.h2.copyWith(color: Colors.black)
                      ),
                      GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: const BoxConstraints(maxWidth: double.infinity),
                              transitionAnimationController: _bottomSheetController,
                              builder: (context) {
                                return const AllTransactionsScreen();
                              },
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Text("Xem tất cả" , style: TextStyle(
                                  fontSize: Responsive.sp(16),
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                )),
                                // Container(
                                //   height: 1,
                                //   width:80 ,
                                //   color: Colors.blue,
                                // )
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(10)),


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
                  child:
                  recentTransactions.isEmpty
                      ? Padding(
                    padding: EdgeInsets.only(top: Responsive.h(20), bottom: Responsive.h(40)),
                    child: Text(
                      "Không có giao dịch nào",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(20),vertical: Responsive.h(20)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentDateKeys.length,
                      itemBuilder: (context, index) {
                        String currentDate = recentDateKeys[index];
                        List<TransactionRecord> dailyTrans =
                        groupedRecentTrans[currentDate]!;

                        List<Map<String, dynamic>>
                        mappedTransactions = dailyTrans.map((t) {
                          String minute = t.date.minute.toString().padLeft(
                            2,
                            '0',
                          );
                          String timeString = "${t.date.hour}:$minute";
                          String tSign = t.type == 'income' ? '+' : '-';

                          return {
                            "id": t.id,
                            "title": t.title,
                            "time": timeString,
                            "money":
                            "$tSign${t.amount.toStringAsFixed(0)} đ",
                            "icon": AppIcons.getIconFromData(t.icon),
                            "color": t.type == 'income'
                                ? Colors.green
                                : Colors.red,
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
                )

              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(
      Map<String, double> data,
      Map<String, Color> colors,
      ) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 1,
          title: '',
          radius: Responsive.w(30),
        ),
      ];
    }

    return data.entries.map((entry) {
      return PieChartSectionData(
        color: colors[entry.key]!,
        value: entry.value,
        title: '',
        radius: Responsive.w(30),
      );
    }).toList();
  }
}