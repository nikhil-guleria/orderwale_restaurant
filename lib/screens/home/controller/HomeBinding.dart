import 'package:food_merchant/screens/home/controller/HomeController.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());

  }
}