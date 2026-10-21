import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:get/get.dart';
import '../../../constant/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';


class SettingsController extends GetxController {
  var showLoader = false.obs;
  /* var hideSettings = true.obs;
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
  }*/






  void logOut() {
  Get.dialog(showDialogBox(title: AppStrings.settingsLogoutHeading,
    message: AppStrings.alertMsgLogout,
    twoButtons: true,
    onConfirm: (){logOutOwner();},
  ));
}

Future<void> logOutOwner() async {
    try {
      showLoader.value = true;
      var apiResponse = await ApiController().restaurantUserLogout();
      showLoader.value = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        await CommonUtils.utils.unauthenticatedRestaurant();
      } else {
        CommonUtils.utils.handleAlertMsg(
           code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
}



  void profileSettingsClick(){
    Get.toNamed(AppRoutes.updateProfile);
  }

  void salesReportClick(){
    Get.toNamed(AppRoutes.salesReport);
  }

  void manageRestaurantClick(){
    Get.toNamed(AppRoutes.manageRestaurant);
  }

  void deliveryAreaClick(){
    Get.toNamed(AppRoutes.deliveryArea);
  }

  void toppingsClick(){
    Get.toNamed(AppRoutes.toppingsList);
  }

  void couponsClick(){
    Get.toNamed(AppRoutes.couponsList);
  }

  void changePasswordClick(){
    Get.toNamed(AppRoutes.changePassword);
  }

  void printerSettingsClick(){
    Get.toNamed(AppRoutes.printerSettings);
  }

  void helpAndSupportClick(){
    Get.toNamed(AppRoutes.helpAndSupport);
  }



// unused methods

/*

void processLogout(){
  storage.remove(GetStorageConstants.LOGIN_DATA);
  storage.remove(GetStorageConstants.IS_LOGGED);
  storage.remove(GetStorageConstants.RESTAURANT_ID);
  storage.remove(GetStorageConstants.REST_NAME);
  storage.remove(GetStorageConstants.RESTAURANT_SELECTED);
  storage.remove(GetStorageConstants.RESTAURANTS_COUNT);
  storage.remove(GetStorageConstants.GLOBAL_ID);
  storage.remove(GetStorageConstants.RESTAURANT_LATLNG);
  Get.offAllNamed(AppRoutes.userLogin);
}

Future<void> checkValidations() async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      if(GlobalVariables.deviceToken.value == ""){
        await PushNotificationService.fetchFCMToken();
        if(GlobalVariables.deviceToken.value != "") {
          hitApi();
        } else {
          Get.dialog(showDialogBox(title: AppStrings.alertTitle,
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
    if(count == null || count < 2) {
      showChangeRest.value = false;
    } else {
      showChangeRest.value = true;
    }
  }

  Future<void> hitApi() async {
    var emailId = storage.read(GetStorageConstants.LOGIN_DATA);

    var param = {
      "email": "${emailId["email"]}",
      "password": passwordController.text,
    };

    showLoader.value = true;
    var login = await ApiController().loginUser(param);
    showLoader.value = false;
    if (login.responseCode == 1) {
      hideSettings.value = false;
    }
    else {
      CommonUtils.utils.handleAlertMsg(
          code: login.responseCode,
          message: login.msg);
    }
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
  }*/
}