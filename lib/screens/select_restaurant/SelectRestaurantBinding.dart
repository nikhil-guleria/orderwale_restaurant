
import 'package:get/get.dart';
import 'SelectRestaurantController.dart';

class SelectRestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SelectRestaurantController>(SelectRestaurantController());
  }
}