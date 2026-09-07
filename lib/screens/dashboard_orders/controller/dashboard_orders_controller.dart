import 'dart:async';
import 'package:card_swiper/card_swiper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/screens/dashboard_orders/model/dashboard_orders_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';

class DashboardOrdersController extends GetxController with GetTickerProviderStateMixin{
  SwiperController swiperController1 =  SwiperController();
  SwiperController swiperController2 =  SwiperController();
  CountDownController countdownController = CountDownController();
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var newNotification = false.obs;
  var notificationOrderId = "".obs;
  var restaurantAvailability = 2.obs;
  var receivedOrder = <DashboardOrdersData>[].obs;
  var acceptedOrder = <DashboardOrdersData>[].obs;
  var storage = GetStorage();


  @override
  void onInit() {
    fetchOrdersList();
    super.onInit();
  }

Future<void> openTerminatedApp() async {
 await FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      Get.toNamed(Routes.ORDER_DETAILS, arguments: message.data["order_id"]);
    }
  }).then((value) {
   fetchOrdersList();
 });

}





  Future<void> pullRefresh() async {
    fetchOrdersList();
  }


int timeLeft(String? orderTime){
    try {
      String orderTimeString = orderTime ?? '';
      DateTime dateTime = DateTime.parse(orderTimeString);
      var currentTime = DateTime.parse(
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
      int diff = currentTime.difference(dateTime).inSeconds;
      return diff;
    } catch(e){
      return 0;
    }
}

int duration(String? orderTime){
    try {
      String orderTimeString = orderTime ?? '';
      DateTime dateTime = DateTime.parse(orderTimeString);
      var currentTime = DateTime.parse(
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
      int diff = currentTime.difference(dateTime).inSeconds;
      if (diff < 1500) {
        return 1500 - diff;
      } else {
        return 0;
      }
    } catch (e){
      return 0;
    }
}

  void goToOrderDetails(String? orderId){
    Get.toNamed(Routes.ORDER_DETAILS, arguments: orderId)
        ?.then((value) {
          if(value[1] == true){
            fetchOrdersList();
          }

    });
}


  Future<void> fetchOrdersList() async {
    showLoader.value = true;
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "restaurant_id": "$restaurantId",
    };
    var ordersList = await ApiController().restaurantDashboardOrders(param);
    showLoader.value = false;
    initialLoad.value = false;
      if (ordersList.responseCode == 1) {
        DashboardOrdersModel ordersModel = DashboardOrdersModel.fromJson(
            ordersList.response?.data ?? {});
        receivedOrder.clear();
        acceptedOrder.clear();
        restaurantAvailability.value = ordersModel.result?.isAvailable ?? 2;
        receivedOrder.value = (ordersModel.result?.orders ?? [])
            .where((item) => (item.orderStatus ?? '').trim() == "1")
            .toList();
        acceptedOrder.value =
            (ordersModel.result?.orders ?? []).where(
                    (item) => (item.orderStatus ?? '').trim() == "2" ||
                        (item.orderStatus ?? '').trim() == "4"||
                (item.orderStatus ?? '').trim() == "7").toList();
      }
      else {
        receivedOrder.clear();
        acceptedOrder.clear();
        CommonUtils.utils.handleApiError(
            ordersList.responseCode, ordersList.msg);
      }
  }


  String setItemsTotal(String? totalPrice, String? walletPrice){
    try {
      return "${((num.tryParse(totalPrice ?? "0") ?? 0) +
          (num.tryParse(walletPrice ?? "0") ?? 0))}";
    } catch (e){
      return "0";
    }
  }



  Future<void> acceptDeclineOrders(String status, String? orderId) async{
    showLoader.value = true;
    var param = {
      "order_status": status,
      "order_id": orderId
    };
    var order = await ApiController().orderOperations(param);
    showLoader.value = false;
    if (order.responseCode == 1) {
      fetchOrdersList();
    }
    else {
      CommonUtils.utils.handleApiError(order.responseCode, order.msg);
      fetchOrdersList();
    }
  }


  Future<void> changeRestaurantAvailability(bool isAvailable) async {
    var currentAvailability = isAvailable ? 1 : 0 ;
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "is_available": currentAvailability,
      "restaurant_id": "$restaurantId"
    };
    var result = await ApiController().changeRestaurantAvailability(param);
    if (result.responseCode == 1) {
      restaurantAvailability.value = isAvailable ? 1 : 0;
    }
    else {
      CommonUtils.utils.handleApiError(result.responseCode, result.msg);
    }
  }


  // decline or cancel order
 void cancelOrder(int index) {
    Get.dialog(showDialogBox(title: alert,
      message: cancelOrderDescription,
      twoButtons: true,
      cancelTxt: "No",
      confirmTxt: "Yes",
      onCancel: () {
        Get.back();
      },
      onConfirm: (){Get.back(result: "ok");},
    )).then((value) {
      if(value == "ok"){
        acceptDeclineOrders("3",receivedOrder[index].orderId);
      }
    });
  }



 void deliverOrderClick(String? orderId) {
    Get.dialog(showDialogBox(title: alert,
      message: deliverOrderDescription,
      twoButtons: true,
      cancelTxt: "No",
      confirmTxt: "Yes",
      onCancel: () {
        Get.back();
      },
      onConfirm: (){Get.back(result: "ok");},
    )).then((value) {
      if(value == "ok"){
        acceptDeclineOrders("5",orderId);
      }
    });
  }

}