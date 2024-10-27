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
  _ListGiftState createState() => _ListGiftState();
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
      body: FutureBuilder<List<GiftModel>>(
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
    );
  }
}

class GiftCardWeb extends StatelessWidget {
  final GiftModel gift;

  GiftCardWeb({required this.gift, super.key});

  double sizeImage = 50;
  late Widget icon = gift.imageUrl != null ? Image.network(
    gift.imageUrl!,
    width: sizeImage,
    height: sizeImage,
    fit: BoxFit.contain,
  ) : Icon(Icons.image, size: sizeImage);



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
        trailing: Text(gift.price != null ? "${gift.price} €" : 'Non renseigné'),
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
