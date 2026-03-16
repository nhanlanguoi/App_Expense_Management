import 'package:flutter/material.dart';

import '../../components/buttons/gradientbutton.dart';
import '../../components/gradientbackground.dart';
import '../../core/data/service/authservice.dart';
import '../../core/model/users.dart';
import '../../core/utils/responsive.dart';
import '../mainlayoutcontrol.dart';

enum EmailOtpPurpose { register, reset }

class EmailOtpScreen extends StatefulWidget {
  final String email;
  final EmailOtpPurpose purpose;
  final String? registerPassword;
  final String? registerDisplayName;

  const EmailOtpScreen({
    super.key,
    required this.email,
    required this.purpose,
    this.registerPassword,
    this.registerDisplayName,
  });

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  String _otp = '';
  bool _isLoading = false;
  bool _isResending = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool get _isRegisterFlow => widget.purpose == EmailOtpPurpose.register;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_otp.length != 6) {
      _showMessage('Vui lòng nhập đủ 6 số OTP');
      return;
    }

    if (!_isRegisterFlow) {
      final newPassword = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      if (newPassword.length < 6) {
        _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự');
        return;
      }
      if (newPassword != confirmPassword) {
        _showMessage('Xác nhận mật khẩu không khớp');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isRegisterFlow) {
        final Users? user = await AuthService().verifyRegisterOtp(
          email: widget.email,
          code: _otp,
          password: widget.registerPassword ?? '',
          displayName: widget.registerDisplayName,
        );

        if (!mounted) {
          return;
        }

        if (user == null) {
          _showMessage('Xác thực thất bại, vui lòng thử lại');
          return;
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainLayout(user: user)),
          (route) => false,
        );
      } else {
        await AuthService().verifyResetOtp(
          email: widget.email,
          code: _otp,
          newPassword: _newPasswordController.text.trim(),
        );

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi mật khẩu thành công, vui lòng đăng nhập lại'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      final response = await AuthService().requestEmailOtp(
        email: widget.email,
        purpose: _isRegisterFlow ? 'register' : 'reset',
      );
      final debugCode = (response['debugCode'] ?? '').toString();
      if (debugCode.isNotEmpty) {
        _showMessage('Dev OTP: $debugCode');
      } else {
        _showMessage('Đã gửi lại mã OTP');
      }
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _onDigitPressed(String digit) {
    if (_otp.length >= 6) {
      return;
    }
    setState(() {
      _otp += digit;
    });
  }

  void _onDeletePressed() {
    if (_otp.isEmpty) {
      return;
    }
    setState(() {
      _otp = _otp.substring(0, _otp.length - 1);
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final char = index < _otp.length ? _otp[index] : '';
        return Container(
          width: Responsive.w(46),
          height: Responsive.h(56),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Responsive.w(18)),
            border: Border.all(color: const Color(0xFFE6E2F7)),
          ),
          child: Text(
            char,
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(22),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF141B34),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumpad() {
    Widget key(String text) {
      return GestureDetector(
        onTap: () => _onDigitPressed(text),
        child: Container(
          alignment: Alignment.center,
          height: Responsive.h(56),
          child: Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(36),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F1732),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: [
        key('1'),
        key('2'),
        key('3'),
        key('4'),
        key('5'),
        key('6'),
        key('7'),
        key('8'),
        key('9'),
        const SizedBox.shrink(),
        key('0'),
        GestureDetector(
          onTap: _onDeletePressed,
          child: const Icon(Icons.backspace_outlined, color: Color(0xFF90A0B7)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      body: gradientbackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(24),
            vertical: Responsive.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF141B34)),
                ),
              ),
              SizedBox(height: Responsive.h(12)),
              Container(
                width: Responsive.w(132),
                height: Responsive.w(132),
                margin: EdgeInsets.only(bottom: Responsive.h(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Responsive.w(34)),
                ),
                child: const Icon(Icons.mark_email_read_rounded, color: Color(0xFF7B3FE4), size: 54),
              ),
              Text(
                _isRegisterFlow ? 'Xác thực tài khoản' : 'Xác nhận đổi mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(42),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BeVietnamPro',
                  color: const Color(0xFF111835),
                ),
              ),
              SizedBox(height: Responsive.h(10)),
              Text(
                'Chúng tôi đã gửi mã xác thực gồm 6 chữ số đến ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(19),
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'BeVietnamPro',
                  color: const Color(0xFF49566E),
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              _buildOtpBoxes(),
              SizedBox(height: Responsive.h(20)),
              if (!_isRegisterFlow) ...[
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu mới',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(10)),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Xác nhận mật khẩu mới',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(14)),
              ],
              gradientbutton(
                label: 'Xác nhận',
                isLoading: _isLoading,
                gradient: const LinearGradient(colors: [Color(0xFF7B3FE4), Color(0xFF5A2DBD)]),
                height: Responsive.h(56),
                borderRadius: Responsive.w(34),
                width: double.infinity,
                onPressed: _submit,
              ),
              SizedBox(height: Responsive.h(14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn không nhận được mã?',
                    style: TextStyle(
                      color: const Color(0xFF6B7790),
                      fontSize: Responsive.sp(16),
                      fontFamily: 'BeVietnamPro',
                    ),
                  ),
                  TextButton(
                    onPressed: _isResending ? null : _resendOtp,
                    child: Text(
                      _isResending ? 'Đang gửi...' : 'Gửi lại mã',
                      style: TextStyle(
                        color: const Color(0xFF6F3FE6),
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(8)),
              _buildNumpad(),
            ],
          ),
        ),
      ),
    );
  }
}
