import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wishlist_front/core/models/GiftModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

class ListGift extends StatefulWidget {
  final UserModel userModel;
  final int groupId;

  const ListGift({required this.userModel, required this.groupId, super.key});

  @override
  State<ListGift> createState() => _ListGiftState();
}

class _ListGiftState extends State<ListGift> {
  late final UserModel userModel;
  late Future<List<GiftModel>> futureGifts;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    futureGifts = fetchGift(userModel.id, widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userModel.username),
      ),
      body: Stack(children: [
        FutureBuilder<List<GiftModel>>(
          initialData: const [],
          future: futureGifts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No users in group found',
                      style: TextStyle(color: Colors.white)));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GiftCardWeb(gift: snapshot.data![index]);
                      },
                    ),
                  )
                ],
              );
            }
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: ElevatedButton.icon(
              onPressed: () {
                _showDialogAddGift(context, widget.groupId);
              },
              label: const Text('Ajouter un cadeau'),
              icon: Icon(Icons.add)),
        )
      ]),
    );
  }
}

class GiftCardWeb extends StatelessWidget {
  final GiftModel gift;

  GiftCardWeb({required this.gift, super.key});

  double sizeImage = 50;
  late Widget icon = gift.imageUrl != null
      ? Image.network(
          gift.imageUrl!,
          width: sizeImage,
          height: sizeImage,
          fit: BoxFit.contain,
        )
      : Icon(Icons.image, size: sizeImage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          if (gift.link != null && await canLaunchUrlString(gift.link!)) {
            await launchUrlString(gift.link!);
          } else {
            print('Could not launch ${gift.link}');
          }
        },
        leading: icon,
        title: Text(gift.name),
        subtitle: Text(gift.description ?? ''),
        trailing:
            Text(gift.price != null ? "${gift.price} €" : 'Non renseigné'),
      ),
    );
  }
}

Future<List<GiftModel>> fetchGift(int userId, int groupId) async {
  try {
    final response = await http.get(Uri.parse(
        '${dotenv.env['API_URL']}/users/$userId/groups/$groupId/gifts'));
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

void _showDialogAddGift(BuildContext context,int groupId) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
            onPressed: () {
              Navigator.of(context).pop();
              _requestAddGift(
                  groupId, // Replace 1 with the actual group ID
                  _nameController.text.trim(),
                  _descriptionController.text.trim(),
                  _priceController.text.trim(),
                  _linkController.text.trim(),
                  _imageUrlController.text.trim(),
                  1); // Replace 1 with the actual user ID
            },
            child: const Text('Ajouter'),
          ),
        ],
      );
    },
  );
}

void _requestAddGift(int groupId, String name, String description, String price, String link,
    String imageUrl, int userId) async {
  try {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/gifts/'),
        body: jsonEncode(
            {
              'group_id': groupId, // Replace 1 with the actual group ID
              'name': name,
              'description': description,
              'price': price,
              'link': link,
              'image_url': imageUrl,
              'created_by': userId
            }
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
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
