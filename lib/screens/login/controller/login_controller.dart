import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/screens/login/model_login/login_model.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../component/DialogBox.dart';
import '../../../constant/global_variables.dart';
import '../../../constant/string_constants.dart';
import '../../../routes/app_pages.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/PushNotifications.dart';
import '../../home/home_model/RestaurantListModel.dart';
import '../../no_restaurant/NoRestaurant.dart';

class LoginController extends GetxController {
  var isLoggedIn = true.obs;
  var showLoader = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusPassword = FocusNode();
  final focusEmailPassword = FocusNode();
  final storage = GetStorage();
  var visiblePassword = true.obs;
  final formKey = GlobalKey<FormState>();


  // user login with email and password
  Future<void> loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      if (GlobalVariables.token.value.trim().isEmpty) {
        await PushNotificationService.fetchFCMToken();
        if (GlobalVariables.token.value.trim().isNotEmpty) {
          hitApi();
        } else {
          Get.dialog(showDialogBox(title: alert,
              message: "Something went wrong. Please try later",
              twoButtons: false,
              onCancel: () {
                Get.back();
              },
              onConfirm: () {
                Get.back();
              }));
          return;
        }
      } else {
        hitApi();
      }
    }
  }




Future<void> hitApi() async {
  var param = {
    "email": emailController.text,
    "password": passwordController.text,
    "device_type": Platform.isIOS ? 'ios' : 'android',
    "device_token": GlobalVariables.token.value
  };
  showLoader.value = true;
  FocusManager.instance.primaryFocus?.unfocus();
  var userModel = await ApiController().loginUser(param);
  if (userModel.responseCode == 1) {
    LoginModel userData = LoginModel.fromJson(userModel.response?.data['result'] ?? {});
    storage.write(GetStorageConstants.LOGIN_DATA, userData.toJson());
    storage.write(GetStorageConstants.IS_LOGGED, true);

    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var param2 = {
      "owner_id": "${ownerId["id"]}",
    };
    var restaurantData = await ApiController().getRestaurantList(param2);
    showLoader.value = false;
    if (restaurantData.responseCode == 1) {
      RestaurantListModel restaurantList = RestaurantListModel.fromJson(restaurantData.response?.data ?? {});
      storage.write(GetStorageConstants.RESTAURANTS_COUNT, (restaurantList.result ?? []).length);
      if((restaurantList.result ?? []).isEmpty){
        Get.offAll(()=> const NoRestaurant());
      }
      else if ((restaurantList.result ?? []).length == 1) {
        storage.write(GetStorageConstants.RESTAURANT_SELECTED, true);
        storage.write(GetStorageConstants.RESTAURANT_ID, restaurantList.result?[0].id);
        storage.write(GetStorageConstants.REST_NAME, restaurantList.result?[0].name);
        LatLng latLng = LatLng(double.tryParse(restaurantList.result?[0].latitude ?? '0') ?? 0.0,
            double.tryParse(restaurantList.result?[0].longitude ?? '0') ?? 0.0);
        storage.write(GetStorageConstants.RESTAURANT_LATLNG, latLng);
        Get.offAllNamed(Routes.DASHBOARD);
      }
      else {
        Get.offAllNamed(Routes.SELECT_RESTAURANT, arguments: restaurantList.result);
      }
    }
    else {
      CommonUtils.utils.handleApiError(userModel.responseCode, userModel.msg);
    }
  }else {
    showLoader.value = false;
    CommonUtils.utils.handleApiError(userModel.responseCode, userModel.msg);
  }
}
}



