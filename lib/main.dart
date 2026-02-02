
import 'package:flutter/material.dart';

import 'package:expense_management/screens/auth/login_screen.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const LoginScreen(),
  ));
}