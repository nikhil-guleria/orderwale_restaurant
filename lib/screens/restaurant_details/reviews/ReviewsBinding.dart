import 'package:get/get.dart';
import 'ReviewsController.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReviewsController>(ReviewsController());

  }
}