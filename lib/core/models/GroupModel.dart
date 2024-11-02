class GroupModel{
  final int id;
  final String name;
  final String description;
  final int created_by;
  final String code;
  final String created_at;

  GroupModel(this.id, this.name, this.description, this.created_by, this.code, this.created_at);

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      json['id'],
      json['name'],
      json['description'] ?? '',
      json['created_by'],
      json['code'],
      json['created_at'],
    );
  }
}