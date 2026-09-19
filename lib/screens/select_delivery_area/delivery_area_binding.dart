import 'package:get/get.dart';
import 'delivery_area_controller.dart';

class DeliveryAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryAreaController>(() => DeliveryAreaController());
  }

}