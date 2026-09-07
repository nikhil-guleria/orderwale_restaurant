import 'package:get/get.dart';

import 'coupons_controller.dart';

class CouponsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CouponsController>(CouponsController());
  }

}