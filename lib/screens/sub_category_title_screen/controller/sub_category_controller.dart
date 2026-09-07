import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';

class SubCategoryController extends GetxController {
  TextEditingController titleController = TextEditingController();
  var showLoader = false.obs;
  var storage = GetStorage();
  List arguments = Get.arguments;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    checkArguments();
    super.onInit();
  }


  checkArguments(){
    if(arguments.isNotEmpty){
      if(arguments.length >1){
        titleController.text = arguments[1];
      }
    }
  }



submitBtnClick(){
  FocusManager.instance.primaryFocus?.unfocus();
  if(formKey.currentState!.validate()) {
    arguments.length == 1 ?
    createMenu() : editMenu();
  }
}


  createMenu() async {
      showLoader.value = true;
      var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
      var param = {
        "restaurant_id": restId,
        //"category_id": "${arguments[0]}",
        "title": titleController.text
      };

      var apiResponse = await ApiController().addSubCategory(param);
      showLoader.value = false;
      if(apiResponse.responseCode == 1){
       Get.back(result: "added");
      }else {
        CommonUtils.utils.handleApiError(
            apiResponse.responseCode, apiResponse.msg);
    }
  }

  editMenu() async {
      showLoader.value = true;
      var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
      var param = {
        "restaurant_id": restId,
        //"category_id": "${arguments[0]}",
        "title": titleController.text
      };


      var apiResponse = await ApiController().editSubCategory(param, "${arguments[2]}");
      showLoader.value = false;
      if(apiResponse.responseCode == 1){
      Get.close(2);
      }else {
        CommonUtils.utils.handleApiError(
            apiResponse.responseCode, apiResponse.msg);
      }
  }


}