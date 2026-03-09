
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../model/transactions.dart';

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
              const Divider(height: 1),
              _buildOption(3, "3 Tháng gần đây"),
              _buildOption(6, "6 Tháng gần đây"),
              _buildOption(12, "12 Tháng gần đây"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(int value, String title) {
    return ListTile(
      title: Text(title, style: TextStyle(
        fontWeight: _selectedMonths == value ? FontWeight.bold : FontWeight.normal,
        color: _selectedMonths == value ? Colors.blue : Colors.black,
      )),
      trailing: _selectedMonths == value ? const Icon(Icons.check, color: Colors.blue) : null,
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
        'month': "T${monthTarget.month}",
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
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 350,
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
                          String type = rodIndex == 0 ? "Thu" : "Chi";
                          return BarTooltipItem(
                            "$type\n${rod.toY.toStringAsFixed(0)} đ",
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          getTitlesWidget: (value, meta) => const SizedBox(),
                        ),
                      ),


                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 15,
                          getTitlesWidget: (value, meta) => const SizedBox(),
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
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
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
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
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4)),
                          ),
                          BarChartRodData(
                            toY: expense,
                            color: Colors.redAccent,
                            width: 20,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildLegendItem(Colors.green, "Thu"),
                  const SizedBox(width: 15),
                  _buildLegendItem(Colors.redAccent, "Chi"),
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
                        borderRadius: BorderRadius.circular(6),
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
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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