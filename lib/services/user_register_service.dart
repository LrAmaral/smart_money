import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/register_user.dart';

class UserService {
  Future<void> registerUser(UserRegister user) async {
    var url = Uri.parse('localhost:3000/user');

    var userJson = user.toJson();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userJson),
      );

      if (response.statusCode == 201) {
        print('Usuário cadastrado com sucesso!');
      } else {
        print('Falha ao cadastrar usuário. Status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }
}
