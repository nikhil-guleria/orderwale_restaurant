import 'package:flutter/material.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddUpdateToppingController extends GetxController {
  var argument = Get.arguments;
  var showLoader = false.obs;
  var initialLoad = true.obs;
  final formKey = GlobalKey<FormState>();
  var foodType = "".obs;
  var storage = GetStorage();
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


  checkArguments() {
    if(argument != null){
      updateTopping.value = true;
      titleController.text = argument.title;
      priceController.text = "${argument.price}";
      foodType.value = checkToppingType("${argument.type}");
      toppingId.value = "${argument.id}";
      initialLoad.value = false;
    }
    else {
      updateTopping.value = false;
      initialLoad.value = false;
    }
  }

  checkToppingType(String type){
    switch (type){
      case "veg":
        return "1";
      case "non-veg":
        return "2";
      default :
        return type;
    }
  }




  onChangeFoodType(String type) {
    foodType.value = type;
  }


  addUpdateClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    foodType.value.isEmpty ? showFoodError.value = true : showFoodError.value = false;
    if(formKey.currentState!.validate() && foodType.value.isNotEmpty) {
       updateTopping.value ? updateToppingProcess()
      : addToppingProcess();
    }
  }


  addToppingProcess() async {
    showLoader.value = true;
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "restaurant_id": "$restaurantId",
      "title": titleController.text,
      "type": foodType.value,
      "price": priceController.text
    };
    var addToppingResponse = await ApiController().addTopping(param);
   showLoader.value = false;
    if (addToppingResponse.responseCode == 1) {
      Get.back(result: "added");
    }
    else {
      CommonUtils.utils.handleApiError(
          addToppingResponse.responseCode, addToppingResponse.msg);
    }
  }


  updateToppingProcess() async {
    showLoader.value = true;
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "restaurant_id": "$restaurantId",
      "title": titleController.text,
      "type": foodType.value,
      "price": priceController.text
    };
    var updateToppingResponse = await ApiController().updateTopping(param, toppingId.value);
    showLoader.value = false;
    if (updateToppingResponse.responseCode == 1) {
      Get.back(result: "updated");
    }
    else {
      CommonUtils.utils.handleApiError(
          updateToppingResponse.responseCode, updateToppingResponse.msg);
    }
  }


 void deleteToppingClick(){
      Get.dialog(showDialogBox(title: alert,
        message: "Are you really want to delete this topping.",
        twoButtons: true,
        onCancel: () {
          Get.back();
        },
        onConfirm: (){ Get.back(result: "delete");},
      )).then((value) {
        if(value == "delete"){
          deleteToppingProcess();
        }
      });
  }

  deleteToppingProcess() async {
    showLoader.value = true;
    var deleteTopping = await  ApiController().deleteTopping(toppingId.value);
    showLoader.value = false;
    if(deleteTopping.responseCode == 1) {
      Get.back(result: "deleted");
    }
    else {
      CommonUtils.utils.handleApiError(
          deleteTopping.responseCode, deleteTopping.msg);
    }
  }

}