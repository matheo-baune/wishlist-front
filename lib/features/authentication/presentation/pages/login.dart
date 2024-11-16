import 'package:flutter/material.dart';
import 'package:wishlist_front/features/authentication/presentation/widget/loginForm.dart';
import 'package:wishlist_front/features/authentication/presentation/widget/registerForm.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              //TODO - 300 et 400 sont des valeurs arbitraires pour la largeur et la hauteur de la carte à modifier par la suite
              double cardWidth = (constraints.maxWidth * 0.30).clamp(300.0, constraints.maxWidth);
              double cardHeight = (constraints.maxHeight * 0.30).clamp(400.0, constraints.maxHeight);
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardWidth, maxHeight: cardHeight),
                child: const AuthenticationPage(),
              );
              },
          ),
        ),
    );
  }
}

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text : 'Login',
                icon: Icon(Icons.person),
              ),
              Tab(
                text: 'Register',
                icon: Icon(Icons.person_add),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: LoginForm(),
            ),
            Center(
              child: RegisterForm(),
            ),
          ],
        ),
      ),
    );
  }
}
