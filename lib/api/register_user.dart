import 'dart:convert';

UserRegister welcomeFromJson(String str) =>
    UserRegister.fromJson(json.decode(str));

String welcomeToJson(UserRegister data) => json.encode(data.toJson());

class UserRegister {
  String id;
  String email;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  UserRegister({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
