import 'package:expense_management/components/cardshowvalue/CardShowPriceTradeofCard.dart';
import 'package:flutter/material.dart';

class Cardshowhistorytrade extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> transactions;
  final bool isSelectionMode;
  final List<String> selectedIds;
  final Function(String, bool) onSelect;
  final Function(bool) onSelectAll;
  final Function(String) onLongPress;

  const Cardshowhistorytrade({
    super.key,
    required this.date,
    required this.transactions,
    this.isSelectionMode = false,
    this.selectedIds = const [],
    required this.onSelect,
    required this.onSelectAll,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    bool isAllSelected = transactions.every((t) => selectedIds.contains(t['id']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date ,style: TextStyle(fontSize: 15),),
              if (isSelectionMode)
                Checkbox(
                  shape: const CircleBorder(),
                  value: isAllSelected,
                  activeColor: Colors.red,
                  onChanged: (value) => onSelectAll(value ?? false),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: List.generate(transactions.length, (index) {
              final item = transactions[index];
              bool isSelected = selectedIds.contains(item['id']);

              return GestureDetector(
                onLongPress: () => onLongPress(item['id']),
                onTap: () {
                  if (isSelectionMode) {
                    onSelect(item['id'], !isSelected);
                  }
                },
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Cardshowpricetrade(
                              title: item['title'],
                              time: item['time'],
                              allmoney: item['money'],
                              Icon: item['icon'],
                              Iconcolor: item['color'],
                            ),
                          ),
                          if (isSelectionMode)
                            Checkbox(
                              shape: const CircleBorder(),
                              value: isSelected,
                              activeColor: Colors.red,
                              onChanged: (value) => onSelect(item['id'], value ?? false),
                            ),
                          SizedBox(width: 10,)
                        ],
                      ),
                      if (index != transactions.length - 1)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(thickness: 1.5,color: Colors.grey.shade200,),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}