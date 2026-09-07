import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../model/RestaurantDetailsModel.dart';

class DetailsController extends GetxController{
  var restaurantDetails = RestaurantDetailsModel().obs;
  DetailsController(restDetails){
    restaurantDetails.value = restDetails;
  }

  convertTime(time){
    return DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time));
  }

  extractTime(timeString){
    DateTime dateTime = DateFormat("hh:mm:ss").parse(timeString);
    String time = "${twoDigitNum(dateTime.hour)}:${twoDigitNum(dateTime.minute)}:${twoDigitNum(dateTime.second)}";
    return DateFormat("hh:mm a").format(DateFormat("hh:mm:ss").parse(time));
  }
  twoDigitNum(int num){
    if(num < 10){
      return "0${num}";
    }
    else {
      return num;
    }
  }

  calling() async {
    final url = 'tel:${restaurantDetails.value.phone}';
      await launchUrlString(url);
  }

  openGoogleMap() async{
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${restaurantDetails.value.latitude},${restaurantDetails.value.longitude}';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not launch $googleUrl';
    }
  }



  changeRestaurantAvailability(bool isAvailable) async {
    var restaurantAvailability = isAvailable ? 1 : 0 ;
    var param = {
      "is_available": restaurantAvailability,
      "restaurant_id": "${restaurantDetails.value.restaurantId}"
    };
    var result = await ApiController().changeRestaurantAvailability(param);
    if (result.responseCode == 1) {
      restaurantDetails.value.isAvailable = isAvailable ? 1 : 0;
      restaurantDetails.refresh();
      //availability(restaurantAvailability);
    }
    else {
      CommonUtils.utils.handleApiError(result.responseCode, result.msg);
    }
  }

  changeDeliveryAvailability(bool isAvailable) async {
    var deliveryAvailability = isAvailable ? 1 : 0 ;
    var param = {
      "restaurant_id": "${restaurantDetails.value.restaurantId}",
      "delivery_availability": deliveryAvailability
    };
    var result = await ApiController().changeDeliveryAvailability(param);
    if (result.responseCode == 1) {
      restaurantDetails.value.deliveryAvailability = isAvailable ? "1" : "0";
      restaurantDetails.refresh();
    }
    else {
      CommonUtils.utils.handleApiError(result.responseCode, result.msg);
    }
  }


}