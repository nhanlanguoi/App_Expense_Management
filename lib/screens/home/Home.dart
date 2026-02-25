import 'package:easy_localization/easy_localization.dart';
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

class MyHome extends StatefulWidget {
  final Users users;
  const MyHome({super.key, required this.users});
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Circleavatar(),
                        const SizedBox(width: 15),
                        Expanded(child: CardInfo(
                          username: widget.users.username,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Cardgeneraltotal(Tongsodu: widget.users.totalBalance,),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder(
                valueListenable: Hive.box('wallets').listenable(),
                builder: (context, Box box, widget) {

                  final myWallets = WalletService().getWallets(this.widget.users.email);

                  if (myWallets.isEmpty) {
                    return Center(child: Text("home.no_wallet".tr()));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: myWallets.length,
                    itemBuilder: (context, index) {
                      final wallet = myWallets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key(wallet.id!),
                          direction: DismissDirection.endToStart,

                          movementDuration: const Duration(milliseconds: 300),
                          resizeDuration: const Duration(milliseconds: 250),

                          background: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFFF4B4B),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF4B4B).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "home.delete_wallet".tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'BeVietnamPro'
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                              ],
                            ),
                          ),

                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.warning_rounded, color: Colors.redAccent, size: 40),
                                        ),
                                        const SizedBox(height: 20),

                                        Text(
                                          "home.delete_wallet_confirm".tr(),
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro'),
                                        ),
                                        const SizedBox(height: 12),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  backgroundColor: Colors.grey.shade100,
                                                ),
                                                child: Text("home.cancel".tr(), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.of(context).pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFFF4B4B),
                                                  elevation: 0,
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Text("home.delete_now".tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                                    const Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Text("home.deleted_wallet".tr()+" ${wallet.name}"),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                                backgroundColor: Colors.grey.shade800,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },

                          child: ValueListenableBuilder(
                              valueListenable: Hive.box('transactions').listenable(),
                              builder: (context, transactionBox, widgetChild) {
                                return Cardmanagerexpense(
                                  title: wallet.name,
                                  allmoney: "${wallet.balance}",
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