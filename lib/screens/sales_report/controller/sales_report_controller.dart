import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/screens/sales_report/model/SalesReportModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constant/string_constants.dart';
import '../../../services/api/ApiConstant.dart';
import '../../../services/api/ApiHitter.dart';
import '../../../services/commonModels/cashfree_payment_model.dart';
import '../../../services/commonModels/razorpay_payment_model.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/DateTimeUtils.dart';
import '../../../utils/GetStorageConstants.dart';

class SalesReportController extends GetxController{
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var selectDate = DateTime.now().obs;
  var currentDate = DateTime.now();
  var salesReport = Report().obs;

  var yOffset = 0.0.obs;
  var xOffset = 0.0.obs;
  var pageScale = 1.0.obs;


  late Razorpay _razorpay;
  late CFEnvironment _cfEnvironment;
  late CFPaymentGatewayService _cfPaymentGatewayService;
  var paymentOptionValue = 1.obs;
  var orderId = "".obs;
  var sessionPaymentId = "".obs;
  var verifyCount = 0.obs;
  var paymentLoader = false.obs;
  var isCashFree = false.obs;

  @override
  void onInit() {
    getRestaurantSalesReport();
    super.onInit();
  }





  String currentMonth(){
    DateTime currentDate = DateTime.now();
    return DateFormat('MMMM').format(currentDate);
  }



  void changeDate(int days) {
    selectDate.value = selectDate.value.add(Duration(days: days));
    getRestaurantSalesReport();
  }

  String showDate(DateTime dateTime){
    if(DateTimeUtils.utils.isCurrentDay(DateFormat('dd MMM, yyyy').format(dateTime))) {
     return "Today - ${DateFormat('dd MMM').format(dateTime)}";
    }
    else {
      return  "${DateFormat('EEE').format(dateTime)} - ${DateFormat('dd MMM').format(dateTime)}";
    }
  }

  String salesOverviewDate(DateTime dateTime){
    if(DateTimeUtils.utils.isCurrentDay(DateFormat('dd MMM, yyyy').format(dateTime))) {
      return "Today";
    }
    else {
      var month = DateFormat('MMM').format(dateTime);
      return "${dateTime.day}${dateSuffix(dateTime.day)} $month.";
    }
  }
  String salesOverviewMonth(DateTime dateTime){
      return "${DateFormat('MMM').format(dateTime)}. Month";
  }



  String dateSuffix(int day){
    if ((day >= 11 && day <= 13) || (day % 10 > 3 && day % 10 <= 9)) {
      return 'th';
    } else {
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }
  }




  double truncateToDecimals(double value, int fractionalDigits) {
    final num mod = pow(10, fractionalDigits);
    return (value * mod).truncateToDouble() / mod;
  }



  String formatAmount(double amount) {
    if (amount >= 10000000) {
      double cr = amount / 10000000;
      double truncated = truncateToDecimals(cr, 1);
      return '$truncated cr';
    } else if (amount >= 100000) {
      double lakh = amount / 100000;
      double truncated = truncateToDecimals(lakh, 1);
      return '$truncated lakh';
    } else if (amount >= 1000) {
      double thousand = amount / 1000;
      double truncated = truncateToDecimals(thousand, 1);
      return '${truncated}K';
    } else {
      return "$amount";
    }
  }

  String formatOrders(double orders) {
    if (orders >= 1000 && orders < 100000) {
      double thousands = orders / 1000;
      return '${thousands.toStringAsFixed(0)}K';
    } else if (orders >= 100000) {
      double lakhs = orders / 100000;
      return '${lakhs.toStringAsFixed(0)} lakh';
    } else {
      return orders.toStringAsFixed(0);
    }
  }

  String formatAmountWithComma(double amount) {
    if (amount >= 1000 && amount < 10000) {
      String newAmount =  NumberFormat("#,###").format(amount);
      return newAmount;
    } else if (amount >= 10000 && amount < 100000) {
      String newAmount =  NumberFormat("##,###").format(amount);
      return newAmount;
    } else if (amount >= 100000 && amount < 1000000){
      String newAmount =  NumberFormat("#,##,###").format(amount);
      return newAmount;
    } else if (amount >= 1000000 && amount < 10000000){
      String newAmount =  NumberFormat("##,##,###").format(amount);
      return newAmount;
    } else {
      return "${amount.toStringAsFixed(0)} ";
    }
  }


  String previousBalance(String balance){
    double bal = double.parse(balance);
    if(bal < -50){
      return bal.toString().substring(1);
    } else {
      return "0";
    }
  }

  String requestedBalance(String balance){
    double bal = double.parse(balance);
    if(bal > 50){
      return "$bal";
    } else {
      return "0";
    }
  }






  Future<void> datePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectDate.value,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      selectDate.value = pickedDate;
      getRestaurantSalesReport();
    }
  }
String changeDateParam(DateTime dateTime){
   return DateFormat('dd-MM-yyyy').format(dateTime) ;
}

  Future<void> getRestaurantSalesReport() async {
    showLoader.value = true;
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "owner_id": "${ownerId["id"]}",
      "restaurant_id" : restaurantId,
      "date": changeDateParam(selectDate.value)
    };

    var restaurantReport = await ApiController().getRestaurantSalesReport(param);
    showLoader.value = false;
    if (restaurantReport.responseCode == 1) {
      initialLoad.value = false;
      SalesReportModel salesReportModel = SalesReportModel.fromJson(restaurantReport.response!.data);
      salesReport.value = salesReportModel.report!;
       yOffset.value = -165.0;
       xOffset.value = 70.0;
       pageScale.value = 0.8;
      animateContainer();


    }
    else {
      CommonUtils.utils.handleApiError(restaurantReport.responseCode, restaurantReport.msg);
    }
  }
  
  void animateContainer(){
    Future.delayed(const Duration(milliseconds: 150), (){
      yOffset.value = 0.0;
      xOffset.value = 0.0;
      pageScale.value = 1.0;
    });
  }



  Future<void> updateRemainingBalance() async {
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "platform": "mobile",
      "gateway":  "${salesReport.value.paymentGateWay}",
      "user_id":  "${ownerId["id"]}",
      "amount":   previousBalance(salesReport.value.balance ?? "0"),
      "restaurant_id": "$restaurantId"
    };
    var apiResponse = await ApiController().clearRemainingBalance(param);
      paymentLoader.value = false;
    if(apiResponse.responseCode == 1) {
      getRestaurantSalesReport();
    } else {
      CommonUtils.utils.handleApiError(apiResponse.responseCode, apiResponse.msg);
    }
  }

  Future<void> requestApiClick() async{
    showLoader.value = true;
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "user_id":  "${ownerId["id"]}",
      "amount":   requestedBalance(salesReport.value.balance!),
      "restaurant_id": "$restaurantId"
    };
    var apiResponse = await ApiController().requestForBalance(param);
    if(apiResponse.responseCode == 1) {
      getRestaurantSalesReport();
      Get.dialog(showDialogBox(title: success,
          message: salesReportRequestSuccess,
          twoButtons: false,
          onConfirm: () {
            Get.back();
          }));
    } else {
      showLoader.value = false;
      CommonUtils.utils.handleApiError(apiResponse.responseCode, apiResponse.msg);
    }
  }


  //####################### Payment Methods ######################



  void checkForCashFree(){
    if(salesReport.value.paymentGateWay != 0) {
      if(salesReport.value.paymentGateWay == 1){
        initializePaymentHandlers();
      }  else {
        !isCashFree.value  ? isCashFree.value = true
            :  initializePaymentHandlers();
      }
    }
  }


  void initializePaymentHandlers(){
    _razorpay = Razorpay();
    _cfEnvironment = ApiConstant.cfEnvironment;
    _cfPaymentGatewayService = CFPaymentGatewayService();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _cfPaymentGatewayService.setCallback(verifyPayment, onError);
    generatePaymentOrderId();
  }

  // generate payment order id
  Future<void> generatePaymentOrderId() async {
    paymentLoader.value = true;
      dynamic result;
      result = salesReport.value.paymentGateWay == 1 ?
      await   CommonUtils.utils.generatePaymentOrderId(amount: (double.parse(previousBalance(salesReport.value.balance!)) * 100),
          type: "razorpay")
        : await CommonUtils.utils.generatePaymentOrderId(amount: double.parse(previousBalance(salesReport.value.balance!)),
    type: "cashfree");

    if(result is ApiResponse) {
      paymentLoader.value = false;
    CommonUtils.utils.handleApiError(result.responseCode, result.msg);
    } else if (result is RazorPayResponse) {
    setUpRaZorPay(result.data!.id!);
    } else if(result is CashFreeResponse) {
    orderId.value = result.data!.orderId!;
    sessionPaymentId.value = result.data!.paymentSessionId!;
    setUpCashFree();
    } else {
      paymentLoader.value = false;
      CommonUtils.utils.handleApiError(400, "Server not responding. Please try later");
    }

  }


  // razor pay handler methods
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    updateRemainingBalance();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentLoader.value = false;
    CommonUtils.utils.handleApiError(400, "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    updateRemainingBalance();
  }

  Future<void> setUpRaZorPay(String id) async {
    var storage = GetStorage();
    var ownerPhone =  storage.read(GetStorageConstants.LOGIN_DATA);
    String? restName =  storage.read(GetStorageConstants.REST_NAME);
    var options = {
      'key': ApiConstant.razorPayId,
      'order_id' : id,
      'amount': (double.parse(previousBalance(salesReport.value.balance!)) * 100),
      'name': appName,
      'description': restName ?? "",
      'prefill': {'contact':  "${ownerPhone["phone"]}"},
      'config': {
        'display': {
          'blocks': {
            'upi': {
              'name': 'Pay via UPI',
              'instruments': [
                {
                  'method': 'upi',
                }
              ],
            },
            'other': {
              'name': 'Card & More',
              'instruments': [
                {
                  'method': 'card',
                },
                {
                  'method': 'netbanking'
                }
              ],
            },
          },
          'sequence': ['block.upi', 'block.other'],
          'preferences': {
            'show_default_blocks': false,
          },

        },
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("$e");
    }
  }






  // cash free handler methods


  void verifyPayment(String orderId) {
    debugPrint("Verify Payment");
    checkPaymentVerify();
  }

  void  checkPaymentVerify() async {
    var param = {
      "order_id": orderId.value
    };
    var apiResponse = await ApiController().verifyPaymentOrderId(param);
    if(apiResponse.responseCode == 200) {

      if(apiResponse.response?.data["data"]["order_status"] == "PAID"){
        updateRemainingBalance();
      } else {
        paymentLoader.value = false;
        CommonUtils.utils.handleApiError(400, "Payment Not Done");
      }

    } else {
      paymentLoader.value = false;
      verifyCount.value > 0 ? null
          : Get.dialog(showDialogBox(
        title: error,
        message:  verifyCount.value == 0 ?
        "Server not responding. Please try again"
        : "When your payment is successfully processed, the balance will be updated",
        twoButtons: false,
        confirmTxt: "RETRY",
        onConfirm: (){
          Get.back(result: "retry");
        },
      ), barrierDismissible: false).then((value) {
        if(value == "retry") {
          verifyCount.value = verifyCount.value + 1;
          checkPaymentVerify();
        }
      });
    }


  }



  void onError(CFErrorResponse errorResponse, String orderId) {
    paymentLoader.value = false;
    CommonUtils.utils.handleApiError(400, errorResponse.getMessage().toString());
  }


  void setUpCashFree(){
    if(paymentOptionValue.value == 1) {
      upiPay();
    } else if (paymentOptionValue.value == 2) {
      cardPayNew();
    } else if(paymentOptionValue.value ==3) {
      netBankingPay();
    } else {
      paymentLoader.value = false;
      CommonUtils.utils.handleApiError(400, "Something went wrong. Please try later");
    }
  }


  CFSession? createSession() {
    try {
      var oid = orderId.value;
      var spi = sessionPaymentId.value;
      var session = CFSessionBuilder().setEnvironment(_cfEnvironment).setOrderId(oid).setPaymentSessionId(spi).build();
      return session;
    } on CFException catch (e) {
      CommonUtils.utils.handleApiError(400, e.message);
    }
    return null;
  }


  Future<void> upiPay() async {
    try {
      var sessionNew = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FCAD03").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(sessionNew!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      _cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      debugPrint(e.message);
      paymentLoader.value = false;
    }

  }

  void cardPayNew(){
    try {
      var sessionNew = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.CARD);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FCAD03").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(sessionNew!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      _cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      paymentLoader.value = false;
      debugPrint(e.message);
    }
  }

  Future<void> netBankingPay() async {
    try {
      var sessionNew = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.NETBANKING);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FCAD03").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(sessionNew!).setPaymentComponent(paymentComponent).setTheme(theme).build();
      _cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      paymentLoader.value = false;
      debugPrint(e.message);
    }
  }


}