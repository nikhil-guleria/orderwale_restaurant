import 'dart:async';
import 'package:card_swiper/card_swiper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/dashboard_orders/model/dashboard_orders_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';


class DashboardOrdersController extends GetxController{
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
      Get.toNamed(AppRoutes.orderDetails, arguments: message.data["order_id"]);
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
    Get.toNamed(AppRoutes.orderDetails, arguments: orderId)
        ?.then((value) {
          if(value[1] == true){
            fetchOrdersList();
          }

    });
}

  void goToOrdersList(){
    Get.toNamed(AppRoutes.ordersList)?.then((value) {
      if(value[1] == true) {
        fetchOrdersList();
      }
    });
  }


  Future<void> fetchOrdersList() async {
    try {
      showLoader.value = true;
      var ordersList = await ApiController().restaurantDashboardOrders();
      showLoader.value = false;
      initialLoad.value = false;
      if (ordersList.responseCode == AppStrings.apiSuccess) {
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
                    (item) =>
                (item.orderStatus ?? '').trim() == "2" ||
                    (item.orderStatus ?? '').trim() == "4" ||
                    (item.orderStatus ?? '').trim() == "7").toList();
      } else {
        if(ordersList.responseCode == AppStrings.unauthenticated){
         await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        receivedOrder.clear();
        acceptedOrder.clear();
        CommonUtils.utils.handleAlertMsg(
            code: ordersList.responseCode,
            message: ordersList.msg);
      }
    } catch (e){
      showLoader.value = false;
      initialLoad.value = false;
      receivedOrder.clear();
      acceptedOrder.clear();
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
    var order = await ApiController().restaurantAcceptDeclineOrder(param);
    showLoader.value = false;
    if (order.responseCode == AppStrings.apiSuccess) {
      fetchOrdersList();
    }
    else {
      CommonUtils.utils.handleAlertMsg(
        code: order.responseCode,
        message: order.msg);
      fetchOrdersList();
    }
  }


  Future<void> changeRestaurantAvailability(bool isAvailable) async {
    var currentAvailability = isAvailable ? 1 : 0 ;
    restaurantAvailability.value = isAvailable ? 1 : 0;
    var param = {
      "is_available": currentAvailability,
    };
    var result = await ApiController().restaurantChangeAvailability(param);
    if (result.responseCode == AppStrings.apiSuccess) {
      restaurantAvailability.value = isAvailable ? 1 : 0;
    }
    else {
      restaurantAvailability.value = isAvailable ? 0 : 1;
      CommonUtils.utils.handleAlertMsg(
         code: result.responseCode,
         message: result.msg);
    }
  }


  // decline or cancel order
 void cancelOrder(int index) {
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.dashboardCancelOrderDescription,
      twoButtons: true,
      cancelTxt: AppStrings.btnNo,
      confirmTxt: AppStrings.btnYes,
      onConfirm: (){acceptDeclineOrders("3",receivedOrder[index].orderId);},
    ));
  }



 void deliverOrderClick(String? orderId) {
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.dashboardDeliverOrderDescription,
      twoButtons: true,
      cancelTxt: AppStrings.btnNo,
      confirmTxt: AppStrings.btnYes,
      onConfirm: (){acceptDeclineOrders("5",orderId);},
    ));
  }

}