import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class TransactionService {
  final Logger _logger = Logger('TransactionService');

  TransactionService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.log(record.level,
          '${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> registerTransaction(Map<String, dynamic> goalData) async {
    var url = Uri.parse('http://10.0.2.2:3000/transaction');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(goalData),
      );

      if (response.statusCode == 201) {
        _logger.info('Transação cadastrada com sucesso!');
      } else {
        _logger.warning(
            'Falha ao cadastrar transação. Status: ${response.statusCode}');
        _logger.warning('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Erro ao fazer requisição: $e');
    }
  }
}
