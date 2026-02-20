import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(25),
      ),
      backgroundColor: Colors.white,
      elevation: 10,

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Thêm ví mới", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),


              const TextField(
                decoration: InputDecoration(
                    labelText: "Tên ví ",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 15),


              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Số dư ban đầu (VNĐ)",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20),

              const Text("Chọn màu sắc", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Chọn biểu tượng", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: const Text("Lưu Ví", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}