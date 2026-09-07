import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../../../constant/string_constants.dart';
import '../../../routes/app_pages.dart';
import '../controller/dashboard_controller.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    CommonUtils.utils.statusBarColored();
    return
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _){
            if(didPop) {
              return ;
            } else {
              if(controller.currentIndex.value == 1){
              Get.dialog(showDialogBox(title: alert,
                  message: "Do you want to exit the App?",
                  twoButtons: true,
                  onCancel: (){
                    Get.back();
                  },
                  onConfirm: () {
                    SystemNavigator.pop();
                  }));}
              else {
                controller.changePage(1);
              }
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: colorWhite,
              body: Navigator(
                key: Get.nestedKey(controller.globalId.value),
                initialRoute: Routes.MAIN,
                onGenerateRoute: controller.onGenerateRoute,
              ),

              bottomNavigationBar: Obx (() =>
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.1,)
                      )
                    ),
                    child: NavigationBar(
                      height: 70,
                      backgroundColor: Colors.white60,
                      indicatorColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      overlayColor:  WidgetStateColor.resolveWith((states) => Colors.transparent),
                      selectedIndex: controller.currentIndex.value,
                      onDestinationSelected: controller.changePage,
                      destinations: [
                        NavigationDestination(
                            icon:  SvgPicture.asset(restaurantNav),
                            selectedIcon:  SvgPicture.asset(restaurantNavActive),
                            label: dashboard_lbl_restaurant),
                        NavigationDestination(
                            icon:  SvgPicture.asset(homeNav),
                            selectedIcon:  SvgPicture.asset(homeNavActive),
                            label: dashboard_lbl_main),
                        NavigationDestination(
                            icon:  SvgPicture.asset(settingsNav),
                            selectedIcon:  SvgPicture.asset(settingsNavActive),
                            label: dashboard_lbl_settings),
                      ],
                    ),
                  )
              )

          ),
        );
  }

}