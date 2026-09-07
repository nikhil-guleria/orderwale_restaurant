import 'package:get/get.dart';

import 'AddProductController.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddProductController>(AddProductController());

  }
}