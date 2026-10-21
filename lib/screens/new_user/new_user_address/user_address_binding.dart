import 'package:get/get.dart';
import 'user_address_controller.dart';

class UserAddressBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<UserAddressController>(() => UserAddressController());
  }
}