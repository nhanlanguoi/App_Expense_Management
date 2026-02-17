import 'package:flutter/material.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/screens/home/Home.dart';
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:expense_management/screens/auth/auth_screen.dart';
import '../../model/users.dart';
import '../../screens/mainlayoutcontrol.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routesname.home:
        final userArg = settings.arguments as Users?;
        final safeUser = userArg ?? Users.testUser();
        return MaterialPageRoute(builder: (context) => MainLayout(user: safeUser));

      case Routesname.detail:
        return MaterialPageRoute(builder: (context) => const  categoryDetail());


      case Routesname.auth:
        return MaterialPageRoute(builder: (context) => const AuthScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy đường dẫn!')),
          );
        });
    }
  }
}