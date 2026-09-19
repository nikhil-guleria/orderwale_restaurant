import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:food_merchant/screens/dashboard_orders/view/dashboard_orders_view.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_binding.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_controller.dart';
import 'package:food_merchant/screens/order_details/controller/order_details_controller.dart';
import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsBinding.dart';
import 'package:food_merchant/screens/restaurant_details/view/RestaurantDetails.dart';
import 'package:food_merchant/screens/settings/controller/settings_binding.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_routes.dart';
import '../../settings/view/settings.dart';

class DashboardController extends GetxController{
  var currentIndex = 1.obs;
  final pages = <String>[AppRoutes.RESTAURANT_DETAILS,AppRoutes.MAIN, AppRoutes.SETTINGS];
  var storage = GetStorage();
  var globalId = 1.obs;

  @override
  void onInit() {
    checkGlobalId();
    super.onInit();
  }

  @override
  onReady(){
    checkTerminatedNotification();
    initIsolatePort();
    super.onReady();
  }





  void checkGlobalId(){
    var id = storage.read(GetStorageConstants.GLOBAL_ID);
    if(id != null){
       globalId.value = id ;
    }
    else {
      globalId.value = 1;
    }
  }


  void changePage(int index) {
    if( currentIndex.value == index)
    {
      return;
    }
    else {
      currentIndex.value = index;
      Get.offAndToNamed(pages[index], id: globalId.value);


    }
  }
  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.RESTAURANT_DETAILS) {
      return GetPageRoute(
          settings: settings,
          page: () => const RestaurantDetails(),
          binding: RestaurantDetailsBinding(),
          transitionDuration: const Duration(milliseconds: 10)
      );
    }


    if (settings.name == AppRoutes.MAIN) {
      return GetPageRoute(
          settings: settings,
          page: () =>const DashboardOrdersView(),
          binding: DashboardOrdersBinding(),
          transitionDuration: const Duration(milliseconds: 10)
      );
    }


    if (settings.name == AppRoutes.SETTINGS) {
      return GetPageRoute(
          settings: settings,
          page: () => const Settings(),
          binding: SettingsBinding(),
          transitionDuration: const Duration(milliseconds: 10)
      );
    }
    return null;
  }










  void initIsolatePort()  {
    ReceivePort port  = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort,'fcm_Message');
    port.listen((dynamic data) {
      if(data != null) {
        if (Get.isRegistered<OrderDetailsController>()) {
          OrderDetailsController controller = Get.find();
          controller.orderId = data;
          controller.getOrderDetails();
          storage.remove(GetStorageConstants.fcmOrderId);
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



  void checkTerminatedNotification()  {
    var fcmOrderId = storage.read(GetStorageConstants.fcmOrderId);
    if(fcmOrderId != null) {
      if (Get.isRegistered<OrderDetailsController>()) {
        OrderDetailsController controller = Get.find();
        controller.orderId = fcmOrderId;
        controller.getOrderDetails();
        storage.remove(GetStorageConstants.fcmOrderId);
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






}
