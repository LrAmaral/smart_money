import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/constants/env.dart';

class TransactionService {
  final logger = LoggerService();
  final AuthController authController = Get.put(AuthController());

  Future<void> registerTransaction(Map<String, dynamic> transactionData) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/transaction');
    final token = authController.getAccessToken();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
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
    final userId = authController.getUserId();

    var url = Uri.parse('${ApiConstants.baseUrl}/transaction/$userId');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);

        if (data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else {
          logger.error('Formato inesperado da resposta: ${response.body}');
          return [];
        }
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
    final token = authController.getAccessToken();
    var url = Uri.parse('${ApiConstants.baseUrl}/transaction/$transactionId');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
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
          'Content-Type': ApiConstants.contentType,
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
