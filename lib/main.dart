import 'package:flutter/material.dart';
import 'package:wishlist_front/features/authentication/presentation/pages/login.dart';
import 'package:wishlist_front/features/groups/presentation/pages/listGroup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "../.env");
  runApp(const WishList());
}

class WishList extends StatelessWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context) {

    //Ajouter logique de connexion pour choisir quel page afficher
    Widget page = true ? const ListGroup() : const Authentication();

    return MaterialApp(
      title: 'WishList',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: page,
    );
  }
}

