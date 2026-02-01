import 'package:flutter/material.dart';
import 'package:expense_management/components/inputs/textbox.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập hệ thống")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                textbox(
                  label: 'Email hoặc Số điện thoại',
                  controller: _usernameController,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.grey,
                  ),
                  hintText: 'moi@example.com',),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    // prefixIcon: Icon(Icons.visibility_off),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off) ,
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });

                      },

                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  // child: ,
                )
              ],
            )
        ),
      ),
    );
  }
}
