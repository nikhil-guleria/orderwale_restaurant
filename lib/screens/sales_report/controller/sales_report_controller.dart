import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/screens/sales_report/model/sales_report_model.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constant/app_strings.dart';
import '../../../services/api/api_hitter.dart';
import '../../../services/commonModels/cashfree_payment_model.dart';
import '../../../services/commonModels/razorpay_payment_model.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/date_time_utils.dart';

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


/*  String previousBalance(String balance){
    double bal = double.tryParse(balance) ?? 0;
    if(bal < -50){
      return bal.toString().substring(1);
    } else {
      return "0";
    }
  }
  String clearBalance(String? bal){
    String balance = (bal ?? '').trim().isEmpty ? "0" : bal ?? '0';

    // Remove spaces around minus sign: "- 0.1" → "-0.1"
    balance = balance.replaceAll(RegExp(r'-\s+'), '-');

    double value = double.tryParse(balance) ?? 0;

    if (value == 0) return "0";

    if (value < 0) {
      return "${value.abs()}";
    } else {
      return "0";
    }
  }

  String requestedBalance(String balance){
    double bal = double.tryParse(balance) ?? 0;
    if(bal > 50){
      return "$bal";
    } else {
      return "0";
    }
  }*/



  double _parseBalance(String? bal) {
    String balance = (bal ?? '').trim();
    if (balance.isEmpty) return 0;
    // "- 0.1" -> "-0.1"
    balance = balance.replaceAll(RegExp(r'-\s+'), '-');

    return double.tryParse(balance) ?? 0;
  }

  String previousBalance(String? balance) {
    final value = _parseBalance(balance);
    return value < -50 ? value.abs().toString() : "0";
  }

  String requestedBalance(String? balance) {
    final value = _parseBalance(balance);
    return value > 50 ? value.toString() : "0";
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
    var param = {
      "date": changeDateParam(selectDate.value)
    };

    var restaurantReport = await ApiController().restaurantSalesReport(param);
    showLoader.value = false;
    if (restaurantReport.responseCode == AppStrings.apiSuccess) {
      initialLoad.value = false;
      SalesReportModel salesReportModel = SalesReportModel.fromJson(restaurantReport.response!.data);
      salesReport.value = salesReportModel.report!;
       yOffset.value = -165.0;
       xOffset.value = 70.0;
       pageScale.value = 0.8;
      animateContainer();
    }
    else {
      if(restaurantReport.responseCode == AppStrings.unauthenticated){
        await CommonUtils.utils.unauthenticatedRestaurant();
        return;
      }
      CommonUtils.utils.handleAlertMsg(
         code:  restaurantReport.responseCode,
         message:  restaurantReport.msg);
    }
  }
  
  void animateContainer(){
    Future.delayed(const Duration(milliseconds: 150), (){
      yOffset.value = 0.0;
      xOffset.value = 0.0;
      pageScale.value = 1.0;
    });
  }



  Future<void> updateRemainingBalance({PaymentSuccessResponse? razorpayResponse}) async {
   try {
     var param = {
       "platform": "mobile",
       "gateway": razorpayResponse != null ?
       "R-${razorpayResponse.paymentId}" : "C-${sessionPaymentId.value}",
       "amount": previousBalance(salesReport.value.balance),
       "payment_order": razorpayResponse != null ?
       razorpayResponse.orderId : orderId.value
     };
     var apiResponse = await ApiController().restaurantClearBalance(param);
     paymentLoader.value = false;
     if (apiResponse.responseCode == AppStrings.apiSuccess) {
       getRestaurantSalesReport();
     } else {
       CommonUtils.utils.handleAlertMsg(
           code: apiResponse.responseCode,
           message: AppStrings.errorPaymentDeducted);
     }
   } catch (e) {
     paymentLoader.value = false;
     CommonUtils.utils.handleAlertMsg(
         message: AppStrings.errorPaymentDeducted);
   }
  }

  Future<void> requestApiClick() async{
    try {
      showLoader.value = true;
      var param = {
        "amount": requestedBalance(salesReport.value.balance ?? '0'),
      };
      var apiResponse = await ApiController().restaurantWithdrawalRequest(
          param);
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        getRestaurantSalesReport();
        CommonUtils.utils.handleAlertMsg(
          title: AppStrings.alertSuccess,
          message: AppStrings.salesReportRequestSuccess,);
      } else {
        showLoader.value = false;
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


  //####################### Payment Methods ######################



  void payNowBtnClick(){
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
    _cfEnvironment = kReleaseMode ?
    CFEnvironment.PRODUCTION : CFEnvironment.SANDBOX;
    _cfPaymentGatewayService = CFPaymentGatewayService();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _cfPaymentGatewayService.setCallback(verifyPayment, onError);
    generatePaymentOrderId();
  }

  // generate payment order id
  Future<void> generatePaymentOrderId() async {
    try {
      paymentLoader.value = true;
      dynamic result = await CommonUtils.utils.generatePaymentOrderId(
          balance: previousBalance(salesReport.value.balance),
          gateway: salesReport.value.paymentGateWay ?? 0);
      if (result is ApiResponse) {
        paymentLoader.value = false;
        CommonUtils.utils.handleAlertMsg(
            code: result.responseCode,
            message: result.msg);
      } else if (result is RazorPayResponse) {
        setUpRaZorPay(result);
      } else if (result is CashFreeResponse) {
        orderId.value = result.data?.orderId ?? '';
        sessionPaymentId.value = result.data?.paymentSessionId ?? '';
        setUpCashFree();
      } else {
        paymentLoader.value = false;
        CommonUtils.utils.handleAlertMsg(
            message: AppStrings.errorServerNotResponding);
      }
    } catch (e){
      paymentLoader.value = false;
      CommonUtils.utils.handleAlertMsg(
          message: AppStrings.errorSomethingWrong);
    }

  }


  // razor pay handler methods
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    updateRemainingBalance(razorpayResponse: response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentLoader.value = false;
    CommonUtils.utils.handleAlertMsg(
       message: AppStrings.errorPaymentFailed);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    updateRemainingBalance(razorpayResponse: PaymentSuccessResponse(
      "wallet_payment", "wallet_order", "", {}
    ));
  }

  Future<void> setUpRaZorPay(RazorPayResponse response) async {
    String keyId = response.data?.keyId ?? '';
    String orderId = response.data?.id ?? '';
    int amount = response.data?.amount ?? 0;
    String currency = response.data?.currency ?? '';
    String phone = CommonUtils.utils.formatIndianNumber(response.data?.phone);
    if(keyId.trim().isEmpty || orderId.trim().isEmpty
        || amount <=0 || currency.trim().isEmpty || phone.trim().isEmpty){
      paymentLoader.value = false;
      CommonUtils.utils.handleAlertMsg(
          message:  AppStrings.errorSomethingWrong);
      return;
    }

    var options = {
      'key': keyId,
      'order_id' : orderId,
      'amount': amount,
      'name': AppStrings.appName,
      'description': StorageUtils.utils.restaurantUserName,
      'prefill': {'contact':  phone},
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
    checkPaymentVerify();
  }

  void  checkPaymentVerify() async {
    try {
      var param = {
        "order_id": orderId.value
      };
      var apiResponse = await ApiController().restaurantVerifyCashFreeOrder(param);
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        if (apiResponse.response?.data["data"]["order_status"] == "PAID") {
          updateRemainingBalance();
        } else {
          paymentLoader.value = false;
          CommonUtils.utils.handleAlertMsg(
              message: apiResponse.msg);
        }
      } else {
        paymentLoader.value = false;
        verifyCount.value > 0 ? null
            : Get.dialog(showDialogBox(
          title: AppStrings.alertError,
          message: AppStrings.errorServerNotResponding,
          twoButtons: false,
          confirmTxt: AppStrings.btnRetry,
          onConfirm: () {
            verifyCount.value = verifyCount.value + 1;
            checkPaymentVerify();
          },
        ), barrierDismissible: false);
      }
    } catch (e){
      paymentLoader.value = false;
      CommonUtils.utils.handleAlertMsg(
          message: "If ${AppStrings.errorPaymentDeducted}");
    }


  }



  void onError(CFErrorResponse errorResponse, String orderId) {
    paymentLoader.value = false;
    CommonUtils.utils.handleAlertMsg(
       message:  errorResponse.getMessage().toString());
  }


  void setUpCashFree(){
    if(paymentOptionValue.value == 1) {
      upiPay();
    } else if (paymentOptionValue.value == 2) {
      cardPay();
    } else if(paymentOptionValue.value ==3) {
      netBankingPay();
    } else {
      paymentLoader.value = false;
      CommonUtils.utils.handleAlertMsg(
         message: AppStrings.errorServerNotResponding);
    }
  }


  CFSession? createSession() {
    try {
      var oid = orderId.value;
      var spi = sessionPaymentId.value;
      var session = CFSessionBuilder().setEnvironment(_cfEnvironment).setOrderId(oid).setPaymentSessionId(spi).build();
      return session;
    } on CFException catch (e) {
      CommonUtils.utils.handleAlertMsg(
         code:  400,
         message:  e.message);
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

  Future<void> upiPayNew() async {
    try {
      var sessionNew = createSession();
      if(sessionNew == null){
        paymentLoader.value = false;
        Get.snackbar(AppStrings.alertTitle, AppStrings.errorSomethingWrong,
        duration: Duration(seconds: 2));
        return;
      }
        var upi = CFUPIBuilder().setChannel(CFUPIChannel.INTENT_WITH_UI).build();
        var upiPayment = CFUPIPaymentBuilder().setSession(sessionNew).setUPI(upi).build();
        _cfPaymentGatewayService.doPayment(upiPayment);
    } on CFException catch (e) {
      debugPrint(e.message);
      paymentLoader.value = false;
    }
  }

  void cardPay(){
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