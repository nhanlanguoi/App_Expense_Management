import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../components/widget/purple_header.dart';
import '../../configs/theme/color.dart';
import '../../configs/theme/icon.dart';
import '../../core/data/service/walletservice.dart';
import '../../core/model/users.dart';

class Categorymanager extends StatefulWidget {
  final Users users;

  const Categorymanager({super.key, required this.users});

  @override
  State<Categorymanager> createState() => _CategorymanagerState();
}

class _CategorymanagerState extends State<Categorymanager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Đây là header
          Stack(
            children: [
              PurpleHeader(height: 140),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: custombutton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: "",
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 25,
                          ),
                          width: 44,
                          height: 44,
                          borderRadius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),

                      const Text(
                        "Quản lý danh mục",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  custombutton(
                    onPressed: () {},
                    label: 'Tạo nhóm danh mục',
                    height: 60,
                    borderRadius: 30,
                    width: 400,
                    icon: Icon(
                      Icons.create_new_folder_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                    ),
                    backgroundColor: Color(0xFF9147F2),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('wallets').listenable(),
                        builder: (context, Box box, widgetChild) {
                          final myWallets = WalletService().getWallets(
                            widget.users.email,
                          );
                          if (myWallets.isEmpty) {
                            return Center(
                              child: Text(
                                "home.no_wallet".tr(),
                                style: const TextStyle(
                                  fontFamily: 'BeVietnamPro',
                                  color: Colors.grey,
                                ),
                              ),
                            );
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
                                  movementDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  resizeDuration: const Duration(
                                    milliseconds: 250,
                                  ),
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF4B4B),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF4B4B,
                                          ).withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
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
                                            fontFamily: 'BeVietnamPro',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.delete_sweep_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.warning_rounded,
                                                    color: Colors.redAccent,
                                                    size: 40,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  "home.delete_wallet_confirm"
                                                      .tr(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'BeVietnamPro',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(false),
                                                        style: TextButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .grey
                                                                  .shade100,
                                                        ),
                                                        child: Text(
                                                          "home.cancel".tr(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(true),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFFFF4B4B,
                                                              ),
                                                          elevation: 0,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "home.delete_now"
                                                              .tr(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
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
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "home.deleted_wallet".tr() +
                                                  " ${wallet.name}",
                                            ),
                                          ],
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 20,
                                          left: 20,
                                          right: 20,
                                        ),
                                        backgroundColor: Colors.grey.shade800,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },

                                  child: GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.getColorFromHex(
                                                wallet.color,
                                              ).withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              AppIcons.getIconFromData(
                                                wallet.icon,
                                              ),
                                              color: AppColors.getColorFromHex(
                                                wallet.color,
                                              ),
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              wallet.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'BeVietnamPro',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${wallet.balance.toStringAsFixed(0)} đ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[700],
                                              fontFamily: 'BeVietnamPro',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
