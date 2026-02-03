import 'package:flutter/material.dart';
import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';
import 'package:expense_management/components/cardshowvalue/CardGeneralTotal.dart';
import 'package:expense_management/components/bottomnavbar/Bottomnavbar.dart';
import 'package:expense_management/components/cardshowvalue/CardManagerExpense.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive header sizing
    final headerHeight = (size.height * 0.28).clamp(200.0, 280.0);
    final headerBgHeight = headerHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header (responsive)
          SizedBox(
            height: headerHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: headerBgHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Circleavatar(),
                        const SizedBox(width: 5),
                        const CardInfo(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionalTranslation(
                    translation: const Offset(0, -0.15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 10000,
                        ),
                        child: const Cardgeneraltotal(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          //Main
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              spacing: 10,
              children: [
                const Cardmanagerexpense(
                  title: "Chơi nhởi",
                  Icon: Icons.gamepad_outlined,
                  allmoney: "2.324.223.234",
                  percen: 0.13,
                  total: "25",
                  Iconcolor: Colors.green,
                ),
                const Cardmanagerexpense(),
                const Cardmanagerexpense(),
                const Cardmanagerexpense(),
                const Cardmanagerexpense(),
                const Cardmanagerexpense(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Bấm nút thêm mới!");
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Bottomnavbar(
        listicon: [
          Icons.home,
          Icons.analytics_outlined,
          Icons.history_sharp,
          Icons.person,
        ],
      ),
    );
  }
}
