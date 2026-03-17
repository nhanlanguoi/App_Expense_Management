
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/textstyles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/model/transactions.dart';
import 'package:expense_management/core/utils/responsive.dart';

class BarChartWidget extends StatefulWidget {
  final List<TransactionRecord> transactions;

  const BarChartWidget({required this.transactions});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int _selectedMonths = 3;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showTimeRangePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.floor_background,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(20))),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "statistic.time_range_title".tr(),
                  style: TextStyle(fontSize: Responsive.sp(18), fontWeight: FontWeight.bold),
                ),
              ),
              _buildOption(3, "statistic.last_3_months".tr()),
              _buildOption(6, "statistic.last_6_months".tr()),
              _buildOption(12, "statistic.last_12_months".tr()),
              SizedBox(height: Responsive.h(100),)
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(int value, String title) {
    bool isSelected = _selectedMonths == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonths = value;
          _currentPage = 0;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.sp(15),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blue, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> allChartData = [];
    double maxAmount = 0;

    for (int i = _selectedMonths - 1; i >= 0; i--) {
      DateTime monthTarget = DateTime(now.year, now.month - i, 1);
      double income = 0;
      double expense = 0;

      for (var t in widget.transactions) {
        if (t.date.year == monthTarget.year && t.date.month == monthTarget.month) {
          if (t.type == 'income') income += t.amount;
          if (t.type == 'expense') expense += t.amount;
        }
      }

      if (income > maxAmount) maxAmount = income;
      if (expense > maxAmount) maxAmount = expense;

      allChartData.add({
        'month': "statistic.month_tag".tr(namedArgs: {'month': monthTarget.month.toString()}),
        'income': income,
        'expense': expense,
      });
    }
    double maxY = maxAmount == 0 ? 100000 : maxAmount * 1.2;


    double yInterval = maxAmount == 0 ? 33333 : maxAmount / 3;

    List<List<Map<String, dynamic>>> pages = [];
    for (int i = allChartData.length; i > 0; i -= 3) {
      int start = (i - 3 < 0) ? 0 : i - 3;
      pages.add(allChartData.sublist(start, i));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _showTimeRangePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Responsive.r(12)),
                      border: Border.all(width: 0.5 ,color: Colors.grey)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "statistic.selected_months".tr(namedArgs: {'count': _selectedMonths.toString()}),
                          style: TextStyles.buttonsetting.copyWith(fontWeight:FontWeight.normal ),
                        ),
                        SizedBox(width: Responsive.w(4)),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(350),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: pages.length,
              itemBuilder: (context, pageIndex) {
                List<Map<String, dynamic>> pageData = pages[pageIndex];

                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    maxY: maxY,
                    minY: 0,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String type = rodIndex == 0 ? "statistic.income_short".tr() : "statistic.expense_short".tr();
                          return BarTooltipItem(
                            "$type\n${rod.toY.toStringAsFixed(0)} đ",
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) => SizedBox(),
                        ),
                      ),


                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 15,
                          getTitlesWidget: (value, meta) => SizedBox(),
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < 0 || value.toInt() >= pageData.length) return SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                pageData[value.toInt()]['month'],
                                style: TextStyle(color: Colors.grey, fontSize: Responsive.sp(12), fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) {
                            if (value >= maxY * 0.99) return SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              space: 8,
                              child: Text(
                                _formatAmount(value),
                                style: TextStyle(color: Colors.grey, fontSize: Responsive.sp(13)),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: yInterval,
                      getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                    ),
                    barGroups: pageData.asMap().entries.map((entry) {
                      int index = entry.key;
                      double income = entry.value['income'];
                      double expense = entry.value['expense'];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: income,
                            color: Colors.green,
                            width: 20,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(Responsive.r(4)),topRight: Radius.circular(Responsive.r(4))),
                          ),
                          BarChartRodData(
                            toY: expense,
                            color: Colors.redAccent,
                            width: 20,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(Responsive.r(4)),topRight: Radius.circular(Responsive.r(4))),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Responsive.h(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildLegendItem(Colors.green, "statistic.income_short".tr()),
                  SizedBox(width: Responsive.w(15)),
                  _buildLegendItem(Colors.redAccent, "statistic.expense_short".tr()),
                ],
              ),
              if (pages.length > 1)
                Row(
                  children: List.generate(pages.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPage == index ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(Responsive.r(6)),
                      ),
                    );
                  }),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: Responsive.w(5)),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: Responsive.sp(12))),
      ],
    );
  }


  String _formatAmount(double amount) {
    if (amount >= 1000000000) return "${(amount / 1000000000).toStringAsFixed(1)}T";
    if (amount >= 1000000) return "${(amount / 1000000).toStringAsFixed(1)}tr";
    if (amount >= 1000) return "${(amount / 1000).toStringAsFixed(0)}k";
    return amount.toStringAsFixed(0);
  }
}