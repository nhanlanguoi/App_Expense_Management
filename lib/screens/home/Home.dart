import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';
import 'package:expense_management/components/cardshowvalue/CardGeneralTotal.dart';
import 'package:expense_management/components/cardshowvalue/CardManagerExpense.dart';
import 'package:expense_management/model/users.dart';
import 'package:expense_management/data/service/walletservice.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_management/data/service/transactionservice.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/icon.dart';

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
                    return const Center(child: Text("Chưa có ví nào."));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: myWallets.length,
                    itemBuilder: (context, index) {
                      final wallet = myWallets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Cardmanagerexpense(
                          title: wallet.name,

                          allmoney: "${wallet.balance}",

                          Icon: AppIcons.getIconFromData(wallet.icon),
                          Iconcolor: AppColors.getColorFromHex(wallet.color),

                          total: TransactionService().gettotalTransaction(wallet.id!).toString() +" giao dịch",
                          percen: TransactionService().getpriceTransaction(wallet.id!)/wallet.balance,

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => categoryDetail(wallet: wallet),
                              ),
                            );
                          },
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