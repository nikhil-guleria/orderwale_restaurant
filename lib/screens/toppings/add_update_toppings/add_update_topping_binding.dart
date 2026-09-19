import 'package:get/get.dart';
import 'add_update_topping_controller.dart';

class AddUpdateToppingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUpdateToppingController>(() => AddUpdateToppingController());
  }

}