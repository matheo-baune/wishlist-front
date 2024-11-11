import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wishlist_front/core/models/UserModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  late Future<UserModel> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = getUserById(1); // Replace 1 with the actual user ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          } else {
            final UserModel user = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username: ${user.username}'),
                  const SizedBox(height: 10),
                  Text('Email: ${user.email}'),
                  const SizedBox(height: 10),
                  Text('Last Name: ${user.created_at}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Future<UserModel> getUserById(int idUser) async {
  final response =
      await http.get(Uri.parse('${dotenv.env['API_URL']}/users/$idUser'));

  if (response.statusCode == 200) {
    dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
    return UserModel.fromJson(data);
  } else {
    throw Exception('Failed to load user');
  }
}
