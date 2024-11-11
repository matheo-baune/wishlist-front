import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wishlist_front/core/models/GroupModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

import 'package:wishlist_front/features/users/UserCardWeb.dart';

import 'package:wishlist_front/core/Utils.dart';


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
    inspect(widget.group);
    super.initState();
    idGroup = widget.group.id;
    futureUsers = Utils.fetchUser(idGroup);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.group.name} - Code : ${widget.group.code}'),
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