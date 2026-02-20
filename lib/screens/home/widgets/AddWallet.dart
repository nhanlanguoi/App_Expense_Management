import 'package:flutter/material.dart';

import '../../../components/buttons/custombutton.dart';
import '../../../components/inputs/CustomTextField.dart';

class Addwallet extends StatefulWidget {
  const Addwallet({super.key});

  @override
  State<Addwallet> createState() => _AddwalletState();
}

class _AddwalletState extends State<Addwallet> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      elevation: 10,
      insetPadding: const EdgeInsets.all(20),

      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    "Thêm Ví Mới",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Tạo ví mới để quản lý chi tiêu hiệu quả hơn",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              const CustomTextField(
                hintText: "Tên ví",
                suffixIcon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: "Số dư ban đầu (VNĐ)",
                suffixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              const Text("Chọn màu sắc", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              const Text("Chọn biểu tượng", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              custombutton(
                label: "Lưu Ví",
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                height: 55,
                width: double.infinity,
                borderRadius: 16,
                backgroundColor: const Color(0xFF3B82F6),
                textColor: Colors.white,
                onPressed: () {
                  print("Đã bấm lưu ví");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}