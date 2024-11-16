import 'package:flutter/material.dart';
import 'package:wishlist_front/Generic.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

import '../../SessionManager.dart';
import '../../core/Utils.dart';

class UserCardWeb extends StatefulWidget {
  final UserModel user;
  final int groupdId;

  const UserCardWeb({required this.user, required this.groupdId, super.key});

  @override
  State<StatefulWidget> createState() => _UserCardWebState();
}

class _UserCardWebState extends State<UserCardWeb> with AutomaticKeepAliveClientMixin<UserCardWeb>{
  late Future<UserModel> userSession;

  @override
  void initState() {
    super.initState();
    userSession = SessionManager().getUserSession();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<UserModel>(
      future: userSession,
      builder: (context, snapshot) {
        if(snapshot.hasData) {

          UserModel userSession = snapshot.data!;
          String title = userSession.id == widget.user.id
              ? 'Ma liste'
              : 'Liste de ${Utils().capitalize(widget.user.username)}';

          return Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.red),
              title: Text(title),
              onTap: () {
                Navigator.of(context).pushNamed('/group/users',
                    arguments: {'user': widget.user, 'groupId': widget.groupdId});
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
