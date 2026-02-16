import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/components/inputs/passwordbox.dart';
import 'package:expense_management/components/logo.dart';
import 'package:expense_management/components/widget/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/buttons/gradientbutton.dart';
import 'package:expense_management/components/inputs/textbox.dart';
import 'package:expense_management/components/gradientbackground.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import '../../enum/authtype.dart';
import 'package:expense_management/screens/home/Home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  AuthType _mode = AuthType.login;
  void toggleMode() {
    setState(() {
      _mode = _mode == AuthType.login ? AuthType.register : AuthType.login;
    });
  }

  // chỗ này là header + logo tím gradient + chuyển động

  Widget _buildMorphingHeader() {
    final isRegister = _mode == AuthType.register;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,

      height: isRegister ? 260 : 100,
      width: isRegister ? MediaQuery.of(context).size.width : 100,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B3FE4),
            Color(0xFF5A2DBD),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRegister ? 0 : 30),
          topRight: Radius.circular(isRegister ? 0 : 30),
          bottomLeft: Radius.circular(isRegister ? 35 : 30),
          bottomRight: Radius.circular(isRegister ? 35 : 30),
        ),
      ),

      child: AnimatedAlign(
        alignment: isRegister
            ? const Alignment(0, -0.75)
            : Alignment.center,
        duration: const Duration(milliseconds: 600),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),

          width: isRegister ? 70 : 100,
          height: isRegister ? 70 : 100,

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
          ),

          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  // chỗ này là form đăng nhập, đăng ký
  Widget _buildForm() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                  position:Tween(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child
              ),
            );
          },

          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: _mode == AuthType.login
                  ? const EdgeInsets.all(35)
                  : const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
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
              child: AuthForm(type: _mode ,)
          )
      ),
    );
  }

  Widget _buildTitle(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Xin chào!", style: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          fontFamily: 'BeVietnamPro',
          height: 1.1,
          color:  _mode ==AuthType.login ? Colors.black : Colors.white,
        ),),
        Padding(padding: const EdgeInsets.only(top: 5),
          child: Text( _mode == AuthType.login
              ? "Đăng nhập để quản lý chi tiểu của bạn"
              : "Tạo tài khoản để quản lý chi tiêu hiệu quả",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'BeVietnamPro',
                color:  _mode == AuthType.login ?const Color(0xFF6C7381): Colors.white,
              )),
        ),
      ],
    );
  }

  Widget _buildFooter(){
    return                   Padding(
        padding: const EdgeInsets.only(top:1, bottom: 10),
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
                  toggleMode();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
    child: Scaffold(
      body: gradientbackground(
        child: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child:Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // --- PHẦN HEADER + LOGO ---
                    Positioned(
                      top: _mode == AuthType.login ? 20 : 0,
                      left: 0,
                      right: 0,

                      child: Column(
                          children: [_buildMorphingHeader()]
                      ),
                    ),
                    Padding(
                        padding:  EdgeInsets.only(top: _mode == AuthType.login ? 160 : 100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // --- PHẦN FORM ---
                          _buildTitle(),
                          _buildForm(),
                          // phần footer đăng ký tài khoản
                          _buildFooter(),
                        ],
                      ),
                    )
                  ],
                )
)
        ),
      ),
    ));
  }
}
