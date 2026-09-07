
import 'package:get/get.dart';

import 'EditDetailsController.dart';

class EditDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditDetailsController>(EditDetailsController());

  }
}