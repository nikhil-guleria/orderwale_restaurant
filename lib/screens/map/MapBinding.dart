import 'package:food_merchant/screens/map/MapController.dart';
import 'package:get/get.dart';


class MapViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MapController>(
      MapController(),
    );
  }
}