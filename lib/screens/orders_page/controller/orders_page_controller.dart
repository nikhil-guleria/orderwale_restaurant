import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import '../models/orders_page_model.dart';


class OrdersPageController extends GetxController {

//var allOrders = <OrdersNew>[].obs;
//var filterList = <OrdersNew>[].obs;
//final List<String> choices = ['New Order',  'Preparing' , 'Ready' , "On The Way", 'Delivered' , 'Declined'];

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



  //var notificationVisible = false.obs;
  //var orderId = "".obs;
  //var isVisible = true.obs;
  //var storage = GetStorage();



@override
void onInit() {
  super.onInit();
  currentPage.value = 1;
  fetchList(currentPage.value);
  fetchListNew();
}



 Future<void> fetchList(int page) async {
  try {
    var storage = GetStorage();
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "restaurant_id": "$restaurantId",
      "status": selectedChoice.value,
      "per_page": 50
    };
    var ordersList = await ApiController().restaurantAllOrders(param, "$page");
    refreshLoad.value = false;
    showLoader.value = false;
    initialLoad.value = false;
    if (ordersList.responseCode == 1) {
      OrdersPageModel ordersListModel = OrdersPageModel.fromJson(ordersList.response?.data ?? {});
      if (page == 1) {
        orderList.clear();
      }
      orderList.addAll(ordersListModel.result ?? []);
      lastPage.value = ordersListModel.lastPage ?? 1;
      currentPage.value = ordersListModel.currentPage ?? 1;
    }
    else {
      if(ordersList.responseCode == 0){
        orderList.clear();
        return;
      }
        CommonUtils.utils.handleApiError(
            ordersList.responseCode, ordersList.msg);
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
   Get.toNamed(Routes.ORDER_DETAILS, arguments: orderList[index].orderId)
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









/*void showNotification(String id) {
  storage.write("order_id", id);
  storage.write("notification", true);
  knowNotificationStatus();
}

void knowNotificationStatus(){
  if(storage.read("order_id") != null) {
    orderId.value= storage.read("order_id");
  }
  if(storage.read("notification") !=null) {
    notificationVisible.value = storage.read("notification");
  }
}
 checkConnectivity({bool silently = false, int attempt = 0}) async {
    final connectionAvailable = await hasConnection();
    if (!connectionAvailable) {
      if (silently && attempt < 5) {
        await Future.delayed(const Duration(seconds: 2));
        checkConnectivity(silently: silently, attempt: attempt + 1);
        return;
      }
      showNoConnectionDialog();
    } else {

    }}

  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ;
  }


  showNoConnectionDialog() {
    Get.dialog(AlertDialog(
      backgroundColor: colorWhite,
      surfaceTintColor: colorWhite,
          title: const Text("No Internet"),
          content: const Text("Please check your internet connection"),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () async {
                Get.back();
                checkConnectivity(silently: true);
              },
            ),
          ],
        ));
  }
*/
}