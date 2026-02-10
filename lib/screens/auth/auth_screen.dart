import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/components/inputs/passwordbox.dart';
import 'package:expense_management/components/logo.dart';
import 'package:expense_management/components/widget/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/buttons/gradientbutton.dart';
import 'package:expense_management/components/inputs/textbox.dart';
import 'package:expense_management/components/gradientbackground.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../enum/authtype.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: gradientbackground(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: logo(
                      icon: Icons.account_balance_wallet,
                      size: 100,
                      iconsize: 40,
                      bordersize: 2),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Xin chào!", style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                      height: 1.1,
                      color: Colors.black,
                    ),)
                ),
                const Padding(padding: EdgeInsets.only(top: 9),
                  child: Text("Đăng nhập để quản lý chi tiêu của bạn", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'BeVietnamPro',
                    color: Color(0xFF6C7381),
                  )),
                ),

                // --- PHẦN FORM ---
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 5),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: AuthForm(type: AuthType.register,)
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top:1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Chưa có tài khoản?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      custombutton(
                          label: 'Đăng ký ngay',
                          isOutline: true,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.purple,
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "BeVietnamPro",
                              color: Color(0xFF7B3FE4)
                          ),
                          height: 34,
                          borderRadius: 18,
                          width: 140),


                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
