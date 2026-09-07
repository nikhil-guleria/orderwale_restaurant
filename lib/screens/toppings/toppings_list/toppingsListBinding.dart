import 'package:get/get.dart';
import 'toppingsListController.dart';

class ToppingsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ToppingsListController>(ToppingsListController());
  }
}