import 'package:expense_management/components/cardshowvalue/CardShowPriceTradeofCard.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/cardshowvalue/CardShowHistoryTrade.dart';
class Cardshowhistorytrade extends StatelessWidget {


  const Cardshowhistorytrade({
    super.key,
  });
  final List<Map<String, dynamic>> fakeData = const [
    {
      "title": "Phở bò",
      "time": "7:30",
      "money": "45.000",
      "icon": Icons.rice_bowl,
      "color": Colors.orange
    },
    {
      "title": "Cà phê",
      "time": "8:15",
      "money": "25.000",
      "icon": Icons.local_cafe,
      "color": Colors.brown
    },
    {
      "title": "Grab đi làm",
      "time": "8:45",
      "money": "32.000",
      "icon": Icons.directions_car,
      "color": Colors.green
    },
    {
      "title": "Ăn trưa",
      "time": "12:00",
      "money": "55.000",
      "icon": Icons.fastfood,
      "color": Colors.red
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[150],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),

      child: Column(
        children: List.generate(fakeData.length, (index) {
          final item = fakeData[index];
          return Column(
            children: [

              Cardshowpricetrade(
                title: item['title'],
                time: item['time'],
                allmoney: item['money'],
                Icon: item['icon'],
                Iconcolor: item['color'],

              ),
              // Thêm đường kẻ, trừ phần tử cuối cùng
              if (index != fakeData.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Divider(thickness: 1, height: 1),
                ),
            ],
          );
        }),
      ),
    );
  }
}
