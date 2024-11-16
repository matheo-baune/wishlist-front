import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wishlist_front/SessionManager.dart';

import 'package:wishlist_front/core/SharedData.dart';

import '../Utils.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  State<SidebarNavigation> createState() => _SidebarNavigation();
}

class _SidebarNavigation extends State<SidebarNavigation> {
  @override
  Widget build(BuildContext context) {
    final sharedData = Provider.of<SharedData>(context);
    const double borderSize = 1;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.black, // Border color
            width: borderSize, // Border width
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: Utils.SIZE_SIDEBAR-borderSize,
            child: NavigationRail(
              selectedIndex: sharedData.currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  if (index == 2) {
                    _showDialogJoinGroup(context);
                  } else {
                    sharedData.currentIndex = index;
                  }
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.group_add),
                  label: Text('Join'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add),
                  label: Text('Create'),
                ),
              ],
              groupAlignment: 0.0,
              trailing: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await SessionManager().clearSession();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showDialogJoinGroup(BuildContext context) {
  final sharedData = Provider.of<SharedData>(context, listen: false);
  final TextEditingController _groupCodeController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Join a group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _groupCodeController,
              decoration: const InputDecoration(
                labelText: 'Group Code',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _requestJoinGroup(_groupCodeController.text.trim(), (await SessionManager().getUserSession()).id, context); // Replace 1 with the actual user ID
              sharedData.currentIndex = 0;
            },
            child: const Text('Join'),
          ),
        ],
      );
    },
  );
}

void _requestJoinGroup(String groupCode, int userId, BuildContext context) async {
  final response = await http.post(Uri.parse('${dotenv.env['API_URL']}/groups/$groupCode/join/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${await SessionManager().getCookieSession()}',
    },
  );
  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to load user');
  }
}