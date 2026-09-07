import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/PasswordTextFormFieldWidget.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';
import '../controller/SettingsController.dart';

class Settings extends GetView<SettingsController> {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =
    Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar( automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: colorWhite,
         centerTitle: true,
          title:
          TextWidget(text: dashboard_lbl_settings,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,)
          ),
      body: SafeArea(
        child: Obx(() =>
      Container(
        color: Colors.white,
        height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
        padding: EdgeInsets.only(
            bottom:  SizeConfig.blockSizeHorizontal*2,
            left: SizeConfig.blockSizeHorizontal*4,
            right: SizeConfig.blockSizeHorizontal*4),
        child: SingleChildScrollView(
          child: Stack(alignment: Alignment.center,
            children: [
              IgnorePointer(
                ignoring: controller.hideSettings.value ? true : false,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(text: settings_title, fontFamily: fontSemiBold,
                      fontSize: SizeConfig.appbarTitleSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 1,),
                  TextWidget(text: settings_desc, fontFamily: fontMedium,color: Colors.black45,
                      fontSize: SizeConfig.regularFontSize, ),
                 SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 6),

                  // update profile
                  Material(
                    color: transparentColor,
                    child: ListTile(
                        onTap: (){
                        Get.toNamed(Routes.UPDATE_PROFILE);
                      },
                        contentPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                        minLeadingWidth: 0.0,
                        minVerticalPadding: 0,
                        leading: const Icon(Icons.person),
                        trailing: SvgPicture.asset("assets/images/back.svg"),
                        title:  TextWidget(text: settings_profile_lbl,fontFamily: fontMedium,
                            fontSize: SizeConfig.appbarTitleSize),
                        subtitle: TextWidget(text: settings_profile_desc, color: blackShades,
                            fontSize: SizeConfig.blockSizeHorizontal*3.5,
                        fontFamily: fontRegular,),
                      ),
                  ),


                  // sales report
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(top:BorderSide(width: 0.1))),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.SALES_REPORT);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 0,
                          leading: const Icon(Icons.receipt),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title:TextWidget(text: settings_sales_report,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:TextWidget(text: settings_sales_descp, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ),

                  // manage restaurant
                  Container(
                    decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.EDIT_DETAILS);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 0,
                          leading: const Icon(Icons.restaurant,),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title:TextWidget(text: settings_manage_rest,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:TextWidget(text: settings_rest_desc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ),

                  // delivery area
                  Container(
                    decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.DELIVERY_AREA);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          leading: const Icon(CupertinoIcons.map_pin_ellipse),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title:TextWidget(text: settingsDeliveryArea,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:TextWidget(text: settingsDeliveryDesc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular
                          )),
                    ),
                  ),

                  // toppings list
                  Container(
                    decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.toppingsList);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 3,
                          leading: const Icon(Icons.hdr_strong),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title:TextWidget(text: settingsToppings,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:TextWidget(text: settingsToppingsDescription, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ),

                  // coupons list
                  Container(
                    decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.COUPONS_LIST);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 3,
                          leading: const Icon(Icons.discount,),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title:TextWidget(text: settings_add_coupons,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:TextWidget(text: settings_add_coupon_desc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ),


                  // change password
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.CHANGE_PASSWORD);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 0,
                          leading: const Icon(Icons.lock),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title: TextWidget(text: settings_change_password,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:
                          TextWidget(text: settings_password_desc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ) ,

                  // change restaurant
                  Visibility(
                    visible: controller.showChangeRest.value,
                    child: Container(decoration: const BoxDecoration(
                        border: Border(top:BorderSide(width: 0.1) )),
                      child: Material(
                        color: transparentColor,
                        child: ListTile( onTap: (){
                          Get.toNamed(Routes.SELECT_RESTAURANT);
                        },
                            contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                            minLeadingWidth: 0.0,
                            minVerticalPadding: 0,
                            leading: const Icon(Icons.change_circle),
                            trailing: SvgPicture.asset("assets/images/back.svg"),
                            title: TextWidget(text: settings_change_restaurant,fontFamily: fontMedium,
                                fontSize: SizeConfig.appbarTitleSize),
                            subtitle: TextWidget(text: settings_change_rest_desc, color: blackShades,
                                fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                fontFamily: fontRegular)),
                      ),),
                  ),

                  // printer settings
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile( onTap: (){
                        Get.toNamed(Routes.printerSettings);
                      },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 0,
                          leading:  const Icon(Icons.print),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title: TextWidget(text: settingsPrinterSettings,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle:
                          TextWidget(text: settingsPrinterSettingsDesc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),
                  ) ,


                  // logout
                  Container(decoration: const BoxDecoration(border: Border(top:BorderSide(width: 0.1) )),
                    child: Material(
                      color: transparentColor,
                      child: ListTile(
                          onTap: (){
                            controller.logOut();
                            },
                          contentPadding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 1.25),
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 0,
                          leading: const Icon(Icons.logout),
                          trailing: SvgPicture.asset("assets/images/back.svg"),
                          title: TextWidget(text: settings_logout,fontFamily: fontMedium,
                              fontSize: SizeConfig.appbarTitleSize),
                          subtitle: TextWidget(text: settings_logout_desc, color: blackShades,
                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
                              fontFamily: fontRegular)),
                    ),),


                ]),
              ),
              Obx(() =>
              Visibility(
                visible: controller.hideSettings.value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.7, sigmaY: 1.7),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withAlpha((0.0 * 255).round())),
                  ),
                ),
              )),

             Obx(() =>
              Visibility(
                visible: controller.hideSettings.value,
                child: Container(
                  height: SizeConfig.blockSizeHorizontal*74,
                  width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.25),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        border: Border.all(color: colorWhite, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                        color: colorWhite),
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal* 2.75),
                  child: Column( mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      TextWidget(text: settings_access,
                          fontFamily: fontMedium,color: colorPrimary,
                          fontSize: SizeConfig.mediumFontSize),
                      Obx(() =>
                          Form(key: controller.formKey,
                            child: PasswordTextFormWidget(
                              controller: controller.passwordController,
                              focusNode: controller.focusPassword,
                              validator: Validations.validations.validatePassword,
                              obscureText:
                              controller.passwordVisible.value,
                              toggle: () =>
                              controller.passwordVisible.value =
                              !controller.passwordVisible.value,
                            ),
                          )),
                      ButtonWidget(
                        text: settings_btn,
                        fontSize: SizeConfig.blockSizeHorizontal * 4.7,
                        onPressed: () {
                          controller.checkValidations();
                        },
                      ),
                    ],
                  ),
                ),
              ))

          ]),
        ),


      )),
    ) );

    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack( alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: Colors.white),
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