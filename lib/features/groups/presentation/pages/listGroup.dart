import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:wishlist_front/core/models/GroupModel.dart';

import 'package:wishlist_front/core/Utils.dart';
import 'groupCardWeb.dart';



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
    futureGroups = Utils.fetchGroups();
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