import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  double? _parseMoneyInput(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized);
  }

  double _safeDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      final userMap = Hive.box('users').get(user.email);
      if (userMap is Map) {
        final salary = _safeDouble(userMap['monthly_salary']);
        _balanceController.text = salary.toInt().toString();
      }
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
        final salary = _parseMoneyInput(_balanceController.text);
        if (salary == null) {
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
          await AuthService.instance.updateUserMonthlySalary(user.email, salary);
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