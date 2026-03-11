import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/screens/home/widgets/CategoryCard.dart';
import 'package:flutter/material.dart';

import '../../components/widget/purple_header.dart';

class Categorymanager extends StatefulWidget {
  const Categorymanager({super.key});

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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              )


            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                custombutton(
                  onPressed: (){
                  },
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
                CategoryCard(
                  title: "Di chuyển",
                  icon: Icons.directions_car, iconColor: Colors.blueAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
