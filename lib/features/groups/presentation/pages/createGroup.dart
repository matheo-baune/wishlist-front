import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../core/SharedData.dart';
import '../../../../core/Utils.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();
  final TextEditingController _groupCodeController = TextEditingController();

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
            Center(
              widthFactor: 0.1,
              child: Card(
                margin: const EdgeInsets.all(16.0),
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
                          Utils().createGroupRequest(context,
                              name: _groupNameController.text,
                              description: _groupDescriptionController.text,
                              code: _groupCodeController.text
                          );
                        },
                        child: const Text('Create group'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
