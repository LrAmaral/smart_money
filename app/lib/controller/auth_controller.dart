import 'package:get/get.dart';

class AuthController extends GetxController {
  var accessToken = ''.obs;

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  String getAccessToken() {
    return accessToken.value;
  }
}
