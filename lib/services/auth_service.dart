import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class AuthService {
  static const _sessionKey = 'authenticated_user';

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final response = await post(
      Uri.parse('$host/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Unable to sign in.');
    }

    final user = User.fromJson(data);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_sessionKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<User?> restoreSession() async {
    final preferences = await SharedPreferences.getInstance();
    final savedUser = preferences.getString(_sessionKey);
    if (savedUser == null || savedUser.isEmpty) return null;

    try {
      return User.fromJson(jsonDecode(savedUser));
    } on FormatException {
      await preferences.remove(_sessionKey);
      return null;
    }
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_sessionKey);
  }
}
