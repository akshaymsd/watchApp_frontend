import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/view_model/auth_viewModel.dart';

import 'editProfile.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String name = "Akshay";
  String email = "Akshay@123";
  String phone = "9745782377";
  String address = "House Name,\nPost name,Vatakara,\nKozhikode,673105";

  Future<void> _navigateToEditProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(
          name: name,
          email: email,
          phone: phone,
          address: address,
        ),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        name = updatedProfile['name'];
        email = updatedProfile['email'];
        phone = updatedProfile['phone'];
        address = updatedProfile['address'];
      });
    }
  }

  Future<void> _logout() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logout(context);
  }

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

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(LineAwesomeIcons.angle_left_solid),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                  child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/img/dp.png"),
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 4,
              ),
              Text(
                "Name:  $name",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text("Email:  $email",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 18)),
              Text("Phone:  $phone",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Address:  ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 18)),
                  Text(address,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 12)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    side: BorderSide.none,
                    elevation: 5,
                    shape: StadiumBorder()),
                onPressed: _navigateToEditProfile,
                child: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: BorderSide.none,
                  elevation: 5,
                  shape: StadiumBorder(),
                ),
                onPressed: _showLogoutDialog,
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
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
