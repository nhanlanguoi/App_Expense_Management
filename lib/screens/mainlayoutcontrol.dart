import 'package:flutter/material.dart';
import 'package:expense_management/components/bottomnavbar/Bottomnavbar.dart';
import 'package:expense_management/screens/home/Home.dart';
import '../model/users.dart';
import 'package:expense_management/screens/home/widgets/AddWallet.dart';

class MainLayout extends StatefulWidget {
  final Users user;
  const MainLayout({super.key, required this.user});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {

    final List<Widget> _screens = [
      MyHome(users: widget.user,),
      const Center(child: Text("Thống kê")),
      const Center(child: Text("Lịch sử")),
      const Center(child: Text("Cá nhân")),
    ];
    
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (context) {
              return Addwallet();
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Bottomnavbar(
        listicon: const [
          Icons.home,
          Icons.analytics_outlined,
          Icons.history_sharp,
          Icons.person,
        ],
        activeIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}