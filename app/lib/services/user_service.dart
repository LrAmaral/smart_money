import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_money/api/register_user.dart';
import 'package:smart_money/api/login_user.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/constants/env.dart';
import 'package:smart_money/utils/custom_exception.dart';

class UserService {
  final logger = LoggerService();
  final AuthController _authController = Get.put(AuthController());
  AuthController get authController => _authController;

  Future<void> register(UserRegister user) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user');
    var userJson = user.toRegisterJson();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
        body: json.encode(userJson),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Usuário cadastrado com sucesso!');
      } else {
        logger.error('Erro ao cadastrar usuário: ${response.body}');
        throw CustomException(response.statusCode == 409
            ? 'Email já existente'
            : 'Erro ao cadastrar usuário');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      throw CustomException(e.toString());
    }
  }

  Future<void> login(LoginUser user) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/login');

    var userJson = user.toLoginJson();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
        body: json.encode(userJson),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['access_token'];
        _authController.setAccessToken(token);
        logger.info('Usuário logado com sucesso!');
      } else {
        logger.error('Erro ao fazer login: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<void> editProfile(Map<String, dynamic> user) async {
    var token = authController.getAccessToken();
    var userId = authController.getUserId();
    var url = Uri.parse('${ApiConstants.baseUrl}/user/$userId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Authorization': 'Bearer $token',
        },
        body: json.encode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Edição feita com sucesso!');
      } else {
        logger.error('Falha ao realizar edição: ${response.body}');
        throw CustomException(response.statusCode == 400
            ? 'Email Inválido'
            : 'Erro ao cadastrar usuário');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<void> editProfileByEmail(String email, String password) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user/by-email/$email');

    var userJson = json.encode({
      'password': password,
    });

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
        body: userJson,
      );

      if (response.statusCode == 200) {
        logger.info('Edição feita com sucesso!');
      } else if (response.statusCode == 404) {
        throw Exception('Email não encontrado');
      } else {
        throw Exception('Falha ao realizar edição: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      rethrow; // Lança a exceção novamente para que possa ser capturada no nível superior
    }
  }

  Future<void> deleteProfile() async {
    var token = authController.getAccessToken();
    var userId = authController.getUserId();

    var url = Uri.parse('${ApiConstants.baseUrl}/user/$userId');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Remoção feita com sucesso!');
      } else {
        logger.error('Falha ao realizar remoção: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = authController.getAccessToken();
    final userId = authController.getUserId();

    var url = Uri.parse('${ApiConstants.baseUrl}/user/$userId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        logger.info('Perfil carregado com sucesso!');
        final profileData = json.decode(response.body) as Map<String, dynamic>;
        _authController.setUserProfile(profileData);
        return profileData;
      } else {
        logger
            .error('Falha ao carregar perfil. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      return null;
    }
  }
}
