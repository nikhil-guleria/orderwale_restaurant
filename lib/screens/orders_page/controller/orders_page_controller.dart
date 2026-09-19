import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../models/orders_page_model.dart';


class OrdersPageController extends GetxController {
ScrollController scrollController = ScrollController();
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var refreshLoad = false.obs;
  var orderList = <OrdersPageData>[].obs;
  var lastPage = 1.obs;
  var currentPage = 1.obs;
  final List<String> choicesStatus = ['1','2','7','4','5','3'];
  final RxString selectedChoice = "1".obs;
  var colorChange  = "1".obs;
  var updateStatus = false.obs;



@override
void onInit() {
  super.onInit();
  currentPage.value = 1;
  fetchList(currentPage.value);
  fetchListNew();
}



 Future<void> fetchList(int page) async {
  try {
    final param = {
      "status": selectedChoice.value.trim(),
      "per_page":50
    };
    var ordersList = await ApiController().restaurantOrdersPage(param, page);
    refreshLoad.value = false;
    showLoader.value = false;
    initialLoad.value = false;
    if (ordersList.responseCode == AppStrings.apiSuccess) {
      OrdersPageModel ordersListModel = OrdersPageModel.fromJson(ordersList.response?.data ?? {});
      if (page == 1) {
        orderList.clear();
      }
      orderList.addAll(ordersListModel.result ?? []);
      lastPage.value = ordersListModel.lastPage ?? 1;
      currentPage.value = ordersListModel.currentPage ?? 1;
    }
    else {
      if(ordersList.responseCode == AppStrings.unauthenticated){
        await CommonUtils.utils.unauthenticatedRestaurant();
        return;
      }
      if(ordersList.responseCode == 0){
        orderList.clear();
        return;
      }
        CommonUtils.utils.handleAlertMsg(
            code: ordersList.responseCode,
            message: ordersList.msg);
    }
  } catch (e){
    refreshLoad.value = false;
    showLoader.value = false;
    initialLoad.value = false;
    orderList.clear();
  }
 }


void fetchListNew(){
  scrollController.addListener(() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (showLoader.value == false) {
        if (currentPage.value < lastPage.value) {
          showLoader.value = true;
          fetchList(currentPage.value + 1);
        }
      }
    }
  });
}

Future<void> pullRefresh() async {
  refreshLoad.value = true;
  currentPage.value = 1;
  lastPage.value = 1;
  fetchList(currentPage.value);
}


String setItemsTotal(String? totalPrice, String? walletPrice){
  try {
    return "${((num.tryParse(totalPrice ?? "0") ?? 0) +
        (num.tryParse(walletPrice ?? "0") ?? 0))}";
  } catch (e) {
    return "0";
  }
}

String getChipsTitle(String status){
  switch(status.trim()){
    case "1": return "New Order";
    case "2": return "Preparing";
    case "3": return "Declined";
    case "4": return "On The Way";
    case "5": return "Delivered";
    case "7": return "Ready";
    default: return "N/A";
  }
}

void changeChipsClick(String choice){
  colorChange.value = choice;
  selectedChoice.value = choice;
  orderList.clear();
  pullRefresh();
}


 void goToOrderDetails(int index){
   Get.toNamed(AppRoutes.orderDetails, arguments: orderList[index].orderId)
       ?.then((value) {
     orderList[index].orderStatus = value[0];
     orderList.refresh();
     updateStatus.value = value[1];
   });
 }

  void getBack(){
    Get.back(result: ["0",
      updateStatus.value]);
  }
}