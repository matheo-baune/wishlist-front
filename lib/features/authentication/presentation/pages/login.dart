import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  final Widget page = false ? const RegisterForm() : const LoginForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          //300 et 400 sont des valeurs arbitraires pour la largeur et la hauteur de la carte à modifier par la suite
          double cardWidth =
              (constraints.maxWidth * 0.30).clamp(300.0, constraints.maxWidth);
          double cardHeight = (constraints.maxHeight * 0.30)
              .clamp(400.0, constraints.maxHeight);

          return ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: cardWidth, maxHeight: cardHeight),
            child: page,
          );
        },
      ),
    ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Hash the password
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    print('password: $password, bytes: $bytes, digest: $digest');
  }

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
                labelText: 'Confirm password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                    ),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle register logic here
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
