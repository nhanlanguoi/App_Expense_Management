import 'package:flutter/material.dart';

import '../../../components/buttons/custombutton.dart';
import '../../../components/inputs/CustomTextField.dart';

class Addwallet extends StatefulWidget {
  const Addwallet({super.key});

  @override
  State<Addwallet> createState() => _AddwalletState();
}

class _AddwalletState extends State<Addwallet> {
  Color selectedColor = const Color(0xFF3B82F6);
  IconData selectedIcon = Icons.account_balance_wallet_outlined;

  List<Color> displayColors = [
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFFF97316),
    const Color(0xFFA855F7),
  ];

  void showColorPicker() {
    final List<Color> moreColors = [
      Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
      Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
      Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
      Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
      Colors.brown, Colors.blueGrey, Colors.black87, Colors.tealAccent
    ];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Chọn màu sắc", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: moreColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                          if (!displayColors.contains(color)) {
                            displayColors.insert(0, color);
                            displayColors.removeLast();
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<IconData> displayIcons = [
    Icons.account_balance_wallet_outlined,
    Icons.savings_outlined,
    Icons.payments_outlined,
    Icons.credit_card_outlined,
  ];

  void showIconPicker() {
    final List<IconData> moreIcons = [
      Icons.shopping_cart_outlined, Icons.fastfood_outlined, Icons.local_gas_station_outlined,
      Icons.flight_outlined, Icons.medical_services_outlined, Icons.school_outlined,
      Icons.home_outlined, Icons.phone_android_outlined, Icons.laptop_outlined,
      Icons.pets_outlined, Icons.fitness_center_outlined, Icons.movie_outlined,
      Icons.music_note_outlined, Icons.sports_esports_outlined, Icons.restaurant_outlined,
      Icons.coffee_outlined, Icons.stroller_outlined, Icons.directions_car_outlined,
      Icons.redeem_outlined, Icons.favorite_border_outlined
    ];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Chọn biểu tượng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: moreIcons.map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                          if (!displayIcons.contains(icon)) {
                            displayIcons.insert(0, icon);
                            displayIcons.removeLast();
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedIcon == icon ? const Color(0xFF3B82F6).withOpacity(0.1) : Colors.grey[100],
                            border: Border.all(
                              color: selectedIcon == icon ? const Color(0xFF3B82F6) : Colors.transparent,
                            )
                        ),
                        child: Icon(icon, color: selectedIcon == icon ? const Color(0xFF3B82F6) : Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro'),
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
              const Text("Chọn màu sắc", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...displayColors.map((color) {
                    bool isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 45, height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: color, width: 2) : null,
                        ),
                        padding: EdgeInsets.all(isSelected ? 3 : 0),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                        ),
                      ),
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: showColorPicker,
                    child: Container(
                      width: 45, height: 45,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
                      child: const Icon(Icons.add, color: Colors.black54),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              const Text("Chọn biểu tượng", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...displayIcons.map((icon) {
                    bool isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = icon),
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.withOpacity(0.2),
                            width: 1.5,
                          ),
                          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.05) : Colors.transparent,
                        ),
                        child: Icon(icon, color: isSelected ? const Color(0xFF3B82F6) : Colors.black87),
                      ),
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: showIconPicker,
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
                      ),
                      child: const Icon(Icons.grid_view_outlined, color: Colors.black87),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 32),

              custombutton(
                label: "Lưu Ví",
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                height: 55, width: double.infinity, borderRadius: 16,
                backgroundColor: const Color(0xFF3B82F6), textColor: Colors.white,
                onPressed: () {
                  print("Đã Lưu Ví - Icon: $selectedIcon, Màu: $selectedColor");
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