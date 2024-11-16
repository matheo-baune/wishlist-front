import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../SessionManager.dart';
import '../features/authentication/presentation/widget/loginForm.dart';
import 'SharedData.dart';
import 'models/GiftModel.dart';
import 'models/GroupModel.dart';
import 'models/UserModel.dart';

class Utils {
  // Private constructor
  Utils._privateConstructor();

  // Static instance
  static final Utils _instance = Utils._privateConstructor();

  // Factory constructor to return the static instance
  factory Utils() {
    return _instance;
  }

  static const double SIZE_SIDEBAR = 100;

  Route pageRouteSlideRightToLeft(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Future<List<UserModel>> fetchUser(int id) async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/groups/$id/users'),
        headers: <String, String>{
          'Authorization': 'Bearer ${await SessionManager().getCookieSession()}',
        });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<GiftModel>> fetchGift(int userId, int groupId) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${dotenv.env['API_URL']}/users/$userId/groups/$groupId/gifts'),
          headers: <String, String>{
            'Authorization': 'Bearer ${await SessionManager().getCookieSession()}',
          });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => GiftModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load gifts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception('Failed to load gifts due to an error: $e');
    }
  }

  void showDialogAddGift(BuildContext context, int groupId, UserModel user) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _linkController = TextEditingController();
    final TextEditingController _imageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un cadeau'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prix',
                ),
              ),
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Lien',
                ),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await _requestAddGift(
                    groupId,
                    _nameController.text.trim(),
                    _descriptionController.text.trim(),
                    _priceController.text.trim(),
                    _linkController.text.trim(),
                    _imageUrlController.text.trim(),
                    await SessionManager().getUserSession().then((value) => value.id)
                );
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestAddGift(int groupId, String name, String description,
      String price, String link, String imageUrl, int userId) async {
    try {
      final response =
          await http.post(Uri.parse('${dotenv.env['API_URL']}/gifts/'),
              body: jsonEncode({
                'group_id': groupId, // Replace 1 with the actual group ID
                'name': name,
                'description': description,
                'price': price,
                'link': link,
                'image_url': imageUrl,
                'created_by': userId
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${await SessionManager().getCookieSession()}',
          });
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(
            'Failed to load gifts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception('Failed to load gifts due to an error: $e');
    }
  }

  String encodePassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<List<GroupModel>> fetchGroups() async {
    String cookie = await SessionManager().getCookieSession();
    UserModel userSession = await SessionManager().getUserSession();
    final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/users/${userSession.id}/groups'),
        headers: <String, String>{
          'Authorization': 'Bearer $cookie',
        });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => GroupModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  void showDialogRemoveGroup(BuildContext context, int groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer un groupe'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce groupe ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                removeGroup(groupId); // Replace 1 with the actual group ID
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void removeGroup(int groupId) async {
    final uri = Uri.parse('${dotenv.env['API_URL']}/groups/$groupId');
    final response = await http.delete(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${await SessionManager().getCookieSession()}',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete group');
    }
  }

  void showJoinGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rejoindre un groupe'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Entrez le code du groupe',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(pageRouteSlideRightToLeft(const LoginForm()));
              },
              child: const Text('Rejoindre'),
            ),
          ],
        );
      },
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<UserModel> getUserFromSession() async {
    String? data = await SessionManager().getStringFromSession('user-data');
    if (data != null) {
      Map<String, dynamic> userMap = jsonDecode(data);
      return UserModel.fromJson(userMap);
    } else {
      throw Exception('No user data found in session');
    }
  }

  void createGroupRequest(BuildContext context,
      {name, description, code}) async {
    SharedData sharedData = Provider.of<SharedData>(context, listen: false);
    await http.post(Uri.parse('${dotenv.env['API_URL']}/groups/'),
        body: jsonEncode({
          'name': name,
          'description': description,
          'code': code,
          'created_by': (await SessionManager().getUserSession()).id,
          // Replace 1 with the actual user ID
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await SessionManager().getCookieSession()}'
        });
    sharedData.currentIndex = 0;
  }


  Future<bool> isImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        return contentType != null && contentType.startsWith('image/');
      }
    } catch (e) {
      print('Error checking URL: $e');
    }
    return false;
  }
}
