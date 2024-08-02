import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../utils/constants.dart';

class AuthServices {
  Future<void> register({required UserModel user}) async {
    final Uri url = Uri.parse('$baseurl/api/auth/');

    try {
      final response = await http.post(url,
          body: jsonEncode(user.toJson()),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('Registration successful');
      } else {
        throw Exception(
            'Failed to register. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('An error occurred during registration');
    }
  }

  Future<UserModel?> login(
      {required String username, required String password}) async {
    try {
      final Uri url = Uri.parse('$baseurl/api/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Login response: ${response.body}'); // Debugging print statement

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          // Check if 'data' exists
          if (jsonResponse.containsKey('data') &&
              jsonResponse['data'] != null) {
            var userData = jsonResponse['data'];
            if (userData is Map<String, dynamic>) {
              var user = UserModel.fromJson(userData);
              print('Parsed User: ${user.sId}'); // Debugging print statement
              return user;
            } else {
              print('User data is not in expected format.');
              return null;
            }
          } else {
            // Handle case where user data is missing
            print('Login successful, but no user data received.');
            return null; // Return null if no user data
          }
        } else {
          throw Exception('Login failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AuthServices login: $e'); // Debugging print statement
      rethrow;
    }
  }

  Future<void> _saveUserId(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setString('userId', userId);
    } else {
      await prefs.remove('userId');
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
