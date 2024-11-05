import 'package:flutter/material.dart';
import 'package:wishlist_front/core/models/GiftModel.dart';
import 'package:wishlist_front/core/models/UserModel.dart';

import 'package:wishlist_front/core/Utils.dart';

import '../../../../Generic.dart';
import 'GiftCardWeb.dart';

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
    futureGifts = Utils.fetchGift(userModel.id, widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userModel.username),
      ),
      body: Stack(children: [
        GenericFutureBuilder<GiftModel>(
            future: futureGifts,
            initialData: const [],
            builder: (context, data) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                          return GiftCardWeb(gift: data[index], user: userModel);
                        },
                ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: ElevatedButton.icon(
              onPressed: () {
                Utils.showDialogAddGift(context, widget.groupId, userModel);
              },
              label: const Text('Ajouter un cadeau'),
              icon: Icon(Icons.add)),
        )
      ]),
    );
  }
}

