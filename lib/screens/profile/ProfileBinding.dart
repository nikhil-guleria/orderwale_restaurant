
import 'package:get/get.dart';

import 'ProfileController.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}