import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/screens/home/widgets/CategoryCard.dart';
import 'package:flutter/material.dart';

import '../../components/widget/purple_header.dart';
import '../../core/utils/responsive.dart';

class Categorymanager extends StatefulWidget {
  const Categorymanager({super.key});

  @override
  State<Categorymanager> createState() => _CategorymanagerState();
}

class _CategorymanagerState extends State<Categorymanager> {

  @override
  Widget build(BuildContext context) {

    Responsive.init(context);

    return Scaffold(
      body: Column(
        children: [

          /// Header
          Stack(
            children: [
              PurpleHeader(height: Responsive.h(120)),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(20),
                    vertical: Responsive.h(20),
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
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: Responsive.sp(23),
                          ),
                          width: Responsive.w(40),
                          height: Responsive.h(40),
                          borderRadius: Responsive.w(50),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),

                      Text(
                        "Quản lý danh mục",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(20),
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

          SizedBox(height: Responsive.h(15)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
            child: Column(
              children: [

                custombutton(
                  onPressed: (){},
                  label: 'Tạo nhóm danh mục',

                  height: Responsive.h(55),
                  borderRadius: Responsive.w(30),
                  width: Responsive.w(400),

                  icon: Icon(
                    Icons.create_new_folder_rounded,
                    color: Colors.white,
                    size: Responsive.sp(25),
                  ),

                  labelStyle: TextStyle(
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BeVietnamPro',
                  ),

                  backgroundColor: const Color(0xFF9147F2),
                ),

                SizedBox(height: Responsive.h(18)),

                CategoryCard(
                  title: "Di chuyển",
                  icon: Icons.directions_car,
                  iconColor: Colors.blueAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}