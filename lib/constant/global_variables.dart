import 'package:food_merchant/services/commonModels/countries_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlobalVariables {
  static Rx<String> deviceToken = Rx("");
  static var selectedLocation = '';
  static var restaurantLatLng =  LatLng(0.0, 0.0);


  static List<CountryData> ddCountriesList = [
    CountryData(name: "India", countryId: "1")
  ];
}
