import 'package:get/get.dart';

import 'forgotPasswordController.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForgotPasswordController>(ForgotPasswordController());

  }
}