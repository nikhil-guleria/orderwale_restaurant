import 'package:get/get.dart';
import 'add_customised_product_controller.dart';

class AddCustomisedProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCustomisedProductController>(() => AddCustomisedProductController());
  }
}