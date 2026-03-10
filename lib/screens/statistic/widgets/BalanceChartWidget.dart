import 'package:expense_management/configs/theme/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../configs/theme/textstyles.dart';
import '../../../model/transactions.dart';

class BalanceChartWidget extends StatefulWidget {
  final List<TransactionRecord> transactions;

  const BalanceChartWidget({required this.transactions});

  @override
  State<BalanceChartWidget> createState() => _BalanceChartWidgetState();
}

class _BalanceChartWidgetState extends State<BalanceChartWidget> {
  int _selectedMonths = 3;
  int _currentPage = 0;
  late PageController _pageController;
  Map<String, dynamic>? _selectedData;

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

  Widget _buildOption(int value, String title) {
    bool isSelected = _selectedMonths == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonths = value;
          _currentPage = 0;
          _selectedData = null;
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
          borderRadius: BorderRadius.circular(12),
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
                fontSize: 15,
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

  void _showTimeRangePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.floor_background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Chọn khoảng thời gian",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildOption(3, "3 Tháng gần đây"),
              _buildOption(6, "6 Tháng gần đây"),
              _buildOption(12, "12 Tháng gần đây"),
              SizedBox(height: 100,)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> allChartData = [];
    double maxBalance = -double.infinity;
    double minBalance = double.infinity;

    for (int i = _selectedMonths - 1; i >= 0; i--) {
      DateTime monthTarget = DateTime(now.year, now.month - i, 1);
      DateTime nextMonth = DateTime(monthTarget.year, monthTarget.month + 1, 1);

      double cumulativeBalance = 0;
      double monthIncome = 0;
      double monthExpense = 0;

      for (var t in widget.transactions) {

        if (t.date.isBefore(nextMonth)) {
          if (t.type == 'income') cumulativeBalance += t.amount;
          if (t.type == 'expense') cumulativeBalance -= t.amount;
        }

        if (t.date.year == monthTarget.year && t.date.month == monthTarget.month) {
          if (t.type == 'income') monthIncome += t.amount;
          if (t.type == 'expense') monthExpense += t.amount;
        }
      }

      double difference = monthIncome - monthExpense;

      if (cumulativeBalance > maxBalance) maxBalance = cumulativeBalance;
      if (cumulativeBalance < minBalance) minBalance = cumulativeBalance;

      allChartData.add({
        'month': "T${monthTarget.month}",
        'balance': cumulativeBalance,
        'difference': difference,
      });
    }

    if (maxBalance == -double.infinity) maxBalance = 0;
    if (minBalance == double.infinity) minBalance = 0;
    if (minBalance > 0) minBalance = 0;

    double maxY = maxBalance == 0 ? 100000 : maxBalance * 1.2;
    double minY = minBalance < 0 ? minBalance * 1.2 : 0;
    double yInterval = (maxY - minY) == 0 ? 33333 : (maxY - minY) / 3;

    List<List<Map<String, dynamic>>> pages = [];
    for (int i = allChartData.length; i > 0; i -= 3) {
      int start = (i - 3 < 0) ? 0 : i - 3;
      pages.add(allChartData.sublist(start, i));
    }


    Map<String, dynamic>? displayData = _selectedData;
    if (displayData == null && allChartData.isNotEmpty) {
      displayData = allChartData.last;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$_selectedMonths Tháng",
                          style: TextStyles.buttonsetting.copyWith(color: Colors.blue),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (displayData != null)
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Số dư", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        "${displayData['balance'].toStringAsFixed(0)} đ",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Biến động", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        "${displayData['difference'] >= 0 ? '+' : '-'}${displayData['difference'].abs().toStringAsFixed(0)} đ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: displayData['difference'] >= 0 ? Colors.green : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: pages.length,
              itemBuilder: (context, pageIndex) {
                List<Map<String, dynamic>> pageData = pages[pageIndex];

                return LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) => null).toList(),
                      ),
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                        if (touchResponse != null && touchResponse.lineBarSpots != null && touchResponse.lineBarSpots!.isNotEmpty) {
                          int index = touchResponse.lineBarSpots!.first.x.toInt();
                          if (index >= 0 && index < pageData.length) {
                            setState(() {
                              _selectedData = pageData[index];
                            });
                          }
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 20, getTitlesWidget: (v, m) => const SizedBox()),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 15, getTitlesWidget: (v, m) => const SizedBox()),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value != value.toInt()) return const SizedBox();
                            if (value.toInt() < 0 || value.toInt() >= pageData.length) return const SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                pageData[value.toInt()]['month'],
                                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
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
                            if (value >= maxY * 0.99) return const SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              space: 8,
                              child: Text(
                                _formatAmount(value),
                                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
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

                    lineBarsData: [
                      LineChartBarData(
                        spots: pageData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value['balance']);
                        }).toList(),
                        isCurved: false,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            bool isSelected = displayData != null && displayData['month'] == pageData[index]['month'];

                            return FlDotCirclePainter(
                              radius: isSelected ? 8 : 5,
                              color: isSelected ? Colors.blue : Colors.white,
                              strokeWidth: isSelected ? 3 : 2,
                              strokeColor: Colors.blue,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          if (pages.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000000) return "${(amount / 1000000000).toStringAsFixed(1)}T";
    if (amount >= 1000000) return "${(amount / 1000000).toStringAsFixed(1)}tr";
    if (amount >= 1000) return "${(amount / 1000).toStringAsFixed(0)}k";
    return amount.toStringAsFixed(0);
  }
}