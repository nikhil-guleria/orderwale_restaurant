import 'package:get/get.dart';

import 'NotificationsController.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationsController>(NotificationsController());

  }
}