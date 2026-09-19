import 'package:flutter/material.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../model/restaurant_details_model.dart';

class RestaurantDetailsController extends GetxController  with GetSingleTickerProviderStateMixin {
  late TabController tabController ;
  var  restaurantsDetail = RestaurantDetailsModel().obs;
  var showLoader = false.obs;
  var isEdit = false.obs;
  ScrollController scrollController =  ScrollController();



  @override
  void onInit() {
    checkId();
    tabController = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  onClose(){
    super.onClose();
    CommonUtils.utils.statusBarColored();
  }

  checkId(){
    showLoader.value = true;
    var storage = GetStorage();
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var id = Get.arguments;
    if(id != null){
      restaurantDetails(id);
      isEdit.value = true;
    }
    else {
      restaurantDetails(restId);
    }
  }

  restaurantDetails(String restaurantId) async {
      var restaurantDetails = await ApiController().getRestaurantDetails(restaurantId);
    showLoader.value = false;
    if (restaurantDetails.responseCode == 1) {
      restaurantsDetail.value = RestaurantDetailsModel.fromJson(restaurantDetails.response!.data['result']);
    }
    else {
      CommonUtils.utils.handleApiError(restaurantDetails.responseCode, restaurantDetails.msg);
    }
  }
}
