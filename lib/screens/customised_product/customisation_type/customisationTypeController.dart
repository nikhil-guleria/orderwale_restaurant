import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/commonModels/customisation_list_model.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';

class CustomisationTypeController extends GetxController {
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var itemDeleted = false.obs;
  final formKey = GlobalKey<FormState>();

  var customisationType = "Portion".obs;
  var customisationTitle = "Portion".obs;
  var customisationItemsList = <CustomisationItemModel>[].obs;
  var addRemainingList = <CustomisationItemModel>[].obs;



  @override
  void onReady() {
    checkArguments();
    super.onReady();
  }

  goBack(){
    if(itemDeleted.value){
      print("go back with list");
      Get.back(result: customisationItemsList);
    } else {
      print("go back");
      Get.back();
    }
  }


  checkArguments(){
    var args = Get.arguments;
    customisationType.value = args["type"];
    customisationTitle.value = args["title"];
    if(args["list"].isNotEmpty) {
      customisationItemsList.clear();
      customisationItemsList.value = args["list"].toList();
    } else {
      initTypeList();
    }
    initRemainingItemsList();
    initialLoad.value = false;
  }


  initTypeList(){
    customisationItemsList.clear();
    switch (customisationType.value) {
      case 'Portion':
        return portionCustomisationList(customisationItemsList);
      case 'Weight':
        return weightCustomisationList(customisationItemsList);
      case 'Size':
        return sizeCustomisationList(customisationItemsList);
      case 'Pieces':
        return piecesCustomisationList(customisationItemsList);
      default:
        return customisationItemsList.value = [];
    }
  }



 void  changeCustomisationType(value){
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: "If you change the type, previous list will be deleted",
      twoButtons: true,
      onCancel: () {
        customisationType.value = customisationType.value;
        Get.back();
      },
      onConfirm: (){ Get.back(result: "delete");},
    )).then((value) {
      if(value == "delete"){
        customisationType.value = value;
        initTypeList();
      }
    });
  }


 void deleteCustomisationItem(index){
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: "Are you really want to delete this.",
      twoButtons: true,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){ Get.back(result: "delete");},
    )).then((value) {
      if(value == "delete"){
        removeCustomisationItem(index);
      }
    });
  }

  removeCustomisationItem(index) async {
    if(customisationItemsList[index].id != ""){
      showLoader.value = true;
      var  param = {
        'ids': customisationItemsList[index].id,
      };
      var apiResponse = await ApiController().deleteCustomisations(param);
      showLoader.value = false;
      if (apiResponse.responseCode == 1) {
        itemDeleted.value = true;
        customisationItemsList.removeAt(index);
        customisationItemsList.refresh();

        print("remaing list == ${addRemainingList.length}, custom list == ${customisationItemsList.length}");
      } else {
        itemDeleted.value = false;
        CommonUtils.utils.handleApiError(
            apiResponse.responseCode, apiResponse.msg);
      }
    } else {
      customisationItemsList.removeAt(index);
      customisationItemsList.refresh();
    }
  }


  goBackToCustomisedProductScreen(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      Get.back(result: customisationItemsList);
    }
  }



  initRemainingItemsList(){
    addRemainingList.clear();
    switch (customisationType.value) {
      case 'Portion':
        portionCustomisationList(addRemainingList);
        break;
      case 'Weight':
        weightCustomisationList(addRemainingList);
        break;
      case 'Size':
        sizeCustomisationList(addRemainingList);
        break;
      case 'Pieces':
        piecesCustomisationList(addRemainingList);
        break;
      default:
        addRemainingList.addAll(customisationItemsList);
    }
  }


  addRemainingItemsClick(){

    List<String?> existingTitles = customisationItemsList.map((item) => item.title).toList();

    for (var item in addRemainingList) {
      if (!existingTitles.contains(item.title)) {
        //customisationItemsList.add(item);
        customisationItemsList.add(
          CustomisationItemModel(
            id: "",
            title: item.title,
            price: item.price,
            itemId: item.itemId,
            type: item.type,
          ),
        );
        customisationItemsList.refresh();
      }
    }
  }



}