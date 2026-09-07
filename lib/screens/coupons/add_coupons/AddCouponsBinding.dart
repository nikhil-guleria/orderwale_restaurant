import 'package:get/get.dart';

import 'add_coupons_controller.dart';

class AddCouponsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddCouponsController>(AddCouponsController());
  }

}