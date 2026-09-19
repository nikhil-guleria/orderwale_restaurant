import 'package:get/get.dart';
import 'toppings_list_controller.dart';

class ToppingsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToppingsListController>(() => ToppingsListController());
  }
}