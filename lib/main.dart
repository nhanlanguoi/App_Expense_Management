import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home/Home.dart';

void main(){
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: categoryDetail(),
    );
  }
}
