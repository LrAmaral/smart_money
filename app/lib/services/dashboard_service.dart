import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/logger_service.dart';

class DashboardService {
  Future<Map<String, dynamic>> getData() async {
    final logger = LoggerService();
    final AuthController authController = Get.put(AuthController());
    final token = authController.getAccessToken();

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String userId = decodedToken['sub'];
    String userName = decodedToken['name'];
    String userEmail = decodedToken['email'];

    var url = Uri.parse('http://10.0.2.2:3000/dashboard/$userId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dashboardData =
            Map<String, dynamic>.from(json.decode(response.body));

        return {
          "user": {
            "name": userName,
            "email": userEmail,
          },
          "dashboard": dashboardData,
        };
      } else {
        logger.error('Falha ao consultado dados: ${response.body}');
        return {};
      }
    } catch (e) {
      logger.error('Erro ao fazer requisição.', error: e);
      return {};
    }
  }
}
