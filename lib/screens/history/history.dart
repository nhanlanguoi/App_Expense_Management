import 'package:flutter/material.dart';
import '../../components/cardshowvalue/CardShowHistoryTrade.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List<Map<String, dynamic>> dummyTransactions = [
    {
      "id": "1",
      "title": "Ăn trưa",
      "time": "12:30",
      "money": "-45.000 đ",
      "icon": Icons.fastfood,
      "color": Colors.red,
    },
    {
      "id": "2",
      "title": "Tiền lương",
      "time": "09:00",
      "money": "+10.000.000 đ",
      "icon": Icons.payments,
      "color": Colors.green,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
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
                    const Text(
                      "Lịch sử giao dịch",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                    const SizedBox(height: 35),
                    const Text(
                      "Tổng giao dịch",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "1.231.432 đ",
                      style: TextStyle(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                children: [
                  Cardshowhistorytrade(
                    date: "Hôm nay, 24/10/2023",
                    transactions: dummyTransactions,
                    onSelect: (id, val) {},
                    onSelectAll: (val) {},
                    onLongPress: (id) {},
                  ),
                  Cardshowhistorytrade(
                    date: "Hôm qua, 23/10/2023",
                    transactions: dummyTransactions,
                    onSelect: (id, val) {},
                    onSelectAll: (val) {},
                    onLongPress: (id) {},
                  ),
                  Cardshowhistorytrade(
                    date: "Hôm kia, 22/10/2023",
                    transactions: dummyTransactions,
                    onSelect: (id, val) {},
                    onSelectAll: (val) {},
                    onLongPress: (id) {},
                  ),
                  Cardshowhistorytrade(
                    date: "Thứ 6, 20/10/2023",
                    transactions: dummyTransactions,
                    onSelect: (id, val) {},
                    onSelectAll: (val) {},
                    onLongPress: (id) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}