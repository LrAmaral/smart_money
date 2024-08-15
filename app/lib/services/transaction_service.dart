import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';

class TransactionService {
  final logger = LoggerService();
  final AuthController authController = Get.put(AuthController());

  Future<void> registerTransaction(Map<String, dynamic> goalData) async {
    var url = Uri.parse('http://10.0.2.2:3000/transaction');
    final token = authController.getAccessToken();

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(goalData),
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
}
