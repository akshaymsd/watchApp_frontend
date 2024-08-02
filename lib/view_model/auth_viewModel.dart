import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../screen/auth/login.dart';
import '../screen/modules/admin/admin_screen.dart';
import '../screen/modules/user/homescreen.dart';
import '../services/auth_services.dart';

class AuthViewModel extends ChangeNotifier {
  String? _userId;
  String? get userId => _userId;
  final AuthServices _authService = AuthServices();
  bool loading = false;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<bool> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      notifyListeners();
      if (username == 'admin' && password == 'admin123') {
        // Navigate to admin page if admin credentials are used
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
        return true;
      }
      _currentUser =
          await _authService.login(username: username, password: password);
      if (_currentUser != null && _currentUser!.sId != null) {
        _userId = _currentUser!.sId;
        print('Login successful, User ID: $_userId');
        await _saveLoginStatus(true);
        await _saveUserId(_userId!);
        notifyListeners();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        return true;
      } else {
        // Handle case where user data is missing
        print('Login successful, but no user data received.');
        await _saveLoginStatus(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        return true;
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required UserModel user,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      notifyListeners();
      await _authService.register(user: user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    _currentUser = null;
    _userId = null;
    await _saveLoginStatus(false);
    await _removeUserId();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> _saveUserId(String userId) async {
    print('Saving User ID: $userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> _removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('Is Logged In: $isLoggedIn');
    if (isLoggedIn) {
      _userId = await getUserId();
      print('Retrieved User ID on checkLoginStatus: $_userId');
    }
    return isLoggedIn;
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('Retrieved User ID: $userId');
    return userId;
  }
}
