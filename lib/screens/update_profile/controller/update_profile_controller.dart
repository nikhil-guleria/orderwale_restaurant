import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/update_profile/model/restaurant_user_info.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';


class UpdateProfileController extends GetxController{
  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();


  var showLoader = false.obs;
  var initialLoad = true.obs;
  final formKey = GlobalKey<FormState>();
  Rxn<File> imageFile = Rxn<File>();
  var  profileDetails = RestaurantUserInfo().obs;


  @override
  void onReady(){
    getProfileDetails();
    super.onReady();
  }





  Future<void> getProfileDetails() async {
    try {
      showLoader.value = true;
      var ownerProfile = await ApiController().restaurantUserInfo();
      showLoader.value = false;
      if (ownerProfile.responseCode == AppStrings.apiSuccess) {
        initialLoad.value = false;
        profileDetails.value =
            RestaurantUserInfo.fromJson(ownerProfile.response?.data);
        nameInputController.text = profileDetails.value.name ?? '';
        phoneInputController.text = profileDetails.value.restaurantPhone ?? '';
        emailInputController.text = profileDetails.value.email ?? '';
        restaurantNameController.text = profileDetails.value.restaurantName ?? '';
      }
      else {
        if(ownerProfile.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
           code: ownerProfile.responseCode,
            message: ownerProfile.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


  Future<void> pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var path = await ImgPickerDialogBox.pickCroppedImagePath();
    if (path != null) {
      File original = File(path);
      File? compressed = await CustomImgPicker.compressTo1MB(original);
      if (compressed != null) {
        imageFile.value = compressed;
      }
    }
  }


  void checkValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      if (nameInputController.text.trim() != (profileDetails.value.name ?? '').trim() ||
          imageFile.value != null) {
        updateProfile();
      }
    }
  }


Future<void> updateProfile() async{
    /*  var newFileName = (imageFile.value?.path ?? '').split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }*/
  try {
    showLoader.value = true;
    var param = {
      "name": nameInputController.text.trim(),
    };
    var updateProfile = await ApiController().restaurantUpdateUserName(param);
    showLoader.value = false;
    if (updateProfile.responseCode == AppStrings.apiSuccess) {
      CommonUtils.utils.handleAlertMsg(
          title: AppStrings.alertSuccess,
          message: updateProfile.msg);
    } else {
      CommonUtils.utils.handleAlertMsg(
          code: updateProfile.responseCode,
          message: updateProfile.msg);
    }
  } catch (e){
    showLoader.value = false;
  }
}





}