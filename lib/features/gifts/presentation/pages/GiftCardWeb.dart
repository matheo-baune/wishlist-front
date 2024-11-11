import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:wishlist_front/core/models/GiftModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';


class GiftCardWeb extends StatelessWidget {
  final GiftModel gift;
  final UserModel user;

  GiftCardWeb({required this.gift, super.key, required this.user});

  double sizeImage = 50;
  late Widget icon = Icon(Icons.image, size: sizeImage);

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