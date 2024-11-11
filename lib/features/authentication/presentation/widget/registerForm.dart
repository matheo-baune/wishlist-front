import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        //300 et 400 sont des valeurs arbitraires pour la largeur et la hauteur de la carte à modifier par la suite
        double cardWidth =
        (constraints.maxWidth * 0.30).clamp(300.0, constraints.maxWidth);
        double cardHeight =
        (constraints.maxHeight * 0.30).clamp(400.0, constraints.maxHeight);

        return ConstrainedBox(
          constraints:
          BoxConstraints(maxWidth: cardWidth, maxHeight: cardHeight),
          child: Card(
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
                      Future<bool> successfull = _register(
                          username: _usernameController.text,
                          email: _emailController.text,
                          password: Utils.encodePassword(_passwordController.text)
                      );
                      print(successfull);
                      if(await successfull){
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
          ),
        );
      },
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

  Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
  inspect(data);
  return true;

}