import 'package:get/get.dart';
import 'manage_restaurant_controller.dart';

class ManageRestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageRestaurantController>(() => ManageRestaurantController());
  }
}