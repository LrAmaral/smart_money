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

  void setName(String name) {
    userProfile.update('name', (_) => name, ifAbsent: () => name);
  }

  String getName() {
    return userProfile['name'] ?? '';
  }

  void setEmail(String email) {
    userProfile.update('email', (_) => email, ifAbsent: () => email);
  }

  String getEmail() {
    return userProfile['email'] ?? '';
  }

  void clearAuthData() {
    accessToken.value = '';
    userProfile.clear();
  }
}
