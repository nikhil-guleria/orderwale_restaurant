
import 'package:get/get.dart';
import 'NewUserController.dart';

class NewUserBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<NewUserController>(NewUserController());
  }
}