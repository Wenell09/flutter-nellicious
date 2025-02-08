class UserModel {
  final String userId;
  final String username;
  final String image;
  final String email;
  final String role;
  final String password;
  final String createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.image,
    required this.email,
    required this.role,
    required this.password,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? "",
      username: json["username"] ?? "",
      image: json["image"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      password: json["password"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }
}
