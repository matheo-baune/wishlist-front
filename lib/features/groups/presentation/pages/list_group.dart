import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;

class ListGroup extends StatefulWidget {
  const ListGroup({super.key});

  final String title = 'Liste des groupes';

  @override
  State<StatefulWidget> createState() => _ListGroupState();
}

class _ListGroupState extends State<ListGroup> {
  late Future<List<Group>> futureGroups;

  bool isWeb() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  @override
  void initState() {
    super.initState();
    futureGroups = fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    if (isWeb()) {
      return Scaffold(
          body: FutureBuilder<List<Group>>(
              initialData: [],
              future: futureGroups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(child: Text('Error2: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No groups found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GroupCard(group: snapshot.data![index]);
                    },
                  );
                }
              }));
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Mobile'),
        ),
      );
    }
  }
}

Future<List<Group>> fetchGroups() async {
  final uri = Uri.parse('http://127.0.0.1:8080/api/groups/');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Group.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load groups');
  }
}

class Group {
  final int id;
  final String name;
  final int created_by;
  final String code;
  final String created_at;

  Group(this.id, this.name, this.created_by, this.code, this.created_at);

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      json['id'],
      json['name'],
      json['created_by'],
      json['code'],
      json['created_at'],
    );
  }
}

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          Text(group.name),
          Text(group.code),
        ],
      ),
    );
  }
}
