import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import '../../../component/color_loader.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';
import '../controller/settings_controller.dart';

class Settings extends GetView<SettingsController> {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =
    Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(title: AppStrings.settingsTitle,
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Container(
        color: AppColors.white,
        height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
        padding: EdgeInsets.only(
            bottom:  SizeConfig.blockSizeHorizontal*2,
            left: SizeConfig.blockSizeHorizontal*4,
            right: SizeConfig.blockSizeHorizontal*4),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // account settings
            TextWidget(text: AppStrings.settingsAccount,
                fontFamily: FontFamily.fontSemiBold,
                fontSize: SizeConfig.appbarTitleSize),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 1,),

           // settings description
            TextWidget(text: AppStrings.settingsDesc,
              fontFamily: FontFamily.fontMedium,
              color: AppColors.black45,
                fontSize: SizeConfig.regularFontSize, ),
           SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6),

            // profile settings
            if(StorageUtils.utils.restaurantUserRole.trim() != AppStrings.userRoleAdmin)
            Material(
              color: AppColors.transparent,
              child: ListTile(
                  onTap: controller.profileSettingsClick,
                  contentPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                  minLeadingWidth: 0.0,
                  minVerticalPadding: 0,
                  leading: const Icon(Icons.person),
                  trailing: SvgPicture.asset(AppImages.settingsBack),
                  title:  TextWidget(text: AppStrings.settingsProfileHeading,
                      fontFamily: FontFamily.fontMedium,
                      fontSize: SizeConfig.appbarTitleSize),
                  subtitle: TextWidget(text: AppStrings.settingsProfileDesc,
                    color: AppColors.blackShades,
                    fontSize: SizeConfig.blockSizeHorizontal*3.5,
                  fontFamily: FontFamily.fontRegular,),
                ),
            ),



            if(StorageUtils.utils.restaurantUserRole.trim() == AppStrings.userRoleAdmin
            || StorageUtils.utils.restaurantUserRole.trim() == AppStrings.userRoleManager)
              ...[
                // manage restaurant
                Container(
                  decoration:  BoxDecoration(
                      border: Border(top:BorderSide(
                          width: StorageUtils.utils.restaurantUserRole.trim() == AppStrings.userRoleManager
                          ? 0.1 : 0.0))
                  ),
                  child: Material(
                    color: AppColors.transparent,
                    child: ListTile(
                        onTap: controller.manageRestaurantClick,
                        contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                        minLeadingWidth: 0.0,
                        minVerticalPadding: 0,
                        leading: const Icon(Icons.restaurant,),
                        trailing: SvgPicture.asset(AppImages.settingsBack),
                        title:TextWidget(text: AppStrings.settingsManageRestHeading,
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.appbarTitleSize),
                        subtitle:TextWidget(text: AppStrings.settingsManageRestDesc,
                            color: AppColors.blackShades,
                            fontSize: SizeConfig.blockSizeHorizontal*3.5,
                            fontFamily: FontFamily.fontRegular)),
                  ),
                ),

                // sales report
                Container(
                  decoration:  BoxDecoration(
                      border: Border(top:BorderSide(width: 0.1))
                  ),
                  child: Material(
                    color: AppColors.transparent,
                    child: ListTile(
                        onTap: controller.salesReportClick,
                        contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                        minLeadingWidth: 0.0,
                        minVerticalPadding: 0,
                        leading: const Icon(Icons.receipt),
                        trailing: SvgPicture.asset(AppImages.settingsBack),
                        title:TextWidget(text: AppStrings.settingsSalesReportHeading,
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.appbarTitleSize),
                        subtitle:TextWidget(text: AppStrings.settingsSalesReportDesc,
                            color: AppColors.blackShades,
                            fontSize: SizeConfig.blockSizeHorizontal*3.5,
                            fontFamily: FontFamily.fontRegular)),
                  ),
                ),
              ],

            // delivery area
            Container(
              decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.deliveryAreaClick,
                    contentPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    leading: const Icon(CupertinoIcons.map_pin_ellipse),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title:TextWidget(text: AppStrings.settingsDeliveryAreaHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle:TextWidget(text: AppStrings.settingsDeliveryAreaDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular
                    )),
              ),
            ),

            // toppings
            Container(
              decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.toppingsClick,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 3,
                    leading: const Icon(Icons.hdr_strong),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title:TextWidget(text: AppStrings.settingsToppingsHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle:TextWidget(text: AppStrings.settingsToppingsDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),
            ),

            // coupons
            Container(
              decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.couponsClick,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 3,
                    leading: const Icon(Icons.discount,),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title:TextWidget(text: AppStrings.settingsCouponsHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle:TextWidget(text: AppStrings.settingsCouponsDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),
            ),

            // change password
            Container(
              decoration: const BoxDecoration(
                  border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.changePasswordClick,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 0,
                    leading: const Icon(Icons.lock),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title: TextWidget(text: AppStrings.settingsChangePasswordHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle:
                    TextWidget(text: AppStrings.settingsChangePasswordDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),
            ) ,

            // printer settings
            Container(
              decoration: const BoxDecoration(
                  border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.printerSettingsClick,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 0,
                    leading:  const Icon(Icons.print),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title: TextWidget(text: AppStrings.settingsPrinterSettingsHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle:
                    TextWidget(text: AppStrings.settingsPrinterSettingsDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),
            ),

            // help & support
            Container(
              decoration: const BoxDecoration(
                  border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.helpAndSupportClick,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 0,
                    leading:  const Icon(Icons.support_agent),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title: TextWidget(text: AppStrings.settingsHelpAndSupportHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle: TextWidget(text: AppStrings.settingsHelpAndSupportDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),
            ) ,


            // logout
            Container(decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
              child: Material(
                color: AppColors.transparent,
                child: ListTile(
                    onTap: controller.logOut,
                    contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 0,
                    leading: const Icon(Icons.logout),
                    trailing: SvgPicture.asset(AppImages.settingsBack),
                    title: TextWidget(text: AppStrings.settingsLogoutHeading,
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.appbarTitleSize),
                    subtitle: TextWidget(text: AppStrings.settingsLogoutDesc,
                        color: AppColors.blackShades,
                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: FontFamily.fontRegular)),
              ),),
          ]),
        ),


      )),
     );

    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack( alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: AppColors.white),
          ),
          ColorLoader()

        ],
      )
          : const SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);
  }
}