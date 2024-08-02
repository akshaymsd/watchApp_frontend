import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_viewModel.dart';
import '../modules/user/homescreen.dart';
import 'login.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future:
          Provider.of<AuthViewModel>(context, listen: false).checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
