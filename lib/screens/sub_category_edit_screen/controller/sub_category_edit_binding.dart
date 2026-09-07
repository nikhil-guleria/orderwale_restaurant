import 'package:food_merchant/screens/sub_category_edit_screen/controller/sub_category_edit_controller.dart';
import 'package:get/get.dart';

class SubCategoryEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SubCategoryEditController>(SubCategoryEditController());
  }

}