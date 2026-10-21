import 'package:food_merchant/screens/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:get/get.dart';

class RestaurantDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RestaurantDetailsController>(RestaurantDetailsController());

  }
}