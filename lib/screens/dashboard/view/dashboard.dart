import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_strings.dart';
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
              Get.dialog(showDialogBox(title: AppStrings.alertTitle,
                  message: "Do you want to exit the App?",
                  twoButtons: true,
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
              backgroundColor: AppColors.white,
              body: Navigator(
                key: Get.nestedKey(controller.globalId.value),
                initialRoute: "/home",
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
                            icon:  SvgPicture.asset(AppImages.restaurantNav),
                            selectedIcon:  SvgPicture.asset(AppImages.restaurantNavActive),
                            label: AppStrings.bottomNavRestaurant),
                        NavigationDestination(
                            icon:  SvgPicture.asset(AppImages.homeNav),
                            selectedIcon:  SvgPicture.asset(AppImages.homeNavActive),
                            label: AppStrings.bottomNavHome),
                        NavigationDestination(
                            icon:  SvgPicture.asset(AppImages.settingsNav),
                            selectedIcon:  SvgPicture.asset(AppImages.settingsNavActive),
                            label: AppStrings.bottomNavSettings),
                      ],
                    ),
                  )
              )

          ),
        );
  }

}