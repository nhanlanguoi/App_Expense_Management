import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_management/core/utils/responsive.dart';
import 'package:expense_management/screens/home/Home.dart';
import '../../core/data/service/authservice.dart';
import '../../core/model/users.dart';
import '../../core/utils/enum/authtype.dart';
import '../buttons/custombutton.dart';
import '../buttons/gradientbutton.dart';
import '../inputs/passwordbox.dart';
import '../inputs/textbox.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/screens/mainlayoutcontrol.dart';



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
    Responsive.init(context);

    final _heightMode =
    widget.type == AuthType.login ? Responsive.h(15) : Responsive.h(8);

    final _padingMode =
    widget.type == AuthType.login ? Responsive.h(14) : Responsive.h(10);

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              if (isRegister) ...[
                textbox(
                  controller: _nameController,
                  label: 'Họ và tên',
                  prefixIcon:
                  const Icon(Icons.person, color: Colors.grey),
                  hintText: "Nguyễn Văn A",
                ),
                SizedBox(height: _heightMode),
              ],
              textbox(
                keyboardType: TextInputType.emailAddress,
                label: 'Email hoặc Số điện thoại',
                controller: _identifierController,
                prefixIcon:
                const Icon(Icons.mail, color: Colors.grey),
                hintText: 'moi@example.com',
              ),
              SizedBox(height: _heightMode),

              /// Mật khẩu + Quên mật khẩu
              Row(
                children: [
                  Text(
                    "Mật khẩu",
                    style: TextStyle(
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.w600,
                      fontFamily: "BeVietnamPro",
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  if (isLogin)
                    custombutton(
                      label: 'Quên mật khẩu?',
                      isOutline: true,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.purple,
                      labelStyle: TextStyle(
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.w600,
                        fontFamily: "BeVietnamPro",
                        color: const Color(0xFF7B3FE4),
                      ),
                      height: Responsive.h(34),
                      borderRadius: Responsive.w(18),
                      width: Responsive.w(140),
                    ),
                ],

              ),

              passwordbox(
                controller: _passwordController,
                hintText: "●●●●●●●●●",
                prefixIcon:
                const Icon(Icons.lock, color: Colors.grey),
              ),

              if (isRegister) ...[
                SizedBox(height: _heightMode),
                passwordbox(
                  label: "Nhập lại mật khẩu",
                  labelStyle: TextStyle(
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.w600,
                    fontFamily: "BeVietnamPro",
                    color: Colors.black,
                  ),
                  prefixIcon:
                  const Icon(Icons.verified_user, color: Colors.grey),
                  controller: _confirmPasswordController,
                  hintText: "●●●●●●●●●",),

                SizedBox(height: _heightMode),
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
                    Users? user = await AuthService().login(
                        _identifierController.text,
                        _passwordController.text
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                      if (isLogin) {

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLayout(user: user,),
                            ),
                          );

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sai tài khoản hoặc mật khẩu! (Thử: admin / 123)"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainLayout(
                                user: Users.testUser()
                            ),
                          ),
                        );
                      }
                    }
                  },
                )
              ],

              if (isRegister) ...[
                SizedBox(height: _heightMode),
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
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: Responsive.sp(14),
                          ),
                          children: const [
                            TextSpan(text: "Tôi đồng ý với "),
                            TextSpan(
                              text: "Điều khoản",
                              style: TextStyle(
                                  color: Color(0xFF7B3FE4)),
                            ),
                            TextSpan(text: " và "),
                            TextSpan(
                              text: "Chính sách bảo mật",
                              style: TextStyle(
                                  color: Color(0xFF7B3FE4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: _heightMode),

              gradientbutton(
                label: isLogin ? 'Đăng nhập' : 'Đăng ký',
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B3FE4), Color(0xFF5A2DBD)],
                ),
                labelStyle: TextStyle(
                  fontSize: Responsive.sp(18),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BeVietnamPro',
                  color: Colors.white,
                ),
                isLoading: _isLoading,
                height: Responsive.h(55),
                borderRadius: Responsive.w(35),
                width: double.infinity,
                onPressed: () async {
                  if (_isLoading) return;
                  setState(() => _isLoading = true);

                  await Future.delayed(
                      const Duration(seconds: 2));

                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                },
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: _padingMode),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: Responsive.w(1),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: Responsive.w(8)),
                child: Text(
                  "Hoặc tiếp tục với",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'BeVietnamPro',
                    fontSize: Responsive.sp(14),
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: Responsive.w(1),
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            custombutton(
              label: "Google",
              height: Responsive.h(50),
              borderRadius: Responsive.w(30),
              width: Responsive.w(120),
              isOutline: true,
              backgroundColor: const Color(0xFFDB4437),
              textColor: const Color(0xFF1F1F1F),
              icon: Icon(
                FontAwesomeIcons.google,
                color: const Color(0xFFDB4437),
                size: Responsive.w(20),
              ),
            ),
            custombutton(
              label: "Facebook",
              labelStyle: TextStyle(
                fontSize: Responsive.sp(15),
                fontWeight: FontWeight.bold,
                fontFamily: 'BeVietnamPro',
                color: const Color(0xFF1877F2),
              ),
              height: Responsive.h(50),
              borderRadius: Responsive.w(30),
              width: Responsive.w(120),
              isOutline: true,
              backgroundColor: const Color(0xFF1877F2),
              textColor: Colors.black,
              icon: Icon(
                FontAwesomeIcons.facebook,
                color: const Color(0xFF1877F2),
                size: Responsive.w(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}