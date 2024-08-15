import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money/controller/auth_controller.dart';

class GoalService {
  Future<void> registerGoal(Map<String, dynamic> goalData) async {
    var url = Uri.parse('http://10.0.2.2:3000/goal');
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
        print('Meta cadastrada com sucesso!');
      } else {
        print('Falha ao cadastrar meta. Status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }
}
