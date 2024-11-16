import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:wishlist_front/core/models/GiftModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

import '../../../../core/Utils.dart';

class GiftCardWeb extends StatefulWidget {
  final GiftModel gift;
  final UserModel user;

  GiftCardWeb({required this.gift, super.key, required this.user});

  @override
  State<GiftCardWeb> createState() => _GiftCardWebState();
}

class _GiftCardWebState extends State<GiftCardWeb> {
  double sizeImage = 50;

  late Widget icon = Icon(Icons.image, size: sizeImage);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    Widget newIcon = await Utils().isImageUrl(widget.gift.imageUrl!)
        ? Image.network(
            widget.gift.imageUrl!,
            width: sizeImage,
            height: sizeImage,
            fit: BoxFit.cover,
          )
        : Icon(Icons.image, size: sizeImage);
    setState(() {
      icon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          if (widget.gift.link != null && await canLaunchUrlString(widget.gift.link!)) {
            await launchUrlString(widget.gift.link!);
          } else {
            print('Could not launch ${widget.gift.link}');
          }
        },
        leading: icon,
        title: Text(widget.gift.name),
        subtitle: Text(widget.gift.description ?? ''),
        trailing:
            Text(widget.gift.price != null ? "${widget.gift.price} €" : 'Non renseigné'),
      ),
    );
  }
}
