import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/screens/login/model_login/login_model.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constant/global_variables.dart';
import '../../../constant/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/PushNotifications.dart';

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



  // forgot password click
  void forgotPasswordClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.forgotPassword);
  }


  // create account click
  void createAccountClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.registerNewUser);
  }


  // user login with email and password
  Future<void> loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      if (GlobalVariables.deviceToken.value.trim().isEmpty) {
        await PushNotificationService.fetchFCMToken();
        if (GlobalVariables.deviceToken.value.trim().isNotEmpty) {
          loginRestaurantUser();
        } else {
          CommonUtils.utils.handleAlertMsg(
              message: AppStrings.alertMsgSomethingWentWrong);
          return;
        }
      } else {
        loginRestaurantUser();
      }
    }
  }




  Future<void> loginRestaurantUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      showLoader.value = true;
      var param = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "device_type": Platform.isIOS ? 'ios' : 'android',
        "device_token": GlobalVariables.deviceToken.value
      };
      var loginResponse = await ApiController().restaurantUserAppLogin(param);
      showLoader.value = false;
      if (loginResponse.responseCode == AppStrings.apiSuccess) {
        emailController.clear();
        passwordController.clear();
        RestaurantUserLoginModel loginResult =
        RestaurantUserLoginModel.fromJson(loginResponse.response?.data ?? {});
        await StorageUtils.utils.saveSession(
          restaurantUserToken: loginResult.token,
          restaurantUserName: loginResult.user?.name,
          userRole: loginResult.user?.role
        );
        Get.offAllNamed(AppRoutes.tabBar);
      } else {
        CommonUtils.utils.handleAlertMsg(
            message: loginResponse.msg,
            code: loginResponse.responseCode,
        );
      }
    } catch (e){
      showLoader.value = false;
      debugPrint('login exception --$e');
    }
  }





/* Future<void> hitApi() async {
    try {
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
        LoginModel userData = LoginModel.fromJson(
            userModel.response?.data['result'] ?? {});
        storage.write(GetStorageConstants.LOGIN_DATA, userData.toJson());
        storage.write(GetStorageConstants.IS_LOGGED, true);

        var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
        var param2 = {
          "owner_id": "${ownerId["id"]}",
        };
        var restaurantData = await ApiController().getRestaurantList(param2);
        showLoader.value = false;
        if (restaurantData.responseCode == 1) {
          RestaurantListModel restaurantList = RestaurantListModel.fromJson(
              restaurantData.response?.data ?? {});
          storage.write(GetStorageConstants.RESTAURANTS_COUNT,
              (restaurantList.result ?? []).length);
          if ((restaurantList.result ?? []).isEmpty) {
            Get.offAll(() => const NoRestaurant());
          }
          else if ((restaurantList.result ?? []).length == 1) {
            storage.write(GetStorageConstants.RESTAURANT_SELECTED, true);
            storage.write(
                GetStorageConstants.RESTAURANT_ID, restaurantList.result?[0].id);
            storage.write(
                GetStorageConstants.REST_NAME, restaurantList.result?[0].name);
            LatLng latLng = LatLng(
                double.tryParse(restaurantList.result?[0].latitude ?? '0') ?? 0.0,
                double.tryParse(restaurantList.result?[0].longitude ?? '0') ??
                    0.0);
            storage.write(GetStorageConstants.RESTAURANT_LATLNG, latLng);
            Get.offAllNamed(AppRoutes.DASHBOARD);
          }
          else {
            Get.offAllNamed(
                AppRoutes.SELECT_RESTAURANT, arguments: restaurantList.result);
          }
        }
        else {
          CommonUtils.utils.handleAlertMsg(userModel.responseCode, userModel.msg);
        }
      } else {
        showLoader.value = false;
        CommonUtils.utils.handleAlertMsg(userModel.responseCode, userModel.msg);
      }
    } catch (_){

    }
  }*/
}



