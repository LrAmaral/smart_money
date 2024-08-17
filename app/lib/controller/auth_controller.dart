import 'package:get/get.dart';

class AuthController extends GetxController {
  var accessToken = ''.obs;
  var userProfile = <String, dynamic>{}.obs;

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  String getAccessToken() {
    return accessToken.value;
  }

  void setUserProfile(Map<String, dynamic> profile) {
    userProfile.value = profile;
  }

  Map<String, dynamic> getUserProfile() {
    return userProfile.value;
  }

  void clearAuthData() {
    accessToken.value = '';
    userProfile.clear();
  }
}
