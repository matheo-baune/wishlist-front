import 'package:flutter/material.dart';
import 'package:wishlist_front/core/widget/SideBarNavigation.dart';
import 'package:wishlist_front/features/authentication/presentation/pages/login.dart';
import 'core/widget/ContentNavigator.dart';

class Application extends StatefulWidget {
  final bool isAuthenticated;
  const Application({super.key, required this.isAuthenticated});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  Widget build(BuildContext context) {
    if(widget.isAuthenticated){
      return Scaffold(
        body: Row(
          children: <Widget>[
            const SidebarNavigation(),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height,
                child: ContentNavigator()
            ),
          ],
        ),
      );
    }else{
      return const Authentication();
    }
  }
}
