import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_money/controller/auth_controller.dart';

class DashboardService {
  Future<void> getData() async {
    final AuthController authController = Get.put(AuthController());
    final token = authController.getAccessToken();

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String userId = decodedToken['sub'];

    var url = Uri.parse('http://localhost:3000/dashboard/$userId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        print('Consulta realizada com sucesso!');
      } else {
        print('Falha ao consultado dados. Status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }
}
