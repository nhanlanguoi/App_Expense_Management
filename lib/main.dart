
import 'package:flutter/material.dart';

import 'package:expense_management/screens/auth/auth_screen.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AuthScreen(),
  ));
}