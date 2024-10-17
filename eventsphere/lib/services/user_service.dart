import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String username;

  User({required this.id, required this.username});

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
  );
}

class UserService {
  static const String _currentUserKey = 'current_user';

  Future<void> registerUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
    );
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
