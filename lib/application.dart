import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wishlist_front/core/widget/SideBarNavigation.dart';
import 'package:wishlist_front/features/authentication/presentation/pages/login.dart';
import 'SessionManager.dart';
import 'core/Utils.dart';
import 'core/widget/ContentNavigator.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  bool? isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool authStatus = await SessionManager().isAuthentified();
    setState(() {
      isAuthenticated = authStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated == false) {
      return const Authentication();
    }

    return Scaffold(
      body: Row(
        children: <Widget>[
          const SidebarNavigation(),
          SizedBox(
            width: MediaQuery.of(context).size.width - Utils.SIZE_SIDEBAR,
            height: MediaQuery.of(context).size.height,
            child: ContentNavigator(),
          ),
        ],
      ),
    );
  }
}
