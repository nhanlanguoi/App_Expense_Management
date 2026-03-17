import 'package:expense_management/components/cardshowvalue/CardShowHistoryTrade.dart';
import 'package:expense_management/components/widget/purple_header.dart';
import 'package:expense_management/configs/theme/icon.dart';
import 'package:expense_management/core/data/service/transactionservice.dart';
import 'package:expense_management/core/model/transactions.dart';
import 'package:expense_management/core/model/users.dart';
import 'package:expense_management/core/utils/format.dart';
import 'package:expense_management/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Users user;
  final String categoryName;
  final int categoryIconCode;
  final Color headerColor;
  final int month;
  final int year;

  const CategoryDetailScreen({
    super.key,
    required this.user,
    required this.categoryName,
    required this.categoryIconCode,
    required this.headerColor,
    required this.month,
    required this.year,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool isSelectionMode = false;
  List<String> selectedTransIds = <String>[];

  List<TransactionRecord> _categoryTransactions() {
    final all = TransactionService().getAllUserTransactions(widget.user.email);
    return all.where((t) {
      return t.type == 'expense' &&
          t.icon == widget.categoryIconCode.toString() &&
          t.date.month == widget.month &&
          t.date.year == widget.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final iconData = IconData(widget.categoryIconCode, fontFamily: 'MaterialIcons');

    return Scaffold(
      body: Stack(
        children: [
          PurpleHeader(height: Responsive.h(235), color: widget.headerColor),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16)),
              child: Column(
                children: [
                  SizedBox(
                    height: Responsive.h(54),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              if (isSelectionMode) {
                                setState(() {
                                  isSelectionMode = false;
                                  selectedTransIds.clear();
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              isSelectionMode ? Icons.close : Icons.arrow_back,
                              color: Colors.white,
                              size: Responsive.sp(24),
                            ),
                          ),
                        ),
                        Text(
                          widget.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.sp(18),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'BeVietnamPro',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.h(16)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: Responsive.h(12), horizontal: Responsive.w(14)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(Responsive.r(16)),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('transactions').listenable(),
                      builder: (context, _, __) {
                        final listTrans = _categoryTransactions();
                        final totalExpense = listTrans.fold<double>(0, (sum, t) => sum + t.amount);

                        return Column(
                          children: [
                            Text(
                              'Tổng chi tháng ${widget.month}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: Responsive.sp(13),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                            SizedBox(height: Responsive.h(6)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(iconData, color: Colors.white, size: Responsive.sp(18)),
                                SizedBox(width: Responsive.w(6)),
                                Text(
                                  '${Format.formatnumber(totalExpense)} đ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Responsive.sp(28),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'BeVietnamPro',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.h(14)),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('transactions').listenable(),
                      builder: (context, _, __) {
                        final listTrans = _categoryTransactions();

                        if (listTrans.isEmpty) {
                          return Center(
                            child: Text(
                              'Chưa có giao dịch nào cho danh mục này trong tháng đã chọn.',
                              style: TextStyle(
                                fontFamily: 'BeVietnamPro',
                                fontSize: Responsive.sp(13),
                                color: const Color(0xFF98A2B3),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final groupedTrans = <String, List<TransactionRecord>>{};
                        for (final t in listTrans) {
                          final dateString = '${t.date.day}/${t.date.month}/${t.date.year}';
                          groupedTrans.putIfAbsent(dateString, () => <TransactionRecord>[]).add(t);
                        }

                        final dateKeys = groupedTrans.keys.toList();

                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: Responsive.h(18)),
                          itemCount: dateKeys.length,
                          itemBuilder: (context, index) {
                            final currentDate = dateKeys[index];
                            final dailyTrans = groupedTrans[currentDate]!;

                            final mapped = dailyTrans.map((t) {
                              final minute = t.date.minute.toString().padLeft(2, '0');
                              final time = '${t.date.hour}:$minute';
                              final sign = t.type == 'income' ? '+' : '-';
                              final moneyColor = t.type == 'income' ? Colors.green : Colors.red;

                              return {
                                'id': (t.id ?? '').toString(),
                                'title': t.title,
                                'time': time,
                                'money': '$sign${Format.formatnumber(t.amount)} đ',
                                'icon': AppIcons.getIconFromData(t.icon),
                                'color': moneyColor,
                              };
                            }).toList();

                            return Cardshowhistorytrade(
                              date: currentDate,
                              transactions: mapped,
                              enableSwipeToDelete: true,
                              onDismissTransaction: (id) async {
                                await TransactionService().deleteTransactions([id]);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã xóa giao dịch'),
                                    backgroundColor: Color(0xFF344054),
                                  ),
                                );
                              },
                              isSelectionMode: isSelectionMode,
                              selectedIds: selectedTransIds,
                              onLongPress: (id) {
                                if (id.isEmpty) return;
                                setState(() {
                                  isSelectionMode = true;
                                  if (!selectedTransIds.contains(id)) {
                                    selectedTransIds.add(id);
                                  }
                                });
                              },
                              onSelect: (id, isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedTransIds.add(id);
                                  } else {
                                    selectedTransIds.remove(id);
                                  }
                                });
                              },
                              onSelectAll: (isSelected) {
                                setState(() {
                                  for (final t in dailyTrans) {
                                    final id = (t.id ?? '').toString();
                                    if (id.isEmpty) continue;
                                    if (isSelected && !selectedTransIds.contains(id)) {
                                      selectedTransIds.add(id);
                                    } else if (!isSelected) {
                                      selectedTransIds.remove(id);
                                    }
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
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
