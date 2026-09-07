import 'package:get/get.dart';

import 'DeliveryAreaController.dart';

class DeliveryAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DeliveryAreaController>(DeliveryAreaController());
  }

}