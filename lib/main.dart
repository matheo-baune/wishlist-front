import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_front/core/SharedData.dart';
import 'package:wishlist_front/application.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool isWeb() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  if(!isWeb()){
    dotenv.env['API_URL'] = dotenv.env['API_URL_PHONE']!;
  }

  runApp(ChangeNotifierProvider(
    create: (context) => SharedData(),
    child: const WishList(),
  ));
}

class WishList extends StatelessWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WishList',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Application(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const Application(),
      },
    );
  }
}

