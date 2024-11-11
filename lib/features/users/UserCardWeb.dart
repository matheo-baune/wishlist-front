import 'package:flutter/material.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

class UserCardWeb extends StatelessWidget {
  final UserModel user;
  final int groupdId;

  const UserCardWeb({required this.user,required this.groupdId, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person,color: Colors.red,),
        title: Text('Liste de ${user.username}'),
        onTap: () {
          Navigator.of(context).pushNamed('/group/users', arguments: {'user': user, 'groupId': groupdId});
        },
      ),
    );
  }
}