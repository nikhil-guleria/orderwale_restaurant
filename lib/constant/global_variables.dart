import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlobalVariables {
  static Rx<String> token = Rx("");
  static var clientId = '';
  static var selectedLocation = '';
  static var restaurantLatLng =  LatLng(0.0, 0.0);
}
