
import 'package:get/get.dart';
import 'UpdateProfileController.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UpdateProfileController>(UpdateProfileController());
  }
}