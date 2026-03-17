import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/components/cardshowvalue/CardShowPriceTradeofCard.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class Cardshowhistorytrade extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> transactions;
  final bool isSelectionMode;
  final List<String> selectedIds;
  final Function(String, bool) onSelect;
  final Function(bool) onSelectAll;
  final Function(String) onLongPress;
  final bool enableSwipeToDelete;
  final Future<void> Function(String id)? onDismissTransaction;

  const Cardshowhistorytrade({
    super.key,
    required this.date,
    required this.transactions,
    this.isSelectionMode = false,
    this.selectedIds = const [],
    required this.onSelect,
    required this.onSelectAll,
    required this.onLongPress,
    this.enableSwipeToDelete = false,
    this.onDismissTransaction,
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
              Text(date ,style: TextStyle(fontSize: Responsive.sp(15)),),
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
        SizedBox(height: Responsive.h(10)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Responsive.r(15)),
          ),
          child: Column(
            children: List.generate(transactions.length, (index) {
              final item = transactions[index];
              final transactionId = (item['id'] ?? '').toString();
              bool isSelected = selectedIds.contains(transactionId);

              final rowContent = GestureDetector(
                onLongPress: () => onLongPress(item['id']),
                onTap: () {
                  if (isSelectionMode) {
                    onSelect(transactionId, !isSelected);
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
                              onChanged: (value) => onSelect(transactionId, value ?? false),
                            ),
                          SizedBox(width: Responsive.w(10),)
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

              if (!enableSwipeToDelete || isSelectionMode || transactionId.isEmpty) {
                return rowContent;
              }

              return Dismissible(
                key: ValueKey('history_$transactionId'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF04438),
                    borderRadius: BorderRadius.circular(Responsive.r(15)),
                  ),
                  child: Icon(Icons.delete_forever_rounded, color: Colors.white, size: Responsive.sp(22)),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text('category_detail.delete_transaction_title'.tr()),
                          content: Text('category_detail.delete_transaction_confirm'.tr()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: Text('common.cancel'.tr()),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, true),
                              child: Text('common.delete'.tr()),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (_) async {
                  if (onDismissTransaction != null) {
                    await onDismissTransaction!(transactionId);
                  }
                },
                child: rowContent,
              );
            }),
          ),
        ),
        SizedBox(height: Responsive.h(20)),
      ],
    );
  }
}