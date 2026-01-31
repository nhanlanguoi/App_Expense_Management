import 'package:flutter/material.dart';

import 'configs/app_routes.dart';
import 'configs/theme.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const ExpenseManagementApp());
}

class ExpenseManagementApp extends StatelessWidget {
  const ExpenseManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
