import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';

class SubCategoryController extends GetxController {
  TextEditingController titleController = TextEditingController();
  var showLoader = false.obs;
  //var storage = GetStorage();
  List arguments = Get.arguments;
  final formKey = GlobalKey<FormState>();

  @override
  void onReady() {
    checkArguments();
    super.onReady();
  }


  void checkArguments(){
    if(arguments.isNotEmpty){
      if(arguments.length >1){
        titleController.text = arguments[1];
      }
    }
  }



void submitBtnClick(){
  FocusManager.instance.primaryFocus?.unfocus();
  if(formKey.currentState?.validate() ?? false) {
    arguments.length == 1 ?
    createMenu() : editMenu();
  }
}


  Future<void> createMenu() async {
    try {
      showLoader.value = true;
      var param = {
        "title": titleController.text.trim()
      };
      var apiResponse = await ApiController().restaurantAddSubcategory(param);
      showLoader.value = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "added");
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }

  Future<void> editMenu() async {
    try {
      showLoader.value = true;
      var param = {
        "title": titleController.text.trim()
      };
      var apiResponse = await ApiController().restaurantUpdateSubcategory(
          param, "${arguments[2]}");
      showLoader.value = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        Get.close(2);
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


}