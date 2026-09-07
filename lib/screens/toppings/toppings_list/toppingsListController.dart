import 'package:flutter/material.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'toppingsListModel.dart';

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


  getToppingsList()  async {
    var storage = GetStorage();
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var toppingsListData = await ApiController().getToppingsList(restId);
    showLoader.value = false;
    initialLoad.value = false;
      if (toppingsListData.responseCode == 1) {
        ToppingsListModel toppingsListModel = ToppingsListModel.fromJson(
            toppingsListData.response!.data);
        toppingsList.value = toppingsListModel.result!;
      }
      else {
        CommonUtils.utils.handleApiError(
            toppingsListData.responseCode, toppingsListData.msg);
      }
  }


  goToAddTopping(){
      Get.toNamed(Routes.addUpdateTopping)?.then((value) {
        if(value == "added") {
          showLoader.value = true;
          getToppingsList();
        }
      });
  }


  goToUpdateTopping(index){
    var data = Toppings();
    data.id = toppingsList[index].id;
    data.title = toppingsList[index].title;
    data.type = toppingsList[index].type;
    data.price = toppingsList[index].price;
    Get.toNamed(Routes.addUpdateTopping, arguments: data)?.then((value) {
      if(value == "updated" || value == "deleted") {
        showLoader.value = true;
        getToppingsList();
      }

    });

  }

}