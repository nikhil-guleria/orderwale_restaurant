import 'package:food_merchant/screens/sub_category_title_screen/controller/sub_category_controller.dart';
import 'package:get/get.dart';

class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SubCategoryController>(SubCategoryController());
  }

}