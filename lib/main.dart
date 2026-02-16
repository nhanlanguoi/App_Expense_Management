
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home/Home.dart';
import 'package:expense_management/configs/routes/routes.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/screens/auth/auth_screen.dart';

//
// void main(){
//   runApp(const Main());
// }
//
// class Main extends StatelessWidget {
//   const Main({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: Routesname.home,
//       onGenerateRoute: Routes.generateRoute,
//     );
//   }
// }



void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AuthScreen(),
  ));
}

