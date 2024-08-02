import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_viewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/textfiled_widget.dart';
import '../modules/user/homescreen.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: GoogleFonts.poppins(fontSize: 30),
              ),
              SizedBox(height: 40),
              TextfieldWidget(
                txt: 'Enter username',
                icon: Icons.supervised_user_circle,
                ctrl: username,
              ),
              TextfieldWidget(
                txt: 'Enter password',
                icon: Icons.password,
                ctrl: pass,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return buttonWidget(
                    ontap: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        bool isSuccess = await authViewModel.login(
                          username: username.text,
                          password: pass.text,
                          context: context,
                        );
                        if (isSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        }
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
