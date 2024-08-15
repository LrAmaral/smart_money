import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_money/api/register_user.dart';
import 'package:smart_money/api/login_user.dart';
import 'package:smart_money/controller/auth_controller.dart';

class UserService {
  final AuthController _authController = Get.put(AuthController());

  AuthController get authController => _authController;

  Future<void> register(UserRegister user) async {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Usuário cadastrado com sucesso!');
      } else {
        print('Falha ao cadastrar usuário. Status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }

  Future<void> login(LoginUser user) async {
    var url = Uri.parse('http://10.0.2.2:3000/login');

    var userJson = user.toLoginJson();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userJson),
      );

      if (response.statusCode == 200) {
        print('Usuário logado com sucesso!');
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['access_token'];
        _authController.setAccessToken(token);
      } else {
        print('Falha ao fazer login. Status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }
}
