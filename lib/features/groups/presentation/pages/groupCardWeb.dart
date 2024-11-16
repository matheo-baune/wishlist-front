import 'package:flutter/material.dart';

import 'package:wishlist_front/core/models/GroupModel.dart';

import 'package:wishlist_front/core/Utils.dart';


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
          Utils().capitalize('${group.name} - Code : ${group.code}'),
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
                Utils().showDialogRemoveGroup(context,group.id),
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
