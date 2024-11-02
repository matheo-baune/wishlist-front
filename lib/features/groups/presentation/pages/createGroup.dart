import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../core/SharedData.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupDescriptionController = TextEditingController();
  TextEditingController _groupCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a group'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _groupNameController,
                      decoration:
                          const InputDecoration(labelText: 'Group name'),
                    ),
                    TextField(
                      controller: _groupDescriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Group description'),
                    ),
                    TextField(
                      controller: _groupCodeController,
                      decoration:
                          const InputDecoration(labelText: 'Group code'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _createGroupRequest(context);
                        print("Group created");
                      },
                      child: const Text('Create group'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroupRequest(BuildContext context) async {
    SharedData sharedData = Provider.of<SharedData>(context, listen: false);
    await http.post(Uri.parse('${dotenv.env['API_URL']}/groups/'),
        body: jsonEncode({
          'name': _groupNameController.text,
          'description': _groupDescriptionController.text,
          'code': _groupCodeController.text,
          'created_by': 1 // Replace 1 with the actual user ID
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    sharedData.currentIndex = 0;
  }
}
