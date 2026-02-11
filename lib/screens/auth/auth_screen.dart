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

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  AuthType _mode = AuthType.login;
  void toggleMode() {
    _mode = _mode == AuthType.login ? AuthType.register : AuthType.login;
  }




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
                AnimatedAlign(
                    alignment: _mode == AuthType.register
                        ? Alignment.topCenter
                        : Alignment.center,
                    duration: const Duration(milliseconds: 600),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      padding: EdgeInsets.only(top: _mode == AuthType.login? 20 : 0),
                      child: logo(
                          icon: Icons.account_balance_wallet,
                          size: 100,
                          iconsize: 40,
                          bordersize: 2
                      ),
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.only(top: 30),
                //   child: logo(
                //       icon: Icons.account_balance_wallet,
                //       size: 100,
                //       iconsize: 40,
                //       bordersize: 2),
                // ),
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
                    child: AuthForm(type: AuthType.login,)
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top:1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _mode == AuthType.login
                            ? "Bạn chưa có tài khoản?"
                            : "Bạn đã có tài khoản?",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      custombutton(
                          label: _mode==AuthType.login? "Đăng ký ngay" : "Đăng nhập",
                          onPressed: () {
                            setState(() {
                              _mode = _mode == AuthType.login
                                  ? AuthType.register
                                  : AuthType.login;
                            });
                          },
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
