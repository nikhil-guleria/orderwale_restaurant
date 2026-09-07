import 'package:get/get.dart';

import 'addCustomisedProductController.dart';

class AddCustomisedProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddCustomisedProductController>(AddCustomisedProductController());

  }
}