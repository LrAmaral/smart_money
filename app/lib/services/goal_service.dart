import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/constants/env.dart';
import 'package:smart_money/utils/custom_exception.dart';

class GoalService {
  final logger = LoggerService();
  final AuthController _authController = Get.put(AuthController());
  AuthController get authController => _authController;

  Future<void> registerGoal(Map<String, dynamic> goalData) async {
    final String token = authController.getAccessToken();
    var url = Uri.parse('${ApiConstants.baseUrl}/goal');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(goalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Meta cadastrada com sucesso!');
      } else {
        logger.error('Erro ao cadastrar meta: ${response.body}');
        throw CustomException('Erro ao cadastrar meta');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      throw CustomException('Erro ao cadastrar meta');
    }
  }

  Future<List<Map<String, dynamic>>?> getGoals() async {
    final String token = authController.getAccessToken();
    var url = Uri.parse('${ApiConstants.baseUrl}/goal');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        logger.info('Metas carregadas com sucesso!');
        final goalsData = json.decode(response.body) as List<dynamic>;
        return goalsData.cast<Map<String, dynamic>>();
      } else {
        logger.error('Erro ao carregar metas: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      return null;
    }
  }

  Future<void> editGoal(String goalId, Map<String, dynamic> goalData) async {
    final String token = authController.getAccessToken();
    var url = Uri.parse('${ApiConstants.baseUrl}/goals/$goalId');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(goalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.info('Meta editada com sucesso!');
      } else {
        logger.error('Erro ao editar meta: ${response.body}');
        throw CustomException('Erro ao editar meta');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      throw CustomException('Erro ao editar meta');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final String token = authController.getAccessToken();
    var url = Uri.parse('${ApiConstants.baseUrl}/goal/$goalId');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.info('Meta deletada com sucesso!');
      } else {
        logger.error('Erro ao deletar meta: ${response.body}');
        throw CustomException('Erro ao deletar meta');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      throw CustomException('Erro ao deletar meta');
    }
  }
}
