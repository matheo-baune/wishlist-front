import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:wishlist_front/core/SharedData.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  State<SidebarNavigation> createState() => _SidebarNavigation();
}

class _SidebarNavigation extends State<SidebarNavigation>{


  @override
  Widget build(BuildContext context) {
    final sharedData = Provider.of<SharedData>(context);

    return Row(
      children: [
        NavigationRail(
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
            onPressed: () {},
          ),
        ),
        const VerticalDivider(
          thickness: 1,
          color: Colors.black,
        ),
      ],
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
            onPressed: () {
              Navigator.of(context).pop();
              _requestJoinGroup(_groupCodeController.text.trim(), 1);// Replace 1 with the actual user ID
              sharedData.currentIndex = 0;
            },
            child: const Text('Join'),
          ),
        ],
      );
    },
  );
}

void _requestJoinGroup(String groupCode,int userId) async {
  final response = await http.post(Uri.parse('${dotenv.env['API_URL']}/groups/$groupCode/join/$userId'));
  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to load user');
  }
}

