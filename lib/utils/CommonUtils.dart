import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/screens/dashboard/controller/dashboard_controller.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_controller.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';
import 'dart:ui' as ui;
import '../component/DialogBox.dart';
import '../services/commonModels/cashfree_payment_model.dart';
import '../services/commonModels/razorpay_payment_model.dart';
import '../services/repo/CommonRepo.dart';


class CommonUtils {
  static final CommonUtils utils = CommonUtils._internal();
  static var userToken = "";

  factory CommonUtils() {
    return utils;
  }

  CommonUtils._internal();


  void changePageControllerIndex(int index){
    DashboardController  dashBoardController = Get.find();
    dashBoardController.changePage(index);
  }




  void handleApiError(int code,String message, {String? title}) {
    bool?  check =  Get.isDialogOpen ?? false;
    if(!check) {
      switch (code) {
        case 301:
        case 400:
        case 500:
        Get.dialog(showDialogBox(title: error,
            message: message,
            twoButtons: false,
            onConfirm: () {
              Get.back();
            }));
        break;
        default:
          Get.dialog(showDialogBox(title: title ?? error,
              message: message,
              twoButtons: false,
              onConfirm: () {
                Get.back();
              }));
      }
    }
  }




  bool haveImage(String path) {
    final mimeType = lookupMimeType(path);
    if (mimeType!.startsWith('image/')) {
      return true;
    }
    else {
      return false;
    }
  }

  void newOrderUpdate(){
    bool register = Get.isRegistered<DashboardOrdersController>();
    if(register) {
      DashboardOrdersController controller = Get.find();
      controller.onInit();
    }
  }


  generatePaymentOrderId({required double amount, required String type}) async {
    var storage = GetStorage();
    String? restId =  storage.read(GetStorageConstants.RESTAURANT_ID);
    var ownerPhone =  storage.read(GetStorageConstants.LOGIN_DATA);
    String? restName =  storage.read(GetStorageConstants.REST_NAME);
    var param = {
      "order_amount": amount,
      "type": type,
      "order_currency": "INR",
      "customer_id": restId ?? "NA",
      "customer_phone": "${ownerPhone["phone"]}",
      "customer_name": restName ?? "NA"
    };
    var apiResponse = await ApiController().createPaymentOrderId(param);
    if(apiResponse.responseCode == 200) {
      if(type == "razorpay"){
        RazorPayResponse razorPayResponse = RazorPayResponse.fromJson(apiResponse.response!.data);
        return razorPayResponse;
      } else if(type == "cashfree") {
        CashFreeResponse cashFreeResponse = CashFreeResponse.fromJson(
            apiResponse.response!.data);
        return cashFreeResponse;
      } else {
        return "Type Not Found";
      }
    } else {
      return apiResponse;
    }

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

  bool isMobile(){
    bool isPhone;
    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isPhone = false;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isPhone = false;
    }
    else {
      isPhone = true;
    }

    return isPhone;
  }


