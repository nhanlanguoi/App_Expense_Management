import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/components/inputs/passwordbox.dart';
import 'package:expense_management/components/logo.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/buttons/gradientbutton.dart';
import 'package:expense_management/components/inputs/textbox.dart';
import 'package:expense_management/components/gradientbackground.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            textbox(
                              keyboardType: TextInputType.emailAddress,
                              label: 'Email hoặc Số điện thoại',
                              controller: _usernameController,
                              prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                              hintText: 'moi@example.com',
                            ),

                            const SizedBox(height: 20),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Text(
                                  "Mật khẩu",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "BeVietnamPro",
                                    color: Colors.black,
                                  ),
                                ),
                                  const Spacer(),
                                  custombutton(
                                      label: 'Quên mật khẩu?',
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
                              ),
                            ),
                            passwordbox(
                              controller: _passwordController,
                              hintText: "●●●●●●●●●",
                              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            ),

                            const SizedBox(height: 20),

                            gradientbutton(
                              label: "Đăng nhập",
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF7B3FE4), Color(0xFF5A2DBD)]
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'BeVietnamPro',
                                color: Colors.white,
                              ),
                              isLoading: _isLoading,
                              height: 55,
                              borderRadius: 35,
                              width: double.infinity,
                              onPressed: () async {
                                if (_isLoading) return;
                                setState(() {
                                  _isLoading = true;
                                });

                                await Future.delayed(const Duration(seconds: 2));
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            ),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                              child:Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1,)),
                                  //text
                                   Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "Hoặc tiếp tục với",
                                        style: TextStyle(
                                        color: Colors.grey.shade600,
                                          fontFamily: 'BeVietnamPro',
                                          fontSize: 14,
                                        ),
                                      ),
                                   ),
                                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1,)),
                                ],
                              )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  custombutton(
                                      label: "Google",
                                      height: 50,
                                      borderRadius: 30,
                                      width:120,
                                    isOutline: true,
                                    backgroundColor: Color(0xFFDB4437),
                                    textColor: Color(0xFF1F1F1F),
                                    icon: const Icon(
                                      FontAwesomeIcons.google,
                                      color: Color(0xFFDB4437),
                                      size: 20,
                                    ),
                                  ),
                                custombutton(
                                  label: "Facebook",
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'BeVietnamPro',
                                    color: const Color(0xFF1877F2)
                                  ),
                                  height: 50,
                                  borderRadius: 30,
                                  width: 120,
                                  isOutline: true,
                                  backgroundColor: const Color(0xFF1877F2),
                                  textColor: Colors.black,
                                  icon: const Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Color(0xFF1877F2),
                                    size: 20,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        )
                    ),
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
