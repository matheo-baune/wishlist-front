import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wishlist_front/core/Utils.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

class SessionManager {
  // Private constructor
  SessionManager._privateConstructor();

  // Singleton instance
  static final SessionManager _instance = SessionManager._privateConstructor();

  // Factory constructor to return the singleton instance
  factory SessionManager() {
    return _instance;
  }


  Future<UserModel> getUserSession() async {
    String? data = await SessionManager().getStringFromSession('user-data');
    if (data != null) {
      Map<String, dynamic> userMap = jsonDecode(data);
      return UserModel.fromJson(userMap);
    } else {
      throw Exception('No user data found in session');
    }
  }

  Future<String> getCookieSession() async {
    String? cookie = await SessionManager().getStringFromSession('session_cookie');
    if(cookie != null) {
      return cookie;
    } else {
      throw Exception('No cookie found in session');
    }
  }

  // Encapsulate SharedPreferences access
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveStringForSession(String index, String cookie) async {
    final prefs = await _getPrefs();
    await prefs.setString(index, cookie);
  }

  Future<String?> getStringFromSession(String index) async {
    final prefs = await _getPrefs();
    try {
      return prefs.getString(index);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await _getPrefs();
    await prefs.remove('session_cookie');
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      await prefs.remove(key);
    }
  }

  Future<bool> isAuthentified() async {
    String? cookie = await getStringFromSession('session_cookie');
    inspect(cookie);
    return cookie != null;
  }
}

Future<void> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': Utils().encodePassword(password),
    }),
  );

  if (response.statusCode == 200) {
    final cookie = response.headers['set-cookie'];
    if (cookie != null) {
      await SessionManager().saveStringForSession('session_cookie',cookie);
    }
  } else {
    throw Exception('Failed to login');
  }
}
