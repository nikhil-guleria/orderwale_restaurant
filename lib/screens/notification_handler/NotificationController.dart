import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notification = ''.obs;

  void showNotification(String message) {
    notification.value = message;
  }
}