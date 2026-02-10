import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
   final bool isLogin;
  const AuthForm({
    super.key,
    required this.isLogin
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
