import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/repo/CommonRepo.dart';
import 'SuggestionModel.dart';

class GetLocationController extends GetxController {
  TextEditingController searchLocation = TextEditingController();
  var suggestedList = <Suggestion>[].obs;
  var isHideIcon = true.obs;

  getLocation( var input , var lang) async{
    var  cancelToken = CancelToken();

      var location = await ApiController().getAutoPlaceLocation(input, lang, cancelToken);
    if (location.responseCode == 200) {
      suggestedList.value =  location.response?.data['predictions']
          .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
          .toList();

    if (location.response?.data['status'] == 'ZERO_RESULTS') {
      return [];
    }
    throw Exception(location.response?.data['error_message']);
  } else {
  throw Exception('Failed to fetch suggestion');
  }

    }
    }


