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





    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header (responsive)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.shade100,
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Circleavatar(),
                        const SizedBox(width: 15),
                        const Expanded(child: CardInfo()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Cardgeneraltotal(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
