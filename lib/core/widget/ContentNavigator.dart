import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wishlist_front/features/groups/presentation/pages/listGroup.dart';
import 'package:wishlist_front/core/SharedData.dart';
import 'package:wishlist_front/features/authentication/presentation/pages/profile.dart';
import 'package:wishlist_front/features/gifts/presentation/pages/listGift.dart';
import 'package:wishlist_front/features/groups/presentation/pages/createGroup.dart';
import 'package:wishlist_front/features/groups/presentation/pages/group.dart';

import 'package:wishlist_front/core/models/GroupModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';
import 'package:wishlist_front/core/Utils.dart';

class ContentNavigator extends StatelessWidget {
  ContentNavigator({super.key});

  final List<Widget> pages = [
    const ListGroup(),
    const ProfilePage(),
    const Placeholder(color: Colors.red), //Dialog to join group
    const CreateGroupPage(),
    const Placeholder(color: Colors.black),
  ];

  @override
  Widget build(BuildContext context) {
    final sharedData = Provider.of<SharedData>(context);
    return Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        inspect(settings.name);
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => pages[sharedData.currentIndex];
            break;
          case '/group':
            return Utils.pageRouteSlideRightToLeft(
                GroupPage(group: settings.arguments as GroupModel));
          case '/group/users':
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as UserModel?;
            final groupId = args['groupId'] as int?;

            if (user != null && groupId != null) {
              return Utils.pageRouteSlideRightToLeft(
                ListGift(
                  userModel: user,
                  groupId: groupId,
                ),
              );
            } else {
              throw Exception('Invalid arguments for /group/users route');
            }

          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}