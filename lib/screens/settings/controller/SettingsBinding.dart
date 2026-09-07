import 'package:get/get.dart';

import 'SettingsController.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController());

  }
}