import 'package:get/get.dart';
import 'orders_page_controller.dart';

class OrdersPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OrdersPageController>(OrdersPageController());

  }
}