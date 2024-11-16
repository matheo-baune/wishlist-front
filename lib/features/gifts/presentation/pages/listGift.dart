import 'package:flutter/material.dart';
import 'package:wishlist_front/SessionManager.dart';
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

class _ListGiftState extends State<ListGift> with AutomaticKeepAliveClientMixin<ListGift> {
  late final UserModel userModel;
  UserModel? userSession;
  late Future<List<GiftModel>> futureGifts;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    _initializeUserSession();
  }

  Future<void> _initializeUserSession() async {
    userSession = await SessionManager().getUserSession();
    setState(() {
      futureGifts = Utils().fetchGift(userModel.id, widget.groupId);
    });
  }

  bool isMine() {
    return userSession != null && userModel.id == userSession!.id;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userSession == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String username = isMine() ? 'Moi' : Utils().capitalize(userModel.username);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(username),
      ),
      body: Stack(children: [
        FutureBuilder<List<GiftModel>>(
            future: futureGifts,
            initialData: const [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Utils().showDialogAddGift(
                                context, widget.groupId, userModel);
                          },
                          label: const Text('Ajouter un cadeau'),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: constraints.maxWidth / 2,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GiftCardWeb(
                                  gift: snapshot.data![index], user: userModel);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}