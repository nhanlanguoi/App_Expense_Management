import 'package:expense_management/components/cardshowvalue/CardShowPriceTradeofCard.dart';
import 'package:flutter/material.dart';

class Cardshowhistorytrade extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> transactions;

  const Cardshowhistorytrade({
    super.key,
    required this.date,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 10),
          child: Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                spreadRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(transactions.length, (index) {
              final item = transactions[index];
              return Column(
                children: [
                  Cardshowpricetrade(
                    title: item['title'],
                    time: item['time'],
                    allmoney: item['money'],
                    Icon: item['icon'],
                    Iconcolor: item['color'],
                  ),
                  if (index != transactions.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Divider(thickness: 1, height: 0.7),
                    ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}