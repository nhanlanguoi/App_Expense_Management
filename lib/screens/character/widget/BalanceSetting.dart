import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../components/inputs/CustomTextField.dart';
import '../../../components/widget/BaseSettingLayout.dart';
import '../../../core/data/service/authservice.dart';
import 'package:expense_management/core/utils/responsive.dart';


class BalanceSettingScreen extends StatefulWidget {
  const BalanceSettingScreen({super.key});

  @override
  State<BalanceSettingScreen> createState() => _BalanceSettingScreenState();
}

class _BalanceSettingScreenState extends State<BalanceSettingScreen> {
  final TextEditingController _balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      _balanceController.text = user.totalBalance.toInt().toString();
    }
  }
  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSettingLayout(
      title: "settings.balance_title".tr(),
      onSave: () async {
        if (_balanceController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("settings.balance_empty_error".tr()),
                  backgroundColor: Colors.red
              )
          );
          return;
        }
        double? newBalance = double.tryParse(_balanceController.text);
        if (newBalance == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Vui lòng nhập số hợp lệ!"),
                  backgroundColor: Colors.red
              )
          );
          return;
        }
        final user = AuthService.instance.currentUser;
        if (user != null) {
          await AuthService.instance.updateUserBalance(user.email, newBalance);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("settings.balance_saved".tr()),
                  backgroundColor: Colors.green,
                )
            );
            Navigator.pop(context);
          }
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "settings.enter_balance".tr(),
            style: TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.bold,
                fontFamily: 'BeVietnamPro'
            ),
          ),
          SizedBox(height: Responsive.h(10)),
          Text(
            "settings.balance_desc".tr(),
            style: TextStyle(
                fontSize: Responsive.sp(14),
                color: Colors.grey,
                fontFamily: 'BeVietnamPro',
                height: 1.5
            ),
          ),
          SizedBox(height: Responsive.h(30)),
          Text(
              "settings.balance_label".tr(),
              style: TextStyle(
                  fontSize: Responsive.sp(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontFamily: 'BeVietnamPro'
              )
          ),
          SizedBox(height: Responsive.h(8)),
          CustomTextField(
            controller: _balanceController,
            hintText: "settings.balance_hint".tr(),
            keyboardType: TextInputType.number,
            suffixIcon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }
}