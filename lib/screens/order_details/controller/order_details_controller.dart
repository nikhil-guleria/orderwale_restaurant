import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_connection_service.dart';
import 'package:food_merchant/services/commonModels/cancel_reasons_model.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../constant/app_strings.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../models/order_details_model.dart';

class OrderDetailsController extends GetxController {
  var  orderDetails = RestaurantOrderData().obs;
  var showLoader = false.obs;
  var initialLoader = true.obs;
  var result = "".obs;
  var updateStatus = false.obs;
  var orderId = "";
  var cancelReasonsList = <CancelResult>[].obs;



  @override
  void onReady() {
    orderId = Get.arguments;
    getOrderDetails();
    removeValue();
    super.onReady();
  }






  void removeValue(){
    //storage.remove(GetStorageConstants.fcmOrderId);
    StorageUtils.utils.removeKey(StorageUtils.utils.fcmOrderId);
  }

  Future<void> getOrderDetails() async {
    try {
      showLoader.value = true;
      var order = await ApiController().restaurantOrderDetails(orderId);
      showLoader.value = false;
      initialLoader.value = false;
      if (order.responseCode == AppStrings.apiSuccess) {
        RestaurantOrderDetailsModel detailsModel = RestaurantOrderDetailsModel.fromJson(
            order.response?.data ?? {});
        orderDetails.value = detailsModel.result ?? RestaurantOrderData();
        result.value = orderDetails.value.orderStatus ?? '';
      } else {
        if(order.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
            code: order.responseCode,
            message: order.msg);
      }
    } catch (e){
      showLoader.value = false;
      initialLoader.value = false;
    }
  }

  Future<void> acceptDeclineOrders(String status) async{
    try {
      showLoader.value = true;
      var param = {
        "order_status": status,
        "order_id": orderId
      };
      var order = await ApiController().restaurantAcceptDeclineOrder(param);
      showLoader.value = false;
      if (order.responseCode == AppStrings.apiSuccess) {
        updateStatus.value = true;
        getOrderDetails();
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: order.responseCode,
            message: order.msg);
        getOrderDetails();
      }
    } catch (e){
      showLoader.value = false;
    }
  }

void getBack(){
    Get.back(result: [result.value,
       updateStatus.value]);
}




  Future<void> openMap() async {
    try {
      double restaurantLatitude = double.tryParse(orderDetails.value.restaurantLatitude ?? '0') ?? 0.0;
      double restaurantLongitude = double.tryParse(orderDetails.value.restaurantLongitude ?? '0') ?? 0.0;
      double destinationLatitude = double.tryParse(orderDetails.value.latitude ?? '0') ?? 0.0;
      double destinationLongitude = double.tryParse(orderDetails.value.longitude ?? '0') ?? 0.0;

      if(restaurantLatitude <= 0.0 || restaurantLongitude <= 0.0 ||
       destinationLatitude <= 0.0 || destinationLongitude <= 0.0){
        return;
      }
      String url = 'https://www.google.com/maps/dir/';

      url += '$restaurantLatitude,$restaurantLongitude/';

      url += '$destinationLatitude,$destinationLongitude';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        debugPrint('Could not open the delivery location.');
      }
    } catch(e){
      debugPrint('delivery location exception ---> $e');
    }
}


  String setItemsTotal(){
      num total = num.tryParse(orderDetails.value.totalPrice ?? "0") ?? 0;
      num wallet = num.tryParse(orderDetails.value.walletPrice ?? "0") ?? 0;
      if((total + wallet) > 0){
        return "${total + wallet}";
      }
      return "${total + wallet} (No Charge)";
  }



  String roundOffAmountOrder(String? roundOffString){
    String roundOff = roundOffString?.trim() ?? '';

    if (roundOff.isEmpty) return "";

    // Remove spaces around minus sign: "- 0.1" → "-0.1"
    roundOff = roundOff.replaceAll(RegExp(r'-\s+'), '-');

    double value = double.tryParse(roundOff) ?? 0;

    if (value == 0) return "";

    String symbol = AppStrings.currSymbolIn;

    if (value < 0) {
      return "- $symbol${value.abs()}";
    } else {
      return "+ $symbol$value";
    }
  }



  Future<void> calling() async {
    final url = 'tel:${orderDetails.value.phone}';
    await launchUrlString(url);
  }





 void cancelOrder() {
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: cancelOrderDescription,
      twoButtons: true,
      cancelTxt: AppStrings.btnNo,
      confirmTxt: AppStrings.btnYes,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){Get.back(result: "ok");},
    )).then((value) {
      if(value == "ok"){
        acceptDeclineOrders("3");
      }
    } );
  }



  void deliverOrderClick() {
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: deliverOrderDescription,
      twoButtons: true,
      cancelTxt: AppStrings.btnNo,
      confirmTxt: AppStrings.btnYes,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){Get.back(result: "ok");},
    )).then((value) {
      if(value == "ok"){
        acceptDeclineOrders("5");
      }
    });
  }



  Future<void> printOrderBill() {
    final adminChargeDelivery = double.tryParse(orderDetails.value.adminCharge ?? "0") ?? 0;
    final deliveryChargeAdmin = double.tryParse(orderDetails.value.deliveryCharge ?? "0") ?? 0;
    final deliveryCharge = adminChargeDelivery > 0 ? adminChargeDelivery : deliveryChargeAdmin;


    double total = double.tryParse(orderDetails.value.totalPrice ?? "0") ?? 0;
    double wallet = double.tryParse(orderDetails.value.walletPrice ?? "0") ?? 0;
    double totalPrice = total + wallet;

    return PrinterConnectionService.instance.printRestaurantOrderBill(
        order: orderDetails.value,
        gst: double.tryParse(orderDetails.value.gst ?? '0') ?? 0,
        gstLabel: (orderDetails.value.appliedTaxes ?? '').trim().isEmpty ?
        AppStrings.orderDetailsGstCharges : (orderDetails.value.appliedTaxes ?? ''),
        packagingCharges: double.tryParse(orderDetails.value.packagingCharges ?? '0') ?? 0,
        deliveryCharges: deliveryCharge,
        discountPrice: double.tryParse(orderDetails.value.discountPrice ?? '0') ?? 0,
        totalPrice: totalPrice,
        roundOff: roundOffAmountOrder(orderDetails.value.roundOff),
        paymentType: int.tryParse(orderDetails.value.paymentType ?? '25') ?? 25,
    );
  }





  List<RestaurantOrderItemsData> expandedKot(){
    final kots = orderDetails.value.kots ?? [];
    if (kots.isEmpty) {
      return [];
    }

    // Collect all items from all KOTs
    List<RestaurantOrderItemsData> allItems = kots
        .expand((kot) => kot.items ?? <RestaurantOrderItemsData>[])
        .toList();
    return allItems;
  }




  /// -------------------------------------------------------------
  /// -------------------- currently not in use -------------------
  /// -------------------------------------------------------------
  // fetch cancel reasons list
  Future<void> fetchCancelReasonsList() async {
    var cancelResponse = await ApiController().getCancelReasons();
    if(cancelResponse.responseCode == 1){
      CancelReasonsModel cancelReasonsModel = CancelReasonsModel.fromJson(cancelResponse.response?.data);
      cancelReasonsList.value = cancelReasonsModel.result ?? [];
    }
  }



  void changeCancelReason(int index, bool val) {
    for (var reason in cancelReasonsList) {
      reason.selected = false;
    }
    cancelReasonsList[index].selected = val;
  }


  Future<void> submitCancelReason() async {
    bool selected = cancelReasonsList.any((item) => item.selected == true);
    if(selected){
      showLoader.value = true;
      var selectedItem = cancelReasonsList.firstWhere(
            (item) => item.selected == true,
      );
      var param = {
        "reason_id": selectedItem.reasonId,
        "order_id": orderId
      };
      var response = await ApiController().cancelOrderWithReason(param);
      showLoader.value = false;
      if (response.responseCode == 1) {
        updateStatus.value = true;
        getOrderDetails();
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: response.responseCode,
            message: response.msg);
        getOrderDetails();
      }
    } else {
      Get.snackbar(AppStrings.alertError, snackBarMsgCancelReason);
    }
  }




  }


