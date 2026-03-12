import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/screens/home/widgets/MonthlySpendingCard.dart';
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';
import 'package:expense_management/components/cardshowvalue/CardGeneralTotal.dart';
import 'package:expense_management/components/cardshowvalue/CardManagerExpense.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/icon.dart';

import '../../core/data/service/transactionservice.dart';
import '../../core/data/service/walletservice.dart';
import '../../core/model/users.dart';

import 'package:expense_management/components/widget/purple_header.dart';
import 'package:expense_management/core/utils/responsive.dart';

import '../../core/utils/format.dart';
import 'categorymanager.dart';

class MyHome extends StatefulWidget {
  final Users users;
  const MyHome({super.key, required this.users});
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final ScrollController _scrollController = ScrollController();
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > Responsive.h(40) && !_collapsed) {
        setState(() {
          _collapsed = true;
        });
      } else if (_scrollController.offset <= Responsive.h(40) && _collapsed) {
        setState(() {
          _collapsed = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _HomeHeader() {
    return Stack(
      children: [
        PurpleHeader(height: Responsive.h(245)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(15), vertical: Responsive.h(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Circleavatar(),
                    SizedBox(width: Responsive.w(15)),
                    Expanded(
                        child: CardInfo(
                          username: widget.users.username,
                        )),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Categorymanager(users: widget.users,)));
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: Responsive.sp(20),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Responsive.h(20)),
                CardGeneralTotal(
                    total: 24580000, income: 30000000, expense: 5420000)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _monlySpending() {
    List<int> months = [1,2,3,4,5,6,7,8,9,10,11,12];
    int _selectedMonth = DateTime.now().month;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(15)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chi tiêu tháng này",
                style: TextStyle(
                  fontSize: Responsive.sp(16),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BeVietnamPro',
                ),
              ),
              DropdownButton<int>(
                value: _selectedMonth,
                underline: const SizedBox(),
                items: months.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(
                      "Tháng $m",
                      style: TextStyle(
                        fontSize: Responsive.sp(14),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'BeVietnamPro',
                        color: const Color(0xFF7B3FE4),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedMonth = value;
                  });
                },
              ),
            ],
          ),
          MonthlySpendingCard(
            collapsed: _collapsed,
            spent: 5420000,
            total: 30000000,
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      body: Column(
        children: [
          _HomeHeader(),
          SizedBox(height: Responsive.h(1)),
          _monlySpending(),
          SizedBox(height: Responsive.h(10)),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(10)),
              child: ValueListenableBuilder(
                valueListenable: Hive.box('wallets').listenable(),
                builder: (context, Box box, widget) {

                  final myWallets =
                  WalletService().getWallets(this.widget.users.email);

                  if (myWallets.isEmpty) {
                    return Center(child: Text("home.no_wallet".tr()));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: Responsive.h(80)),
                    itemCount: myWallets.length,
                    itemBuilder: (context, index) {
                      final wallet = myWallets[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: Responsive.h(16)),
                        child: Dismissible(
                          key: Key(wallet.id!),
                          direction: DismissDirection.endToStart,
                          movementDuration:
                          const Duration(milliseconds: 300),
                          resizeDuration:
                          const Duration(milliseconds: 250),

                          background: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFFF4B4B),
                                borderRadius:
                                BorderRadius.circular(Responsive.w(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF4B4B)
                                        .withOpacity(0.3),
                                    blurRadius: Responsive.w(10),
                                    offset:
                                    const Offset(0, 4),
                                  )
                                ]),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(
                                right: Responsive.w(24)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "home.delete_wallet".tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.sp(15),
                                      fontFamily: 'BeVietnamPro'),
                                ),
                                SizedBox(width: Responsive.w(8)),
                                Icon(Icons.delete_sweep_rounded,
                                    color: Colors.white,
                                    size: Responsive.sp(28)),
                              ],
                            ),
                          ),

                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Responsive.w(24))),
                                  elevation: 10,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.all(Responsive.w(24)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              Responsive.w(16)),
                                          decoration: BoxDecoration(
                                            color:
                                            Colors.red.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                              Icons.warning_rounded,
                                              color: Colors.redAccent,
                                              size: Responsive.sp(40)),
                                        ),
                                        SizedBox(height: Responsive.h(20)),

                                        Text(
                                          "home.delete_wallet_confirm".tr(),
                                          style: TextStyle(
                                              fontSize: Responsive.sp(20),
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                              'BeVietnamPro'),
                                        ),
                                        SizedBox(height: Responsive.h(12)),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                style: TextButton.styleFrom(
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                      Responsive.h(
                                                          14)),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          Responsive.w(
                                                              12))),
                                                  backgroundColor: Colors
                                                      .grey.shade100,
                                                ),
                                                child: Text(
                                                    "home.cancel".tr(),
                                                    style: const TextStyle(
                                                        color:
                                                        Colors.black87,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600)),
                                              ),
                                            ),
                                            SizedBox(
                                                width: Responsive.w(12)),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                style:
                                                ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  const Color(
                                                      0xFFFF4B4B),
                                                  elevation: 0,
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                      Responsive.h(
                                                          14)),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          Responsive.w(
                                                              12))),
                                                ),
                                                child: Text(
                                                    "home.delete_now".tr(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          onDismissed: (direction) {
                            WalletService().deleteWallet(wallet.id!);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: Responsive.w(12)),
                                    Text("home.deleted_wallet".tr() +
                                        " ${wallet.name}"),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Responsive.w(12))),
                                margin: EdgeInsets.only(
                                    bottom: Responsive.h(20),
                                    left: Responsive.w(20),
                                    right: Responsive.w(20)),
                                backgroundColor: Colors.grey.shade800,
                                duration:
                                const Duration(seconds: 2),
                              ),
                            );
                          },

                          child: ValueListenableBuilder(
                              valueListenable: Hive.box('transactions').listenable(),
                              builder: (context, transactionBox, widgetChild) {
                                return Cardmanagerexpense(
                                  title: Format.formattext(wallet.name),
                                  allmoney: "${Format.formatnumber(wallet.balance)}",
                                  Icon: AppIcons.getIconFromData(wallet.icon),
                                  Iconcolor: AppColors.getColorFromHex(wallet.color),
                                  total: "${TransactionService().gettotalTransaction(wallet.id!)} "+"home.transactions_count".tr(),
                                  percen: wallet.balance > 0
                                      ? (TransactionService().getpriceTransaction(wallet.id!) / wallet.balance)
                                      : 0.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => categoryDetail(wallet: wallet),
                                      ),
                                    );
                                  },
                                );
                              }
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}