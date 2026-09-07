
import 'package:get/get.dart';

import 'customisationTypeController.dart';

class CustomisationTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomisationTypeController>(CustomisationTypeController());

  }
}