class GiftModel {
  final int id;
  final String name;
  final String? description;
  final String? link;
  final String? imageUrl;
  final double? price;
  final int groupId;
  final int createdBy;
  final String createdAt;
  final bool reserved;

  GiftModel({
    required this.id,
    required this.name,
    this.description,
    this.link,
    this.imageUrl,
    this.price,
    required this.groupId,
    required this.createdBy,
    required this.createdAt,
    required this.reserved,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      link: json['link'],
      imageUrl: json['image_url'],
      price: (json['price'] as num?)?.toDouble(),
      groupId: json['group_id'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      reserved: json['_reserved'],
    );
  }
}