import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/components/cardshowvalue/CardShowTotalofCard.dart';
import 'package:expense_management/components/widget/purple_header.dart';
import 'package:expense_management/screens/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/screens/mainlayoutcontrol.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../components/cardshowvalue/CardShowHistoryTrade.dart';
import '../../../data/service/transactionservice.dart';
import '../../../model/wallet.dart';

class categoryDetail extends StatefulWidget {
  final Wallet wallet;

  const categoryDetail({super.key,  required this.wallet});

  @override
  State<categoryDetail> createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {
  bool isSelectionMode = false;
  List<String> selectedTransIds = [];

  Color _getColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletColor = _getColor(widget.wallet.color);
    return Scaffold(
      body: Stack(
        children: [
          // header tím
          PurpleHeader(height: 250,color: walletColor,
          ),
          // content nằm trên header
          SafeArea(
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child:Column(
                  children: [
                    SizedBox(
                      height: 60,
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
                                  color: Colors.white, size: 30
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            const Text("Tổng chi tháng này",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                            Text(
                              "${widget.wallet.balance} ₫",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(height: 40,),
                    Cardshowtotalofcard(
                      Background: Colors.white,
                    ),
                    SizedBox(height: 20,),

                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        custombutton(
                          onPressed: (){
                            setState(() {
                              var backgroundColor = Colors.purple;
                            });
                          },
                          label: "Tất cả",
                          height: 30,
                          borderRadius: 30,
                          width: 100,
                          backgroundColor: Colors.purple[500],
                          textColor: Colors.white,
                        ),
                        if (isSelectionMode)
                          custombutton(
                            onPressed: () async {
                              if (selectedTransIds.isEmpty) return;
                              await TransactionService().deleteTransactions(selectedTransIds);
                              setState(() {
                                isSelectionMode = false;
                                selectedTransIds.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Đã xóa giao dịch thành công!")),
                              );
                            },
                            label: "Xóa",
                            height: 30,
                            borderRadius: 30,
                            width: 100,
                            backgroundColor: Colors.red[500],
                            textColor: Colors.white,
                          )
                      ],
                    ),
                    SizedBox(height: 20),


                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('transactions').listenable(),
                        builder: (context, box, widgetUI) {

                          final listTrans = TransactionService().getTransactionsByWallet(widget.wallet.id!);

                          if (listTrans.isEmpty) {
                            return const Center(child: Text("Chưa có giao dịch nào."));
                          }

                          Map<String, List<dynamic>> groupedTrans = {};

                          for (var t in listTrans) {
                            String dateString = "${t.date.day}/${t.date.month}/${t.date.year}";

                            if (!groupedTrans.containsKey(dateString)) {
                              groupedTrans[dateString] = [];
                            }
                            groupedTrans[dateString]!.add(t);
                          }

                          final dateKeys = groupedTrans.keys.toList();

                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: dateKeys.length,
                            itemBuilder: (context, index) {

                              String currentDate = dateKeys[index];
                              List<dynamic> dailyTrans = groupedTrans[currentDate]!;

                              List<Map<String, dynamic>> mappedTransactions = dailyTrans.map((t) {

                                String minute = t.date.minute.toString().padLeft(2, '0');
                                String timeString = "${t.date.hour}:$minute";

                                String sign = t.type == 'income' ? '+' : '-';
                                Color moneyColor = t.type == 'income' ? Colors.green : Colors.red;

                                IconData iconData = Icons.fastfood;
                                if (t.icon == 'local_cafe') iconData = Icons.local_cafe;
                                if (t.icon == 'payments') iconData = Icons.payments;

                                return {
                                  "id": t.id,
                                  "title": t.title,
                                  "time": timeString,
                                  "money": "$sign${t.amount} đ",
                                  "icon": iconData,
                                  "color": moneyColor,
                                };
                              }).toList();
                              return Cardshowhistorytrade(
                                date: currentDate,
                                transactions: mappedTransactions,
                                isSelectionMode: isSelectionMode,
                                selectedIds: selectedTransIds,
                                onLongPress: (id) {
                                  setState(() {
                                    isSelectionMode = true;
                                    if (!selectedTransIds.contains(id)) {
                                      selectedTransIds.add(id);
                                    }
                                  });
                                },
                                onSelect: (id, isSelected) {
                                  setState(() {
                                    if (isSelected) selectedTransIds.add(id);
                                    else selectedTransIds.remove(id);
                                  });
                                },
                                onSelectAll: (isSelected) {
                                  setState(() {
                                    for (var t in dailyTrans) {
                                      if (isSelected && !selectedTransIds.contains(t.id)) {
                                        selectedTransIds.add(t.id);
                                      } else if (!isSelected) {
                                        selectedTransIds.remove(t.id);
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),

              ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          print("Bấm thêm giao dịch cho ví: ${widget.wallet.name}");
        },
        backgroundColor: walletColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
