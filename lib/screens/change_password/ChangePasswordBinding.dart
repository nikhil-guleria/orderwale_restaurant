import 'package:get/get.dart';

import 'ChangePasswordController.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChangePasswordController>(ChangePasswordController());

  }
}