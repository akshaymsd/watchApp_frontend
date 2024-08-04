import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/screen/modules/admin/admin_add_smartwatch.dart';
import 'package:watchapp/screen/modules/admin/view_appleWatch.dart';
import 'package:watchapp/screen/modules/admin/view_samsungWatch.dart';
import 'package:watchapp/screen/modules/admin/view_smartWatch.dart';
import 'package:watchapp/utils/constants.dart';

import '../../../view_model/auth_viewModel.dart';
import '../../../widgets/admin_widget/adminContainer_widget.dart';
import '../../auth/login.dart'; // Import the Login screen

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _logout(); // Perform the logout
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    try {
      await authViewModel.logout(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Navigate to login
      );
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Flutter ',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(
                      text: 'Watch App',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdminContainer(
                    clr2: Color(0xFFFFD194),
                    text: "Add Watch",
                    clr1: Color(0xFF70E1F5),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAddSmartWatch(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdminContainer(
                    clr2: Color(0xFFFFFFFF),
                    text: "View Smart Watch",
                    clr1: Color(0xFFFFD194),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSmartWatch(),
                          ));
                    },
                  ),
                  AdminContainer(
                    clr2: Color(0xFFFFD194),
                    text: "View Apple Watch",
                    clr1: Color(0xFFFFFFFF),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewAppleWatch(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdminContainer(
                    clr2: Color(0xFF005AA7),
                    text: "View Samsung Watch",
                    clr1: Color(0xFFFFFDE4),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSamsungWatch(),
                          ));
                    },
                  ),
                  AdminContainer(
                    clr2: Color(0xFFFFFDE4),
                    text: "View Other Watch",
                    clr1: Color(0xFF005AA7),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdminContainer(
                    clr2: Color(0xFF3f2b96),
                    text: "Add Other Watch",
                    clr1: Color(0xFFFFFFFF),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {},
                  ),
                  AdminContainer(
                    clr2: Color(0xFFFFFFFF),
                    text: "View Other Watch",
                    clr1: Color(0xFF3f2b96),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdminContainer(
                    clr2: Color(0xFFACB6E5),
                    text: "View Complaints",
                    clr1: Color(0xFFFFD194),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {},
                  ),
                  AdminContainer(
                    clr2: Color(0xFFFFD194),
                    text: "Send Reply",
                    clr1: Color(0xFFACB6E5),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    ontap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: AdminContainer(
                    ontap: () {
                      _showLogoutDialog(); // Show logout dialog
                    },
                    clr2: Color(0xFFc31432),
                    text: "Logout",
                    clr1: Color(0xFF240b36),
                    clr3: Colors.white,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
