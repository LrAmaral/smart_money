import 'dart:convert';

UserRegister userFromJson(String str) =>
    UserRegister.fromJson(json.decode(str));

String userToJson(UserRegister data) => json.encode(data.toJson());

class UserRegister {
  String email;
  String name;
  String password;

  UserRegister({
    required this.email,
    required this.name,
    required this.password,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        email: json["email"],
        name: json["name"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "password": password,
      };
}

extension UserRegisterExtension on UserRegister {
  Map<String, dynamic> toRegisterJson() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
