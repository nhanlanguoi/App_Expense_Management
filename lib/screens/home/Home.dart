import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';
import 'package:expense_management/components/cardshowvalue/CardGeneralTotal.dart';
import 'package:expense_management/components/bottomnavbar/Bottomnavbar.dart';
import 'package:expense_management/components/cardshowvalue/CardManagerExpense.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/model/users.dart';


class MyHome extends StatefulWidget {
  final Users users;
  const MyHome({super.key, required this.users});
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
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
                        Expanded(child: CardInfo(
                          username: widget.users.username,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Cardgeneraltotal(Tongsodu: widget.users.totalBalance,),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Cardmanagerexpense(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routesname.detail,
                      );
                    },
                    title: "Chơi nhởi",
                    Icon: Icons.gamepad_outlined,
                    allmoney: "2.324.223.234",
                    percen: 0.13,
                    total: "25",
                    Iconcolor: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  const Cardmanagerexpense(),
                  const SizedBox(height: 10),
                  const Cardmanagerexpense(),
                  const SizedBox(height: 10),
                  const Cardmanagerexpense(),
                  const SizedBox(height: 10),
                  const Cardmanagerexpense(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}