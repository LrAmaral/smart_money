class EditUser {
  final String email;
  final String name;
  final String? password;

  EditUser({
    required this.email,
    required this.name,
    this.password,
  });

  Map<String, dynamic> toEditJson() {
    final Map<String, dynamic> data = {};

    if (email.isNotEmpty) data['email'] = email;
    if (name.isNotEmpty) data['name'] = name;
    if (password != null && password!.isNotEmpty) data['password'] = password;

    return data;
  }
}
