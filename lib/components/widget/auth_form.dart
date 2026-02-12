import 'package:expense_management/enum/authtype.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../buttons/custombutton.dart';
import '../buttons/gradientbutton.dart';
import '../inputs/passwordbox.dart';
import '../inputs/textbox.dart';

class AuthForm extends StatefulWidget {
   final AuthType type;
  const AuthForm({
    super.key,
    required this.type,

  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _agreeTerms = false;
  bool get isLogin => widget.type == AuthType.login;
  bool get isRegister => widget.type == AuthType.register;
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                if(isRegister)...[
                  textbox(
                    controller: _nameController,
                    label: 'Họ và tên',
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    hintText: "Nguyễn Văn A",
                  ),
                  const SizedBox(height: 8),
                ],
                textbox(
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email hoặc Số điện thoại',
                  controller: _identifierController,
                  prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                  hintText: 'moi@example.com',
                ),

                const SizedBox(height: 8),
                Row(
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
                    if(isLogin)
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
                          width: 140
                      ),
                  ],
                ),
                passwordbox(
                  controller: _passwordController,
                  hintText: "●●●●●●●●●",
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                if(isRegister)...[
                  const SizedBox(height: 8),
                  passwordbox(
                    label: "Nhập lại mật khẩu",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "BeVietnamPro",
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(Icons.verified_user, color: Colors.grey),
                    controller: _confirmPasswordController,
                    hintText: "●●●●●●●●●",
                  ),
                ],
                if (isRegister) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeTerms = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(text: "Tôi đồng ý với "),
                              TextSpan(
                                text: "Điều khoản",
                                style: TextStyle(color: Color(0xFF7B3FE4)),
                              ),
                              TextSpan(text: " và "),
                              TextSpan(
                                text: "Chính sách bảo mật",
                                style: TextStyle(color: Color(0xFF7B3FE4)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                gradientbutton(
                  label: isLogin ? 'Đăng nhập' : 'Đăng ký',
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
              ],
            )
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10),
            child:Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300], thickness: 1,)),
                Text(
                  "Hoặc tiếp tục với",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'BeVietnamPro',
                    fontSize: 14,
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
    );
  }
}
