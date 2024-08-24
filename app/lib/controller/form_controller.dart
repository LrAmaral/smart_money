import 'package:get/get.dart';

class FormController extends GetxController {
  var errorMessage = ''.obs;

  void setErrorMessage(String message) {
    errorMessage.value = message;
  }

  String getErrorMessage() {
    return errorMessage.value;
  }

  void clearErrorMessage() {
    errorMessage.value = '';
  }
}
