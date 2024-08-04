import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/widgets/user_widget/appleProduct_widget.dart';
import 'package:watchapp/widgets/user_widget/samsungProduct_widget.dart';

import '../../../view_model/auth_viewModel.dart';
import '../../../widgets/user_widget/SmartwatchWidget.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late PageController _pageController;
  String? userId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchUserId(); // Fetch userId on initialization
  }

  Future<void> _fetchUserId() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final fetchedUserId =
        await authViewModel.getUserId(); // Ensure getUserId() returns userId

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        userId = fetchedUserId;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        children: <Widget>[
          buildHomePage(),
          CartWidget(userId: userId ?? ''),
          Center(child: Text("Favourites")),
          ViewProfile(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart),
              label: "My Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "WishList",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "My Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHomePage() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Find your suitable watch now!!",
              style: GoogleFonts.poppins(
                  fontSize: 40, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.search_sharp),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              ],
            ),
          ),
          SizedBox(height: 15),
          TabBar(
            isScrollable: false,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Smart watch'),
              Tab(text: 'Apple'),
              Tab(text: 'Samsung'),
              Tab(text: 'Other'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Smartwatch()),
                Center(child: AppleProducts()),
                Center(child: SamsungProducts()),
                Center(child: Text('Other content here')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
