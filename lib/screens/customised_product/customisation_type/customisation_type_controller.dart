import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/commonModels/customisation_list_model.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
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

  void goBack(){
    if(itemDeleted.value){
      Get.back(result: customisationItemsList);
    } else {
      Get.back();
    }
  }


  void checkArguments(){
    var args = Get.arguments;
    customisationType.value = args["type"] ?? '';
    customisationTitle.value = args["title"] ?? '';
    if((args["list"] ?? []).isNotEmpty) {
      customisationItemsList.clear();
      customisationItemsList.value = args["list"].toList();
    } else {
      initTypeList();
    }
    initRemainingItemsList();
    initialLoad.value = false;
  }


    void initTypeList(){
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
         customisationItemsList.value = [];
         return;
    }
  }






 void deleteCustomisationItem(int index){
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.alertMsgDeleteCustomisation,
      twoButtons: true,
      onConfirm: (){removeCustomisationItem(index);},
    ));
  }

  Future<void> removeCustomisationItem(int index) async {
    if((customisationItemsList[index].id ?? '').trim().isNotEmpty){
      try {
        showLoader.value = true;
        var param = {
          'ids': customisationItemsList[index].id,
        };
        var apiResponse = await ApiController().restaurantDeleteCustomisations(
            param);
        showLoader.value = false;
        if (apiResponse.responseCode == AppStrings.apiSuccess) {
          itemDeleted.value = true;
          customisationItemsList.removeAt(index);
          customisationItemsList.refresh();
        } else {
          itemDeleted.value = false;
          CommonUtils.utils.handleAlertMsg(
              code: apiResponse.responseCode,
              message: apiResponse.msg);
        }
      } catch (e){
        itemDeleted.value = false;
        showLoader.value = false;
      }
    } else {
      customisationItemsList.removeAt(index);
      customisationItemsList.refresh();
    }
  }


  void goBackToCustomisedProductScreen(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      Get.back(result: customisationItemsList);
    }
  }



  void initRemainingItemsList(){
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


  void addRemainingItemsClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    List<String?> existingTitles = customisationItemsList.map((item) => item.title).toList();

    for (var item in addRemainingList) {
      if (!existingTitles.contains(item.title)) {
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