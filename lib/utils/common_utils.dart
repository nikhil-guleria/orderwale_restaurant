import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/screens/dashboard/controller/dashboard_controller.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_controller.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import '../component/custom_dialog_box.dart';
import '../services/commonModels/cashfree_payment_model.dart';
import '../services/commonModels/razorpay_payment_model.dart';
import '../services/repo/api_controller.dart';


class CommonUtils {
  static final CommonUtils utils = CommonUtils._internal();

  factory CommonUtils() {
    return utils;
  }

  CommonUtils._internal();


  void changePageControllerIndex(int index){
    DashboardController  dashBoardController = Get.find();
    dashBoardController.changePage(index);
  }




  void handleAlertMsg({int? code,
    String? message, String? title}) {
    String msg = (message ?? AppStrings.errorSomethingWrong).replaceAll("_", " ");
    int responseCode = code ?? 900;
    bool?  check =  Get.isDialogOpen ?? false;
    if(!check) {
    switch (responseCode) {
      case 301:
      case 400:
      case 500:
      Get.dialog(showDialogBox(title: AppStrings.alertError,
          message: msg));
        break;

      default:
        Get.dialog(showDialogBox(title: title ?? AppStrings.alertError,
            message: msg));
    }
}
  }


  Future<void> unauthenticatedRestaurant() async {
    await StorageUtils.utils.clearSession();
    Get.offAllNamed(AppRoutes.userLogin);
  }




  void newOrderUpdate(){
    bool register = Get.isRegistered<DashboardOrdersController>();
    if(register) {
      DashboardOrdersController controller = Get.find();
      controller.onInit();
    }
  }


  Future generatePaymentOrderId({required String balance, required int gateway}) async {
    try {
      if (gateway == 0) return "Type Not Found";
      String type = gateway == 1 ? "razorpay" : "cashfree";
      double doubleBal = double.tryParse(balance) ?? 0;
      int amount = 0;
      if(gateway == 1) {
         amount = (doubleBal * 100).round();
      }
      var param = {
        "amount": gateway == 1 ? amount : doubleBal,
        "type": type,
        "currency": "INR"
      };
      var apiResponse = await ApiController().restaurantSubscriptionOrder(
          param);
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        if (type == "razorpay") {
          RazorPayResponse razorPayResponse = RazorPayResponse.fromJson(
              apiResponse.response?.data);
          return razorPayResponse;
        } else if (type == "cashfree") {
          CashFreeResponse cashFreeResponse = CashFreeResponse.fromJson(
              apiResponse.response?.data);
          return cashFreeResponse;
        } else {
          return "Type Not Found";
        }
      } else {
        return apiResponse;
      }
    } catch (e){
      return "exception-> $e";
    }

  }

  String formatIndianNumber(String? number) {

    if (number == null || number.trim().isEmpty) {
      return '';
    }

    //Remove spaces, dashes, brackets
    String cleaned = number.replaceAll(RegExp(r'[^0-9+]'), '');

    // Already starts with +91
    if (cleaned.startsWith('+91')) {

      String mobile = cleaned.substring(3);

      if (mobile.length == 10) {
        return '+91$mobile';
      }

      return cleaned;
    }


    // Starts with 91
    if (cleaned.startsWith('91') && cleaned.length == 12) {
      return '+$cleaned';
    }

    // Starts with 0
    if (cleaned.startsWith('0') && cleaned.length == 11) {

      cleaned = cleaned.substring(1);
    }


    // Plain 10 digit mobile
    if (cleaned.length == 10) {

      return '+91$cleaned';
    }


    // Invalid number
    return cleaned;
  }


  void statusBarColorTransparent(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark
    ));
  }


  void statusBarColored(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark

    ));
  }
// format numbers
  String formatNumber(num value) {
    if (value is int || value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }



  // print bill methods
  List<int> splitBillByPersonsShares(int totalAmount, int numberOfPersons) {
    if (numberOfPersons <= 0 || numberOfPersons > 10) {return [];}
    if (numberOfPersons == 1) return [totalAmount];

    // Base share for each person (integer division, rounds down)
    int baseShare = totalAmount ~/ numberOfPersons;

    // Remainder that needs to be distributed
    int remainder = totalAmount % numberOfPersons;

    List<int> shares = [];

    for (int i = 0; i < numberOfPersons; i++) {
      if (i < remainder) {
        // First `remainder` persons pay one extra rupee
        shares.add(baseShare + 1);
      } else {
        shares.add(baseShare);
      }
    }

    // ✅ Verification: shares.reduce((a, b) => a + b) == totalAmount
    return shares;
  }



  // get delivered order date time
  List<String> getDeliveredOrderDateAndTime(String? input) {
    if ((input ?? '').trim().isEmpty) {
      return ['', ''];
    }

    final parts = (input ?? '').trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

    final date = parts.isNotEmpty ? parts[0] : '';
    final time = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return [date, time];
  }



}


