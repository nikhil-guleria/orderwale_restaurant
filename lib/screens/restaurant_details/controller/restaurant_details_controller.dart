import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';
import '../model/restaurant_details_model.dart';


class RestaurantDetailsController extends GetxController  with GetSingleTickerProviderStateMixin {
  late TabController tabController ;
  var  restaurantsDetail = RestaurantDetailsModel().obs;
  var showLoader = true.obs;



  @override
  void onInit() {
    //checkId();
    restaurantDetails();
    tabController = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  onClose(){
    super.onClose();
    CommonUtils.utils.statusBarColored();
  }

/*  void checkId(){
    showLoader.value = true;
    var storage = GetStorage();
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var id = Get.arguments;
    if(id != null){
      restaurantDetails(id);
      isEdit.value = true;
    } else {
      restaurantDetails(restId);
    }
  }*/

  Future<void> restaurantDetails() async {
    try {
      showLoader.value = true;
      var restaurantDetails = await ApiController().restaurantDetailsManage();
      showLoader.value = false;
      if (restaurantDetails.responseCode == AppStrings.apiSuccess) {
        restaurantsDetail.value = RestaurantDetailsModel.fromJson(
            restaurantDetails.response?.data['result']);
      }
      else {
        if(restaurantDetails.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
           code:  restaurantDetails.responseCode,
           message:  restaurantDetails.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }
}
