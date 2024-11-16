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

class _ListGroupState extends State<ListGroup>
    with AutomaticKeepAliveClientMixin<ListGroup> {
  late Future<List<GroupModel>> futureGroups;

  bool isWeb() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  @override
  void initState() {
    super.initState();
    futureGroups = Utils().fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isWeb()) {
      return FutureBuilder<List<GroupModel>>(
          initialData: const [],
          future: futureGroups,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData ||
                snapshot.data!.isEmpty ||
                snapshot.hasError) {
              return const Center(child: Text('No groups found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GroupCardWeb(group: snapshot.data![index]);
                },
              );
            }
          });
    } else {
      //TODO - Version mobile
      return const Scaffold(
        body: Center(
          child: Text('Mobile'),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
