import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/model/user_model.dart';

// Ensure this import matches your file structure
import '../../view_model/auth_viewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/textfiled_widget.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 40),
                ),
                SizedBox(height: 20),
                TextfieldWidget(
                  txt: "Enter username",
                  ctrl: username,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  txt: 'Enter Name',
                  ctrl: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  txt: 'Enter email',
                  ctrl: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  txt: 'Enter password',
                  ctrl: pass,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  txt: "Enter Phone number",
                  ctrl: phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account!",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<AuthViewModel>(
                  builder: (context, value, child) => value.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : buttonWidget(
                          ontap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              print(name.text);
                              print(pass.text);
                              print(email.text);
                              print(username.text);
                              print(phone.text);
                              value.register(
                                  user: UserModel(
                                    name: name.text,
                                    password: pass.text,
                                    email: email.text,
                                    phone: phone.text,
                                    username: username.text,
                                  ),
                                  context: context);
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
