import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money/controller/auth_controller.dart';
import 'package:logging/logging.dart';

class GoalService {
  final Logger _logger = Logger('TransactionService');

  GoalService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.log(record.level,
          '${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> registerGoal(Map<String, dynamic> goalData) async {
    var url = Uri.parse('http://localhost:3000/goal');
    final AuthController authController = Get.put(AuthController());
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
        _logger.info('Meta cadastrada com sucesso!');
      } else {
        _logger
            .severe('Falha ao cadastrar meta. Status: ${response.statusCode}');
        _logger.info('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Erro ao fazer requisição: $e');
    }
  }
}
