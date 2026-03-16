import 'package:flutter/material.dart';

import '../../components/buttons/gradientbutton.dart';
import '../../components/gradientbackground.dart';
import '../../core/data/service/authservice.dart';
import '../../core/model/users.dart';
import '../../core/utils/responsive.dart';
import '../mainlayoutcontrol.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;

  Future<void> _checkVerifiedAndContinue() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final Users? user = await AuthService().loginVerifiedFirebaseEmailToBackend();
      if (!mounted) {
        return;
      }

      if (user == null) {
        _showError('Không thể tạo phiên đăng nhập backend');
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainLayout(user: user)),
        (route) => false,
      );
    } catch (error) {
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _resendVerificationMail() async {
    setState(() {
      _isResending = true;
    });

    try {
      await AuthService().resendEmailVerification();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi lại email xác thực'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
              SizedBox(height: Responsive.h(20)),
              Container(
                width: Responsive.w(132),
                height: Responsive.w(132),
                margin: EdgeInsets.only(bottom: Responsive.h(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Responsive.w(34)),
                ),
                child: const Icon(Icons.mark_email_unread_rounded, color: Color(0xFF7B3FE4), size: 54),
              ),
              Text(
                'Xác thực email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(40),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BeVietnamPro',
                  color: const Color(0xFF111835),
                ),
              ),
              SizedBox(height: Responsive.h(12)),
              Text(
                'Firebase đã gửi link xác thực tới ${widget.email}. Hãy mở email và bấm xác thực, sau đó quay lại đây.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(18),
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'BeVietnamPro',
                  color: const Color(0xFF49566E),
                ),
              ),
              SizedBox(height: Responsive.h(26)),
              gradientbutton(
                label: 'Tôi đã xác thực',
                isLoading: _isChecking,
                gradient: const LinearGradient(colors: [Color(0xFF7B3FE4), Color(0xFF5A2DBD)]),
                height: Responsive.h(56),
                borderRadius: Responsive.w(34),
                width: double.infinity,
                onPressed: _checkVerifiedAndContinue,
              ),
              SizedBox(height: Responsive.h(12)),
              TextButton(
                onPressed: _isResending ? null : _resendVerificationMail,
                child: Text(
                  _isResending ? 'Đang gửi...' : 'Gửi lại email xác thực',
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
        ),
      ),
    );
  }
}
