import 'package:flutter/material.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_connection_service.dart';
import 'package:food_merchant/services/commonModels/cancel_reasons_model.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../constant/string_constants.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../models/order_details_model.dart';

class OrderDetailsController extends GetxController {
  var  orderDetails = OrderDetailsData().obs;
var storage = GetStorage();
  var showLoader = false.obs;
  var result = "".obs;
  var updateStatus = false.obs;
  var orderId = "";
  var cancelReasonsList = <CancelResult>[].obs;



  @override
  void onInit() {
    orderId = Get.arguments;
    getOrderDetails();
    removeValue();
    super.onInit();
  }






  void removeValue(){
    storage.remove(GetStorageConstants.fcmOrderId);
  }

  Future<void> getOrderDetails() async {
    showLoader.value = true;
    var order = await ApiController().getOrderDetails(orderId);
    showLoader.value = false;
    if (order.responseCode == 1) {
      OrderDetailsModel detailsModel = OrderDetailsModel.fromJson(order.response?.data ?? {});
      orderDetails.value = detailsModel.result ?? OrderDetailsData();
     result.value = orderDetails.value.orderStatus ?? '';
    }
    else {
      CommonUtils.utils.handleApiError(order.responseCode, order.msg);
    }
  }

  Future<void> acceptDeclineOrders(String status) async{
    showLoader.value = true;
    var param = {
      "order_status": status,
      "order_id": orderId
    };
    var order = await ApiController().orderOperations(param);
    showLoader.value = false;
    if (order.responseCode == 1) {
      updateStatus.value = true;
     getOrderDetails();
    }
    else {
      CommonUtils.utils.handleApiError(order.responseCode, order.msg);
      getOrderDetails();
    }
  }

void getBack(){
    Get.back(result: [result.value,
       updateStatus.value]);
}




  Future<void> openMap() async {
    LatLng latLng = const LatLng(0.0, 0.0);
    try {
      latLng = storage.read(GetStorageConstants.RESTAURANT_LATLNG);
    } catch(e){
      var list = storage.read(GetStorageConstants.RESTAURANT_LATLNG);
      latLng = LatLng(list[0], list[1]);
    }

       debugPrint("$latLng");

      double destinationLatitude = double.parse(orderDetails.value.latitude!);
      double destinationLongitude =  double.parse(orderDetails.value.longitude!);



      double sourceLatitude = latLng.latitude;
      double sourceLongitude = latLng.longitude;



      String url = 'https://www.google.com/maps/dir/';

        url += '$sourceLatitude,$sourceLongitude/';

      url += '$destinationLatitude,$destinationLongitude';


    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not open the map.');
    }
    }


  String setItemsTotal(){
    if((orderDetails.value.products ?? []).isNotEmpty) {
      return "${((num.tryParse(orderDetails.value.totalPrice ?? "0") ?? 0) +
          (num.tryParse(orderDetails.value.walletPrice ?? "0") ?? 0))}";
    }
    return "0";
  }



  String roundOffAmountOrder(String? roundOffString){
    String roundOff = roundOffString?.trim() ?? '';

    if (roundOff.isEmpty) return "";

    // Remove spaces around minus sign: "- 0.1" → "-0.1"
    roundOff = roundOff.replaceAll(RegExp(r'-\s+'), '-');

    double value = double.tryParse(roundOff) ?? 0;

    if (value == 0) return "";

    String symbol = currSymbolIn;

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
        acceptDeclineOrders("3");
      }
    } );
  }



  void deliverOrderClick() {
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
        orderGstCharges : (orderDetails.value.appliedTaxes ?? ''),
        packagingCharges: double.tryParse(orderDetails.value.packagingCharges ?? '0') ?? 0,
        deliveryCharges: deliveryCharge,
        discountPrice: double.tryParse(orderDetails.value.discountPrice ?? '0') ?? 0,
        totalPrice: totalPrice,
        roundOff: roundOffAmountOrder(orderDetails.value.roundOff),
        paymentType: int.tryParse(orderDetails.value.paymentType ?? '25') ?? 25,
    );
  }









  /// -------------------------------------------------------------
  /// -------------------- currently not in use -------------------
  /// -------------------------------------------------------------

  String calculateItemsPrice(List<Products> itemList) {
    num discountedPrice = 0;
    for (var list in itemList) {
      discountedPrice += num.tryParse(list.productPrice ?? "0") ?? 0;
    }
    return CommonUtils.utils.formatNumber(discountedPrice);
  }


  double calculateGrandTotalWallet(){
    double itemsTotal = double.tryParse(calculateItemsPrice(orderDetails.value.products ?? [])) ?? 0;
    double deliveryCharge = double.tryParse(orderDetails.value.adminCharge ?? "0") ?? 0;
    double tip = double.tryParse(orderDetails.value.tipPrice ?? "0") ?? 0;
    double  discountedPrice = double.tryParse(orderDetails.value.discountPrice ?? "0") ?? 0;
    double platformFees = double.tryParse(orderDetails.value.platformFee ?? "0") ?? 0;
    double packagingCharges = double.tryParse(orderDetails.value.packagingCharges ?? "0") ?? 0;
    double gstCharges = double.tryParse(orderDetails.value.gst ?? "0") ?? 0;
    return (itemsTotal + deliveryCharge + tip + platformFees + packagingCharges +  gstCharges - discountedPrice);

  }

  String roundOffAmount(){
    double totalAmount = double.tryParse(calculateGrandTotalWallet().toStringAsFixed(2)) ?? 0;
    double roundOff = double.tryParse((totalAmount - totalAmount.floor()).toStringAsFixed(2)) ?? 0;
    if(roundOff > 0.00) {
      if(roundOff < 0.50){
        return "- $currSymbolIn$roundOff";
      } else {
        return "$currSymbolIn${(1 - roundOff).toStringAsFixed(2)}";
      }
    } else {
      return "";
    }
  }

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
        CommonUtils.utils.handleApiError(response.responseCode, response.msg);
        getOrderDetails();
      }
    } else {
      Get.snackbar(error, snackBarMsgCancelReason);
    }
  }




  }


