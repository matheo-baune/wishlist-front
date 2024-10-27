class GroupModel{
  final int id;
  final String name;
  final int created_by;
  final String code;
  final String created_at;

  GroupModel(this.id, this.name, this.created_by, this.code, this.created_at);

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      json['id'],
      json['name'],
      json['created_by'],
      json['code'],
      json['created_at'],
    );
  }
}