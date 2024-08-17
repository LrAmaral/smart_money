import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_money/controller/auth_controller.dart';

class ProfileService {
  Map<String, dynamic> getUserDataFromToken() {
    final AuthController authController = Get.put(AuthController());
    final token = authController.getAccessToken();

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String userName = decodedToken['name'];
    String userEmail = decodedToken['email'];
    String id = decodedToken['sub'];

    return {"name": userName, "email": userEmail, "id": id};
  }
}
