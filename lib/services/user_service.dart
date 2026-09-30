import 'dart:convert';

import 'package:http/http.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  Future<User> getUser(int id) async {
    final response = await get(Uri.parse('$host/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
    return User.fromJson(jsonDecode(response.body));
  }
}
