import 'package:get/get.dart';
import 'dashboard_orders_controller.dart';

class DashboardOrdersBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<DashboardOrdersController>(DashboardOrdersController());
  }

}