import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';

class AddUpdateToppingController extends GetxController {
  var argument = Get.arguments;
  var showLoader = false.obs;
  var initialLoad = true.obs;
  final formKey = GlobalKey<FormState>();
  var foodType = "".obs;
  var updateTopping = false.obs;
  var toppingId = "".obs;
  var showFoodError = false.obs;
  

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  @override
  void onReady() {
    super.onReady();
    checkArguments();
  }


  void checkArguments() {
    if(argument != null){
      updateTopping.value = true;
      titleController.text = argument.title ?? '';
      priceController.text = "${argument.price ?? 0}";
      foodType.value = checkToppingType("${argument.type}");
      toppingId.value = "${argument.id}";
      initialLoad.value = false;
    }
    else {
      updateTopping.value = false;
      initialLoad.value = false;
    }
  }

  String checkToppingType(String type){
    switch (type){
      case "veg":
        return "1";
      case "non-veg":
        return "2";
      default :
        return type;
    }
  }




  void onChangeFoodType(String? type) {
    if(type != null){
    foodType.value = type;}
  }


  void addUpdateClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    foodType.value.trim().isEmpty ?
    showFoodError.value = true : showFoodError.value = false;
    if((formKey.currentState?.validate() ?? false) && foodType.value.trim().isNotEmpty) {
       updateTopping.value ? updateToppingProcess()
      : addToppingProcess();
    }
  }


  Future<void> addToppingProcess() async {
    try {
      showLoader.value = true;
      var param = {
        "title": titleController.text.trim(),
        "type": foodType.value.trim(),
        "price": priceController.text.trim()
      };
      var addToppingResponse = await ApiController().restaurantAddTopping(param);
      showLoader.value = false;
      if (addToppingResponse.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "added");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
           code: addToppingResponse.responseCode,
           message: addToppingResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }




  Future<void> updateToppingProcess() async {
    try {
      showLoader.value = true;
      var param = {
        "title": titleController.text,
        "type": foodType.value,
        "price": priceController.text
      };
      var updateToppingResponse = await ApiController().restaurantUpdateTopping(
          param, toppingId.value);
      showLoader.value = false;
      if (updateToppingResponse.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "updated");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: updateToppingResponse.responseCode,
            message: updateToppingResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


 void deleteToppingClick(){
      Get.dialog(showDialogBox(title: AppStrings.alertTitle,
        message: AppStrings.alertMsgDeleteTopping,
        twoButtons: true,
        onConfirm: (){deleteToppingProcess();}));
  }

  Future<void> deleteToppingProcess() async {
    try {
      showLoader.value = true;
      var deleteTopping = await ApiController().restaurantDeleteTopping(
          toppingId.value);
      showLoader.value = false;
      if (deleteTopping.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "deleted");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: deleteTopping.responseCode,
            message: deleteTopping.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }

}