import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/constants/env.dart';

class TransactionService {
  final logger = LoggerService();
  final AuthController authController = Get.put(AuthController());

  Future<String> getData() async {
    final token = authController.getAccessToken();

    if (token.isEmpty) {
      logger.info('Token não encontrado ou está vazio');
      return '';
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken['sub'];
      return userId;
    } catch (e) {
      logger.error('Erro ao decodificar o token: $e');
      return '';
    }
  }

  Future<void> registerTransaction(Map<String, dynamic> transactionData) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/transaction');
    final token = authController.getAccessToken();

    logger.warning(transactionData);

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        logger.info('Transação cadastrada com sucesso!');
      } else {
        logger.error(
            'Falha ao cadastrar transação. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final token = authController.getAccessToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String userId = decodedToken['sub'];

    var url = Uri.parse('${ApiConstants.baseUrl}/transaction/$userId');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        logger.info('Transações carregadas com sucesso!');
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        logger.error(
            'Falha ao carregar transações. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
        return [];
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      return [];
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/transaction/$transactionId');
    final token = authController.getAccessToken();

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        logger.info('Transação excluída com sucesso!');
      } else {
        logger.error(
            'Falha ao excluir transação. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }

  Future<void> editTransaction(
      String transactionId, Map<String, dynamic> updatedData) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/transaction/$transactionId');
    final token = authController.getAccessToken();

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        logger.info('Transação atualizada com sucesso!');
      } else {
        logger.error(
            'Falha ao atualizar transação. Status: ${response.statusCode}');
        logger.error('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
    }
  }
}
