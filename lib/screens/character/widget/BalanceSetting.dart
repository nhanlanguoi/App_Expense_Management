import 'package:flutter/material.dart';

import '../../../components/inputs/CustomTextField.dart';
import '../../../components/widget/BaseSettingLayout.dart';


class BalanceSettingScreen extends StatefulWidget {
  const BalanceSettingScreen({super.key});

  @override
  State<BalanceSettingScreen> createState() => _BalanceSettingScreenState();
}

class _BalanceSettingScreenState extends State<BalanceSettingScreen> {
  final TextEditingController _balanceController = TextEditingController();

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSettingLayout(
      title: "Thiết lập số dư",
      onSave: () {
        if (_balanceController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Vui lòng nhập số dư!"),
                  backgroundColor: Colors.red
              )
          );
          return;
        }

        print("Số dư thiết lập: ${_balanceController.text}");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đã cập nhật số dư thành công!"))
        );
        Navigator.pop(context);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nhập số dư hiện tại của bạn",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'BeVietnamPro'
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Số dư này sẽ được dùng làm mức cơ sở ban đầu để tính toán tổng tài sản và phân tích chi tiêu của bạn.",
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'BeVietnamPro',
                height: 1.5
            ),
          ),
          const SizedBox(height: 30),
          const Text(
              "Số dư (₫)",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontFamily: 'BeVietnamPro'
              )
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _balanceController,
            hintText: "VD: 1.000.000",
            keyboardType: TextInputType.number,
            suffixIcon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }
}