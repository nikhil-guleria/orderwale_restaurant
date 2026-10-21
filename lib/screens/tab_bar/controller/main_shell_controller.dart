import 'dart:isolate';
import 'dart:ui';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_controller.dart';
import 'package:food_merchant/screens/order_details/controller/order_details_controller.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';

class MainShellController extends GetxController {
  var tabIndex = 1.obs;
  final visited = <int>{1}.obs;


  @override
  onReady(){
    checkTerminatedNotification();
    initIsolatePort();
    super.onReady();
  }



  void changePageIndex(int index){
    visited.add(index);
    tabIndex.value = index;
  }



  void checkTerminatedNotification()  {
    var fcmOrderId = StorageUtils.utils.getFcmOrderId;
    if(fcmOrderId != null) {
      if (Get.isRegistered<OrderDetailsController>()) {
        OrderDetailsController controller = Get.find();
        controller.orderId = fcmOrderId;
        controller.getOrderDetails();
        StorageUtils.utils.removeFCMOrderId();
      } else {
        Get.toNamed(AppRoutes.orderDetails, arguments: fcmOrderId)?.then((value) {
          bool register = Get.isRegistered<DashboardOrdersController>();
          if (register) {
            DashboardOrdersController controller = Get.find();
            controller.onInit();
          }
        });
      }
    }
  }


  void initIsolatePort()  {
    ReceivePort port  = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort,AppStrings.fcmIsolatePort);
    port.listen((dynamic data) {
      if(data != null) {
        if (Get.isRegistered<OrderDetailsController>()) {
          OrderDetailsController controller = Get.find();
          controller.orderId = data;
          controller.getOrderDetails();
          StorageUtils.utils.removeFCMOrderId();
        } else {
          Get.toNamed(AppRoutes.orderDetails, arguments: data)?.then((value) {
            bool register = Get.isRegistered<DashboardOrdersController>();
            if (register) {
              DashboardOrdersController controller = Get.find();
              controller.onInit();
            }
          });
        }
      }
    });
  }


}