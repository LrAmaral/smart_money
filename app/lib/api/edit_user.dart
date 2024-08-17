import 'dart:convert';

EditUser editUserFromJson(String str) => EditUser.fromJson(json.decode(str));

String editUserToJson(EditUser data) => json.encode(data.toJson());

class EditUser {
  String email;
  String name;
  String? password;

  EditUser({
    required this.email,
    required this.name,
    this.password,
  });

  factory EditUser.fromJson(Map<String, dynamic> json) => EditUser(
        email: json["email"],
        name: json["name"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        if (password != null && password!.isNotEmpty) "password": password,
      };
}

extension EditUserExtension on EditUser {
  Map<String, dynamic> toEditJson() => {
        "email": email,
        "name": name,
        if (password != null && password!.isNotEmpty) "password": password,
      };
}
