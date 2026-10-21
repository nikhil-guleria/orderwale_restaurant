import 'package:get/get.dart';
import 'customisation_type_controller.dart';

class CustomisationTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomisationTypeController>(() => CustomisationTypeController());
  }
}