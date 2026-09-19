import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/update_profile/model/restaurant_user_info.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


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
      var newFileName = (imageFile.value?.path ?? '').split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }
  showLoader.value = true;
  var storage = GetStorage();
  var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    dio.FormData formData = dio.FormData.fromMap({
      "first_name": nameInputController.text,
      "id": "${ownerId["id"]}",
      "phone": phoneInputController.text,
      "email": emailInputController.text,
    "image": imageFile.value != null ?
    await dio.MultipartFile.fromFile(imageFile.value?.path ?? '', filename: newFileName)
        : null
    });

    var updateProfile = await ApiController().updateOwnerProfile(formData);
  showLoader.value = false;
  if (updateProfile.responseCode == 1) {

    Get.dialog(PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          Get.close(2);
        }
      },
      child:   showDialogBox(title: 'Profile',
        message: "Updated Successfully",
        twoButtons: false,
        onConfirm: (){Get.close(2);},
      ),
    ),
        barrierDismissible: false);
  }
  else {
    CommonUtils.utils.handleAlertMsg(
        code: updateProfile.responseCode,
        message: updateProfile.msg);
  }
}





}