
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home/Home.dart';
import 'package:expense_management/configs/routes/routes.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/data/hiveconfig.dart';
import 'package:expense_management/data/dataseeder.dart';


void main() async {
  await HiveConfig.init();
  await DataSeeder.seedusers();
  await DataSeeder.seedwallet();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routesname.auth,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}