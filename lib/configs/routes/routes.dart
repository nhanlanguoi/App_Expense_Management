import 'package:flutter/material.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/screens/home/Home.dart';
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routesname.home:
        return MaterialPageRoute(builder: (context) => const MyHome());

      case Routesname.detail:
        return MaterialPageRoute(builder: (context) => const  categoryDetail());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy đường dẫn!')),
          );
        });
    }
  }
}