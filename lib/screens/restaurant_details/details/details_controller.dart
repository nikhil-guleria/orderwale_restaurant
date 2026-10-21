import 'package:flutter/cupertino.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';

class DetailsController extends GetxController{
  var deliveryAvailability = ''.obs;



  String extractTime(String? timeString){
    try {
      String givenString = (timeString ?? '').trim();
      if(givenString.isEmpty) return '';
      DateTime dateTime = DateFormat("hh:mm:ss").parse(givenString);
      String time = "${twoDigitNum(dateTime.hour)}:${twoDigitNum(
          dateTime.minute)}:${twoDigitNum(dateTime.second)}";
      return DateFormat("hh:mm a").format(DateFormat("hh:mm:ss").parse(time));
    } catch (e){
      return '';
    }
  }



  String twoDigitNum(int num){
    if(num < 10){
      return "0$num";
    }
    else {
      return "$num";
    }
  }



  Future<void> openGoogleMap(String latitude, String longitude) async{
    try {
      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl));
      }
    } catch (e){
      debugPrint("google map exception -> $e");
    }
  }



  Future<void> changeDeliveryAvailability(bool isAvailable) async {
    var currentAvailability = isAvailable ? 1 : 0 ;
    deliveryAvailability.value = isAvailable ? '1' : '0';
    var param = {
      "delivery_availability": currentAvailability,
    };
    var result = await ApiController().restaurantChangeDeliveryAvailability(param);
    if (result.responseCode == AppStrings.apiSuccess) {
      deliveryAvailability.value = isAvailable ? '1' : '0';
    }
    else {
      deliveryAvailability.value = isAvailable ? '0' : '1';
      CommonUtils.utils.handleAlertMsg(
          code: result.responseCode,
          message: result.msg);
    }
  }



}