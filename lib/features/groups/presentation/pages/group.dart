import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:wishlist_front/core/models/GroupModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';
import 'package:wishlist_front/features/gifts/presentation/pages/listGift.dart';


class GroupPage extends StatefulWidget {
  final GroupModel group;

  const GroupPage({required this.group, super.key});

  @override
  State<StatefulWidget> createState() => _GroupState();
}

class _GroupState extends State<GroupPage> {

  late final int idGroup;
  late Future<List<UserModel>> futureUsers;

  @override
  void initState() {
    super.initState();
    idGroup = widget.group.id;
    futureUsers = fetchUser(idGroup);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.group.name),
      ),
      body: FutureBuilder<List<UserModel>>(
          initialData: const [],
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No users in group found', style: TextStyle(color: Colors.white),));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return UserCardWeb(user: snapshot.data![index], groupdId: idGroup);
                      },
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}


Future<List<UserModel>> fetchUser(int id) async {
  final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/groups/$id/users'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => UserModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load user');
  }
}

class UserCardWeb extends StatelessWidget {
  final UserModel user;
  final int groupdId;

  const UserCardWeb({required this.user,required this.groupdId, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(),
        title: Text(user.username),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListGift(userModel: user, groupId: groupdId)));
        },
      ),
    );
  }
}