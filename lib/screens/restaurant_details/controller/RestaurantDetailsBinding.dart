import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsController.dart';
import 'package:get/get.dart';

class RestaurantDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RestaurantDetailsController>(RestaurantDetailsController());

  }
}