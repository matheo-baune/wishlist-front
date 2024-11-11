import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SessionManager {
  static Future<void> saveSessionCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
  }

  static Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie');
  }

  static Future<void> clearSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_cookie');
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
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final cookie = response.headers['set-cookie'];
    if (cookie != null) {
      await SessionManager.saveSessionCookie(cookie);
    }
  } else {
    throw Exception('Failed to login');
  }
}

Future<void> fetchData() async {
  final cookie = await SessionManager.getSessionCookie();
  final response = await http.get(
    Uri.parse('${dotenv.env['API_URL']}/data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': cookie ?? '',
    },
  );

  if (response.statusCode == 200) {
    // Handle the response
  } else {
    throw Exception('Failed to fetch data');
  }
}