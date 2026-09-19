import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/dashboard_orders/view/dashboard_orders_view.dart';
import 'package:food_merchant/screens/restaurant_details/view/RestaurantDetails.dart';
import 'package:food_merchant/screens/settings/view/settings.dart';
import 'package:food_merchant/screens/tab_bar/controller/tab_bar_controller.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';

class TabBarView extends GetView<TabBarController> {
  const TabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    CommonUtils.utils.statusBarColored();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          if(controller.tabIndex.value == 1){
            Get.dialog(showDialogBox(title: AppStrings.alertTitle,
                message: AppStrings.alertMsgExitApp,
                twoButtons: true,
                onConfirm: () {
                  SystemNavigator.pop();
                }));}
          else {
            controller.changePageIndex(1);
          }
        }
      },
      child: Scaffold(
          body: PageView(
            controller: controller.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              RestaurantDetails(),
              DashboardOrdersView(),
              Settings()
            ],
          ),

          bottomNavigationBar: Obx(()=>
              SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 0.1,)
                        )
                    ),
                    padding: EdgeInsets.only(
                        top: 7, bottom: 1
                    ),
                    child: Row(
                      children: [
                        // restaurant
                        _navItem(image: AppImages.restaurantNav,
                            activeImage: AppImages.restaurantNavActive,
                            label: AppStrings.bottomNavRestaurant, index: 0),

                        // home
                        _navItem(image: AppImages.homeNav,
                            activeImage:AppImages.homeNavActive,
                            label: AppStrings.bottomNavHome, index: 1),

                        // setting
                        _navItem(image: AppImages.settingsNav,
                            activeImage: AppImages.settingsNavActive,
                            label: AppStrings.bottomNavSettings, index: 2),
                      ],
                    )
                ),
              )),
      ),
    );
  }

  Widget _navItem({required String image,
    required String activeImage,
    required String label, required int index}) {
    final isSelected = controller.tabIndex.value == index;

    return Expanded(
      child: InkWell(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        onTap: () => controller.changePageIndex(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(isSelected ? activeImage : image,
            width: 25, height: 25,),
            const SizedBox(height: 1),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,
                style: TextStyle(fontSize: 13,fontFamily: FontFamily.fontMedium,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? AppColors.colorPrimary : AppColors.grey)),
          ],
        ),
      ),
    );
  }
}