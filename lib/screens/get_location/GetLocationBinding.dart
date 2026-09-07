import 'package:get/get.dart';

import 'GetLocationController.dart';

class GetLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetLocationController>(GetLocationController());

  }
}