import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_management/core/utils/responsive.dart';
import '../../core/data/service/authservice.dart';
import '../../core/model/users.dart';
import '../../core/utils/enum/authtype.dart';
import '../buttons/custombutton.dart';
import '../buttons/gradientbutton.dart';
import '../inputs/passwordbox.dart';
import '../inputs/textbox.dart';
import 'package:expense_management/screens/mainlayoutcontrol.dart';
import 'package:expense_management/screens/auth/email_verification_screen.dart';



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

  bool _looksLikeEmailOrPhone(String value) {
    final v = value.trim();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (emailRegex.hasMatch(v)) {
      return true;
    }
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 9 && digits.length <= 11;
  }

  bool _looksLikeEmail(String value) {
    final v = value.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
  }

  String _toUserMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('SocketException') || raw.contains('SocketConnection')) {
      if (raw.contains('10.0.2.2')) {
        return 'Khong ket noi duoc backend. 10.0.2.2 chi dung cho emulator. Neu dung may that, hay chay app voi --dart-define=API_BASE_URL=http://<LAN_IP>:3000';
      }
      return 'Khong ket noi duoc backend NodeJS. Hay kiem tra server dang chay va API_BASE_URL.';
    }
    if (raw.contains('sign_in_failed') &&
        (raw.contains('Api10') || raw.contains('ApiException: 10'))) {
      return 'Google Sign-In chưa cấu hình đúng SHA-1/Google Services. Hãy cập nhật Firebase rồi build lại app.';
    }
    if (raw.contains('[firebase_auth/invalid-credential]')) {
      return 'Google credential không hợp lệ. Hãy kiểm tra SHA-1/SHA-256, package name và google-services.json đúng Firebase project.';
    }
    return raw.replaceFirst('Exception: ', '');
  }

  Future<void> _goToMainIfUser(Users? user) async {
    if (!mounted) {
      return;
    }
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thất bại. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainLayout(user: user),
      ),
    );
  }

  Future<void> _openEmailVerificationFlow({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await AuthService().registerEmailAndSendVerification(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (!mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationScreen(
          email: email,
        ),
      ),
    );
  }

  Future<void> _openForgotPasswordFlow() async {
    final emailController = TextEditingController();

    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Quên mật khẩu'),
            content: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Nhập email đăng ký',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, emailController.text.trim()),
                child: const Text('Tiếp tục'),
              ),
            ],
          );
        },
      );

      if (result == null || result.isEmpty) {
        return;
      }
      if (!_looksLikeEmail(result)) {
        throw Exception('Quên mật khẩu chỉ hỗ trợ email');
      }

      await AuthService().sendPasswordResetEmail(result);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase đã gửi link đặt lại mật khẩu tới $result'),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      emailController.dispose();
    }
  }

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

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(0.5)),
      child: Column(
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
                  label: 'Email hoặc số điện thoại',
                  controller: _identifierController,
                  prefixIcon:
                  const Icon(Icons.alternate_email, color: Colors.grey),
                  hintText: 'name@gmail.com hoặc 0987654321',
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
                        onPressed: _openForgotPasswordFlow,
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
                    try {
                      Users? user;
                      if (isLogin) {
                        if (!_looksLikeEmailOrPhone(_identifierController.text)) {
                          throw Exception('Vui lòng nhập đúng email hoặc số điện thoại');
                        }
                        final identifier = _identifierController.text.trim();
                        if (_looksLikeEmail(identifier)) {
                          user = await AuthService().loginWithFirebaseEmailPassword(
                            email: identifier,
                            password: _passwordController.text,
                          );
                        } else {
                          user = await AuthService().login(
                            identifier,
                            _passwordController.text,
                          );
                        }
                      } else {
                        final identifier = _identifierController.text.trim();
                        if (identifier.isEmpty) {
                          throw Exception('Vui lòng nhập email hoặc số điện thoại');
                        }
                        if (!_looksLikeEmailOrPhone(identifier)) {
                          throw Exception('Email hoặc số điện thoại không hợp lệ');
                        }
                        if (_passwordController.text != _confirmPasswordController.text) {
                          throw Exception('Mật khẩu xác nhận không khớp');
                        }

                        if (_looksLikeEmail(identifier)) {
                          await _openEmailVerificationFlow(
                            email: identifier,
                            password: _passwordController.text,
                            displayName: _nameController.text.trim(),
                          );
                          user = null;
                        } else {
                          // Phone register keeps direct flow because SMS OTP service is not configured.
                          user = await AuthService().register(
                            identifier: identifier,
                            password: _passwordController.text,
                            displayName: _nameController.text.trim(),
                          );
                        }
                      }
                      if (user != null) {
                        await _goToMainIfUser(user);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_toUserMessage(e)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                )
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
                  size: Responsive.w(15),
                ),
                onPressed: () async {
                  if (_isLoading) return;
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final user = await AuthService().loginWithGoogle();
                    await _goToMainIfUser(user);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_toUserMessage(e)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
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
                onPressed: () async {
                  if (_isLoading) return;
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final user = await AuthService().loginWithFacebook();
                    await _goToMainIfUser(user);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_toUserMessage(e)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}