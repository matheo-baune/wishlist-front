import 'package:flutter/material.dart';
import 'package:wishlist_front/core/widget/SideBarNavigation.dart';
import 'core/widget/ContentNavigator.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          const SidebarNavigation(),
          Expanded(child: ContentNavigator()),
        ],
      ),
    );
  }
}
