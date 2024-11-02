import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:wishlist_front/core/models/GroupModel.dart';
import 'package:wishlist_front/features/authentication/presentation/pages/login.dart';
import 'package:wishlist_front/features/groups/presentation/pages/group.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wishlist_front/core/widget/bottomAppBar.dart';



class ListGroup extends StatefulWidget {
  const ListGroup({super.key});

  @override
  State<StatefulWidget> createState() => _ListGroupState();
}

class _ListGroupState extends State<ListGroup> {
  late Future<List<GroupModel>> futureGroups;

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
      return FutureBuilder<List<GroupModel>>(
            initialData: const [],
            future: futureGroups,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No groups found'));
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GroupCardWeb(group: snapshot.data![index]);
                        },
                      ),
                    )
                  ],
                );
              }}
    );
    } else {
      //TODO - Version mobile
      return const Scaffold(
        body: Center(
          child: Text('Mobile'),
        ),
      );
    }
  }
}

void _showJoinGroupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Rejoindre un groupe'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Entrez le code du groupe',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémentation de la logique pour rejoindre un groupe
              Navigator.of(context).pop();
              Navigator.of(context).push(_createRoute(const LoginForm()));
            },
            child: const Text('Rejoindre'),
          ),
        ],
      );
    },
  );
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class GroupCardWeb extends StatelessWidget {
  final GroupModel group;

  const GroupCardWeb({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      color: Colors.pink,
      child: ListTile(
        leading: const FlutterLogo(size: 50.0),
        title: Text(
          capitalize('${group.name} - Code : ${group.code}'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(group.description),
        trailing: PopupMenuButton<ListTileTitleAlignment>(
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<ListTileTitleAlignment>>[
            PopupMenuItem<ListTileTitleAlignment>(
              onTap: () => {
                _showDialogRemoveGroup(context,group.id),
              },
              value: ListTileTitleAlignment.threeLine,
              child: const Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Icon(Icons.delete),
                  Text(' Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/group', arguments: group);
        },
      ),
    );
  }
}



Future<List<GroupModel>> fetchGroups() async {
  final uri = Uri.parse('${dotenv.env['API_URL']}/groups/');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => GroupModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load groups');
  }
}

void _showDialogRemoveGroup(BuildContext context,int groupId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Supprimer un groupe'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce groupe ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _removeGroup(groupId);// Replace 1 with the actual group ID
              Navigator.of(context).pop();

            },
            child: const Text('Supprimer'),
          ),
        ],
      );
    },
  );
}

void _removeGroup(int groupId) async {
  final uri = Uri.parse('${dotenv.env['API_URL']}/groups/$groupId');
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to delete group');
  }
}


String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
