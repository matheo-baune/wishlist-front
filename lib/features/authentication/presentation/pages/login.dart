import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../widget/loginForm.dart';
import '../widget/registerForm.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  final Widget page = true ? const RegisterForm() : const LoginForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              //300 et 400 sont des valeurs arbitraires pour la largeur et la hauteur de la carte à modifier par la suite
              double cardWidth = (constraints.maxWidth * 0.30).clamp(300.0, constraints.maxWidth);
              double cardHeight = (constraints.maxHeight * 0.30).clamp(400.0, constraints.maxHeight);
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardWidth, maxHeight: cardHeight),
                child: page,
              );
              },
          ),
        ),
    );
  }
}
