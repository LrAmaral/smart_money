import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_money/api/register_user.dart';

class UserService {
  Future<void> registerUser(UserRegister user) async {
    var url = Uri.parse('http://10.0.2.2:3000/user');

    var userJson = user.toRegisterJson();

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
