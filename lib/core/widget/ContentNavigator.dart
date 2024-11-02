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
    final sharedData = Provider.of<SharedData>(context, listen: false);
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
            return pageRouteSlideRightToLeft(
                GroupPage(group: settings.arguments as GroupModel));
          case '/group/users':
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as UserModel?;
            final groupId = args['groupId'] as int?;

            if (user != null && groupId != null) {
              return pageRouteSlideRightToLeft(
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


Route pageRouteSlideRightToLeft(Widget page, {RouteSettings? settings}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
