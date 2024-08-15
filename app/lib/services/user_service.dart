import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:smart_money/api/register_user.dart';

class UserService {
  final Logger _logger = Logger('TransactionService');

  UserService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.log(record.level,
          '${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> registerUser(UserRegister user) async {
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

      if (response.statusCode == 201) {
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
}
