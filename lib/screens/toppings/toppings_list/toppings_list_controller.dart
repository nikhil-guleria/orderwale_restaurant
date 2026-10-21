import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';
import 'toppings_list_model.dart';


class ToppingsListController extends GetxController {
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var toppingsList = <Toppings>[].obs;






  @override
  void onReady() {
    super.onReady();
    getToppingsList();
  }



 Future<void> pullToRefresh() async {
    showLoader.value = true;
    getToppingsList();
  }


  Future<void> getToppingsList()  async {
    try {
      var toppingsListData = await ApiController().restaurantToppingsList();
      showLoader.value = false;
      initialLoad.value = false;
      if (toppingsListData.responseCode == AppStrings.apiSuccess) {
        ToppingsListModel toppingsListModel = ToppingsListModel.fromJson(
            toppingsListData.response?.data);
        toppingsList.value = toppingsListModel.result ?? [];
      }
      else {
        if(toppingsListData.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
           code:  toppingsListData.responseCode,
           message: toppingsListData.msg);
      }
    } catch (e){
      showLoader.value = false;
      initialLoad.value = false;
      debugPrint("toppings exception--> $e");
    }
  }


  void goToAddTopping(){
      Get.toNamed(AppRoutes.addUpdateTopping)?.then((value) {
        if(value == "added") {
          showLoader.value = true;
          getToppingsList();
        }
      });
  }


  void goToUpdateTopping(int index){
    var data = Toppings();
    data.id = toppingsList[index].id;
    data.title = toppingsList[index].title;
    data.type = toppingsList[index].type;
    data.price = toppingsList[index].price;
    Get.toNamed(AppRoutes.addUpdateTopping, arguments: data)?.then((value) {
      if(value == "updated" || value == "deleted") {
        showLoader.value = true;
        getToppingsList();
      }
    });

  }

}