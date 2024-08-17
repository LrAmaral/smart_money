import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_money/api/register_user.dart';
import 'package:smart_money/api/login_user.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';

class UserService {
  final logger = LoggerService();
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
        logger.info('Usuário cadastrado com sucesso!');
      } else {
        logger.error(
            'Falha ao cadastrar usuário. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
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
        logger.info('Usuário logado com sucesso!');
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['access_token'];
        _authController.setAccessToken(token);
      } else {
        logger.error('Falha ao fazer login. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<void> editProfile(Map<String, dynamic> user, userId) async {
    var token = authController.getAccessToken();
    var url = Uri.parse('http://10.0.2.2:3000/user/$userId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Edição feita com sucesso!');
      } else {
        logger
            .error('Falha ao realizar edição. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }
}
