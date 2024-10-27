class UserModel{
  final int id;
  final String username;
  final String email;
  final String role;
  final String created_at;

  UserModel(this.id, this.username, this.email, this.role, this.created_at);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id'],
      json['username'],
      json['email'],
      json['role'],
      json['created_at'],
    );
  }
}