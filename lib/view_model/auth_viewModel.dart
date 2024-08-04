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

      // Handle admin login
      if (username == 'admin' && password == 'admin123') {
        await _saveLoginStatus(true);
        await _saveUsername('admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
        return true;
      }

      // Handle regular user login
      _currentUser =
          await _authService.login(username: username, password: password);
      if (_currentUser != null && _currentUser!.sId != null) {
        _userId = _currentUser!.sId;
        await _saveLoginStatus(true);
        await _saveUserId(_userId!);
        await _saveUsername(username);
        notifyListeners();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        return true;
      } else {
        print('Login successful, but no user data received.');
        return false;
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
    await _removeUsername();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> _removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<void> _removeUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
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
    return userId;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    return username;
  }
}
