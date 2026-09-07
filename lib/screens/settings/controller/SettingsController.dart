import 'package:flutter/material.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../constant/string_constants.dart';
import '../../../routes/app_pages.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import '../../../utils/PushNotifications.dart';


class SettingsController extends GetxController {
  var showLoader = false.obs;
 var  hideSettings = true.obs;
  var showChangeRest = false.obs;
var storage = GetStorage();
  var passwordVisible = true.obs;
  final focusPassword = FocusNode();
  TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    checkChangeRestaurantVisibility();
    biometricAuthentication();
    super.onInit();
  }


  Future<void> biometricAuthentication() async {
     bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
     if(canAuthenticateWithBiometrics) {
       final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
       if (availableBiometrics.isNotEmpty) {
         bool isAuthenticated = await auth.authenticate(
             localizedReason: "Authenticate using biometrics",
             biometricOnly: true,
             persistAcrossBackgrounding: true,
            );
         if (isAuthenticated) {
           hideSettings.value = false;
         }
       }
     }
  }



  void logOut() {
  Get.dialog(showDialogBox(title: settings_logout,
    message: settings_logout_dialog_middle_text,
    twoButtons: true,
    onCancel: () {
      Get.back();
    },
    onConfirm: (){Get.back(result: "ok");},
  )).then((value) {
    if(value == "ok"){
      logOutOwner();
    }
  } );
}

Future<void> logOutOwner() async {
   showLoader.value = true;
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {"user_id": restId,
      "device_token": GlobalVariables.token.value};
    var apiResponse = await  ApiController().logOutOwner(param);
    showLoader.value = false;
    if(apiResponse.responseCode == 1){
      processLogout();
    } else {
      CommonUtils.utils.handleApiError(apiResponse.responseCode, apiResponse.msg);
    }
}



void processLogout(){
  storage.remove(GetStorageConstants.LOGIN_DATA);
  storage.remove(GetStorageConstants.IS_LOGGED);
  storage.remove(GetStorageConstants.RESTAURANT_ID);
  storage.remove(GetStorageConstants.REST_NAME);
  storage.remove(GetStorageConstants.RESTAURANT_SELECTED);
  storage.remove(GetStorageConstants.RESTAURANTS_COUNT);
  storage.remove(GetStorageConstants.GLOBAL_ID);
  storage.remove(GetStorageConstants.RESTAURANT_LATLNG);
  Get.offAllNamed(Routes.USER_LOGIN);
}

  Future<void> checkValidations() async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      if(GlobalVariables.token.value == ""){
        await PushNotificationService.fetchFCMToken();
        if(GlobalVariables.token.value != "") {
          hitApi();
        } else {
          Get.dialog(showDialogBox(title: alert,
            message: "Something went wrong. Please try later",
            twoButtons: false,
            onCancel: () {
              Get.back();
            },
            onConfirm: (){ Get.back();},
            ));
        }
      } else {
        hitApi();
      }
    }
  }

  void checkChangeRestaurantVisibility(){
    var count = storage.read(GetStorageConstants.RESTAURANTS_COUNT);
    if(count < 2 || count == null) {
      showChangeRest.value = false;
    } else {
      showChangeRest.value = true;
    }
  }


  Future<void> hitApi() async {
    var storage = GetStorage();
    var emailId = storage.read(GetStorageConstants.LOGIN_DATA);

    var param = {
      "email": "${emailId["email"]}",
      "password": passwordController.text,
      //"device_token": GlobalVariables.token.value
    };

    showLoader.value = true;
    var login = await ApiController().loginUser(param);
    showLoader.value = false;
    if (login.responseCode == 1) {
      hideSettings.value = false;
    }
    else {
      CommonUtils.utils.handleApiError(login.responseCode, login.msg);
    }
  }


}