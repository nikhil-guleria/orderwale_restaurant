import 'package:flutter/material.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/help_and_support/models/help_and_support_model.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class HelpAndSupportController extends GetxController{
  var showLoader = false.obs;
  var imgLoader = false.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var images = <HelpSupportImageModel>[].obs;



  void resetData(){
    phoneController.clear();
    descriptionController.clear();
    images.clear();
    images.refresh();
  }


  Future<void> uploadImgClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (images.length >= 3) {
      CommonUtils.utils.handleAlertMsg(
        message: AppStrings.alertMsgHelpAndSupport,
        title: AppStrings.alertTitle,
      );
      return;
    }

    final imgData = await ImgPickerDialogBox.pickCroppedImageFile();
    if (imgData != null) {
      imgLoader.value = true;
      final compressedImg = await CustomImgPicker.compressImageFromBytesTo1MB(await imgData.readAsBytes());
      if (compressedImg != null) {
        images.add(HelpSupportImageModel(
            imageBytes: compressedImg, filePath: imgData.path));
        images.refresh();
      }
      imgLoader.value = false;
    }
  }


  void removeImage(int index) {
    images.removeAt(index);
    images.refresh();
  }


  void submitClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false){
      helpSupportApi();
    }
  }


  Future<void> helpSupportApi() async {
    try {
      showLoader.value = true;
      List<dio.MultipartFile> imageFiles = [];
      for (var img in images) {
        if (img.imageBytes != null) {
          final multipartFile = await CustomImgPicker.multipartImageFromBytes(img.filePath, img.imageBytes!);
          if (multipartFile != null) {
            imageFiles.add(multipartFile);
          }
        }
      }

      final formData = dio.FormData.fromMap({
        'phone': phoneController.text.trim(),
        'description': descriptionController.text.trim(),
        'images[]': imageFiles,
      });

      var apiResponse = await ApiController().restaurantHelpAndSupport(formData);
      showLoader.value  = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        resetData();
          CommonUtils.utils.handleAlertMsg(
              message: apiResponse.msg,
              title: AppStrings.alertSuccess
          );
      } else {
        if(apiResponse.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        } else {
          CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg,
          );
        }
      }
    } catch (e) {
      showLoader.value  = false;
      debugPrint("exception submit help & support $e");
    }
  }


}