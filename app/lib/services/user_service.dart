import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:smart_money/api/register_user.dart';
import 'package:smart_money/api/login_user.dart';
import 'package:smart_money/controller/auth_controller.dart';

class UserService {
  final AuthController _authController = Get.put(AuthController());

  AuthController get authController => _authController;
  final Logger _logger = Logger('TransactionService');

  UserService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.log(record.level,
          '${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> register(UserRegister user) async {
    var url = Uri.parse('http://localhost:3000/user');

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
        _logger.info('Usuário cadastrado com sucesso!');
      } else {
        _logger.severe(
            'Falha ao cadastrar usuário. Status: ${response.statusCode}');
        _logger.info('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Erro ao fazer requisição: $e');
    }
  }

  Future<void> login(LoginUser user) async {
    var url = Uri.parse('http://localhost:3000/login');

    var userJson = user.toLoginJson();

    try {
      _logger.info("Chegou aqui");
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userJson),
      );

      _logger.info(response);

      if (response.statusCode == 200) {
        _logger.info('Usuário logado com sucesso!');
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['access_token'];
        _authController.setAccessToken(token);
      } else {
        _logger.severe('Falha ao fazer login. Status: ${response.statusCode}');
        _logger.info('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Erro ao fazer requisição: $e');
    }
  }
}
