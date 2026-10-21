import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../services/repo/api_controller.dart';
import 'address_suggestion_model.dart';

class UserAddressController extends GetxController{
  TextEditingController searchLocation = TextEditingController();
  var suggestedList = <Suggestion>[].obs;
  var isHideIcon = true.obs;

  Future<void> getLocation(String input, String lang) async {
    try {
      var param = {
        'input': input,
        'lang': lang
      };
      var location = await ApiController().mapsAutoComplete(param);
      if (location.responseCode == AppStrings.apiSuccess) {
        suggestedList.value =  location.response?.data['data']['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();

        if(searchLocation.text.trim().isEmpty){
          suggestedList.clear();
        }
      }
    } catch (e){
      debugPrint("owner address exception $e");
    }
  }
}