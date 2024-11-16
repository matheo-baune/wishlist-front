import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wishlist_front/SessionManager.dart';
import 'package:wishlist_front/core/models/UserModel.dart';
import 'dart:convert';

import '../../../../core/Utils.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle register logic here
                Future<bool> success = _register(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: Utils().encodePassword(_passwordController.text)
                );

                if(await success){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/login');
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error while registering'),
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}


Future<bool> _register({username,password,email} ) async {
  final response = await http.post(Uri.parse('${dotenv.env['API_URL']}/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "username" : username,
      "password" : password,
      "email": email
    }),
  );
  if(response.statusCode != 201){
    log('Error: ${response.statusCode}');
    return false;
  }
  final cookie = response.headers['set-cookie'];
  await SessionManager().saveStringForSession('session_cookie', cookie!);

  UserModel user = UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  await SessionManager().saveStringForSession('user-data', jsonEncode(user));

  return true;
}