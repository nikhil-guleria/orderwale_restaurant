import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/component/CustomRadioButton.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/DialogBox.dart';
import '../../component/TextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_constant.dart';
import '../../constant/app_images.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'EditDetailsController.dart';
import 'Indicators.dart';

class EditDetails extends GetView<EditDetailsController> {
  const EditDetails({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          title: TextWidget(
            text: edit_details_screen_title,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            Visibility(
              visible: false,
              ///hide restaurant delete functionality
              child: Padding(
                padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                child: IconButton(
                  onPressed: () {
                    controller.deleteRestaurant();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Obx(() => controller.initialLoad.value
              ? Center(
                  child: TextWidget(
                      text: "Please wait...",
                      color: colorPrimary,
                      fontSize: SizeConfig.mediumFontSize,
                      fontFamily: fontMedium))
              : Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeHorizontal * 2,
                      bottom: SizeConfig.blockSizeHorizontal * 2,
                      left: SizeConfig.blockSizeHorizontal * 4,
                      right: SizeConfig.blockSizeHorizontal * 4),
                  child: SingleChildScrollView(
                    child: Form(key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9)
                              ),
                                height: SizeConfig.blockSizeHorizontal * 55,
                                width: Get.width,
                                child: Obx(() =>
                                        //  controller.imagePaths.isEmpty ?
                                        controller.fileImage.value != ""
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                              child: Image.file(
                                                  File(controller.fileImage.value),
                                                  fit: BoxFit.cover),
                                            )
                                            :
                                        ClipRRect(
                                            borderRadius: const BorderRadius.all( Radius.circular(6)),
                                            child: CachedNetworkImage(
                                              height: SizeConfig.blockSizeHorizontal * 55,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                              imageUrl: controller.image.value,
                                              placeholder: (context, url) => Image.asset(loadingGif, fit: BoxFit.cover),
                                              errorWidget: (context, url, error) => Image.asset(appLogoTransparent),
                                            )
                                        )
                                    /*  PageView.builder(
                                    controller: controller.pageController,
                                    itemCount: controller.imagePaths.length,
                                    pageSnapping: true,
                                    onPageChanged: (page) {
                                      controller.activePage.value = page;
                                      controller.imagePaths.length > 1
                                          ? controller.isHideIcon.value = false
                                          : controller.isHideIcon.value = true;
                                    },
                                    itemBuilder: (context, pagePosition) {
                                      return
                                           controller.imagePaths[pagePosition]
                                                  .startsWith(RegExp('https'))
                                              ? Image.network(
                                                  controller
                                                      .imagePaths[pagePosition],
                                                  fit: BoxFit.cover)
                                              : Image.file(
                                                  File(controller
                                                      .imagePaths[pagePosition]),
                                                  fit: BoxFit.cover);
                                    })*/
                                    )),
                            Container(
                              margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.25,
                                  bottom: SizeConfig.blockSizeHorizontal*1.25),
                              decoration: BoxDecoration(
                                  color: colorPrimary,
                                  border: Border.all(color: colorWhite, width: 2.5),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    10.0,
                                  ))),
                              height: SizeConfig.blockSizeHorizontal * 10,
                              width: SizeConfig.blockSizeHorizontal * 10,
                              child: Center(
                                child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      controller.imagePaths.length > 4
                                          ? Get.dialog(
                                          showDialogBox(
                                                title: edit_screen_alert,
                                                message:
                                                    edit_screen_image_alert_msg,
                                                twoButtons: false,
                                                onConfirm: () {
                                                  Get.close(1);
                                                },
                                              ),
                                              barrierDismissible: false)
                                          :
          
          
                                      Get.dialog(AlertDialog(
                                        backgroundColor: colorWhite,
                                          surfaceTintColor: colorWhite,
                                          title:  Text(
                                              "Select Image",textAlign: TextAlign.center,style: TextStyle(
                                            fontSize: SizeConfig.semiBoldFontSize,
                                            fontFamily: fontSemiBold,
                                          )),
                                          actionsPadding: const EdgeInsets.only(top: 0,bottom: 0),
                                          actions: [
                                            Center(
                                              child: MaterialButton(
                                                  child:  Text(
                                                    "Take Photo", style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                                      fontFamily: fontMedium),),
                                                  onPressed: (){
                                                    Get.back(result: "Camera");
                                                  }),
                                            ),
                                            Center(
                                              child: MaterialButton(
                                                onPressed: ()  {
                                                  Get.back(result: "Gallery");
                                                },
                                                child:  Text(
                                                  "Choose From Library",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                                    fontFamily: fontMedium),),
                                              ),
                                            ),
                                            Center(
                                              child: MaterialButton(
                                                onPressed: (){
                                                  Get.back();},
                                                child:  Text(
                                                    "Cancel",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                                    fontFamily: fontMedium)),
                                              ),
                                            ),
                                          ])).then((value) {
                                        if(value == "Camera"){
                                          controller.getFromCamera();
                                        } else if(value == "Gallery"){
                                          controller.getFromGallery();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      controller.image.value != "" ? Icons.edit
                                     : Icons.add,
                                      color: colorWhite,
                                      size: SizeConfig.blockSizeHorizontal * 6.2,
                                    )),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: controller.imagePaths.length > 1,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: indicators(
                                        controller.imagePaths.length,
                                        controller.activePage.value)),
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: InkWell(
                                  onTap: () {
                                    controller.removeImages();
                                  },
                                  child: Obx(
                                    () => Visibility(
                                      visible: !controller.isHideIcon.value,
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        height: SizeConfig.blockSizeHorizontal * 7,
                                        width: SizeConfig.blockSizeHorizontal * 7,
                                        decoration: BoxDecoration(
                                            color: colorPrimary,
                                            border: Border.all(
                                                color: colorWhite, width: 1.5),
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.blockSizeHorizontal *
                                                    7)),
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: colorWhite,
                                            size: SizeConfig.semiBoldFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
                          TextWidget(
                            text: edit_screen_rest_name,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                            controller: controller.restNameController,
                            textCapitalization: TextCapitalization.words,
                            validator: Validations.validations.validateEmptyFields,
                            prefixIcon: Icon(Icons.person,
                                size: SizeConfig.semiBoldFontSize,
                                color: colorPrimary),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          TextWidget(
                            text: edit_screen_email,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                            controller: controller.emailController,
                            validator: Validations.validations.validateEmail,
                            prefixIcon: Icon(Icons.email_outlined,
                                size: SizeConfig.semiBoldFontSize,
                                color: colorPrimary),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          TextWidget(
                            text: edit_screen_phone,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                            controller: controller.phoneController,
                            validator: Validations.validations.validatePhone,
                            prefixIcon: Icon(Icons.phone,
                                size: SizeConfig.semiBoldFontSize,
                                color: colorPrimary),
                            inputAction: TextInputAction.done,
                            onlyNumbers: true,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_country,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal *2),
                                    Obx(() => Container(
                                          height: SizeConfig.blockSizeHorizontal * 13.8,
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                          decoration: BoxDecoration(
                                              color: textFieldFillColor,
                                              border: Border.all(
                                                  color: disabledBorderColor,
                                                  width: 1.3),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(
                                                10.0,
                                              ))),
                                          child: InkWell(
                                            onTap: () async {
                                              await controller.getCountry();
                                              if (context.mounted) {
                                                showModalBottomSheet(
                                                    useSafeArea: true,
                                                    context: context,
                                                    backgroundColor: colorWhite,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(25.0),
                                                      ),
                                                    ),
                                                    builder: (BuildContext context) {
                                                      return SafeArea(
                                                        child: SizedBox(
                                                          height: SizeConfig.blockSizeHorizontal * 40,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              SizedBox(height: SizeConfig
                                                                  .blockSizeHorizontal * 3),
                                                              Container(
                                                                height: 3,
                                                                width: SizeConfig.blockSizeHorizontal*15,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius
                                                                        .circular(SizeConfig
                                                                        .blockSizeHorizontal * 1)
                                                                ),
                                                              ),
                                                              SizedBox(height: SizeConfig
                                                                  .blockSizeHorizontal * 4),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                padding: EdgeInsets.only(
                                                                    left: SizeConfig
                                                                        .blockSizeHorizontal * 4),
                                                                child: TextWidget(
                                                                  text: select_country,
                                                                  fontFamily: fontMedium,
                                                                  fontSize: SizeConfig
                                                                      .mediumFontSize,
                                                                  color: Colors.black,
                                                                  weight: FontWeight.bold,),
                                                              ),
                                                              SizedBox(height: SizeConfig
                                                                  .blockSizeHorizontal * 2),
                                                              Expanded(
                                                                  child:
                                                                  SingleChildScrollView(
                                                                    child: ListView.builder(
                                                                        padding:  EdgeInsets
                                                                            .symmetric(
                                                                          horizontal: SizeConfig.blockSizeHorizontal*3),
                                                                        itemCount:
                                                                        controller.countriesList
                                                                            .length,
                                                                        shrinkWrap: true,
                                                                        physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                        itemBuilder: (context,
                                                                            index) {
                                                                          return ListTile(
                                                                            onTap: () {
                                                                              controller.country
                                                                                  .value =
                                                                                  controller
                                                                                      .countriesList[index]
                                                                                      .countryName;
                                                                              if (controller
                                                                                  .countryId
                                                                                  .value ==
                                                                                  controller
                                                                                      .countriesList[index]
                                                                                      .countryId) {
                                                                                Get.back();
                                                                              } else {
                                                                                controller
                                                                                    .countryId
                                                                                    .value =
                                                                                    controller
                                                                                        .countriesList[index]
                                                                                        .countryId;
                                                                                controller.state
                                                                                    .value ==
                                                                                    "Select State";
                                                                                Get.back();
                                                                              }
                                                                            },
                                                                            title: Center(
                                                                              child: TextWidget(
                                                                                text: controller
                                                                                    .countriesList[index]
                                                                                    .countryName,
                                                                                color: blackShades,
                                                                                fontSize:
                                                                                SizeConfig
                                                                                    .mediumFontSize,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
          
          
          
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child:
                                                    TextWidget(
                                                      text: controller.country.value,
                                                      color: controller.country.value == "Select Country" ?
                                                      normalTextColor : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: colorPrimary,
                                                    size: SizeConfig.semiBoldFontSize,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_state,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    Obx(() => Container(
                                          height: SizeConfig.blockSizeHorizontal * 13.8,
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                          decoration: BoxDecoration(
                                              color: textFieldFillColor,
                                              border: Border.all(
                                                  color: disabledBorderColor,
                                                  width: 1.3),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(
                                                10.0,
                                              ))),
                                          child: InkWell(
                                            onTap: () async {
                                              if (controller.countryId.value != "0") {
                                                await controller.getState();
                                                if (context.mounted) {
                                                  showCustomBottomSheet(
                                                      context: context,
                                                      title: select_state,
                                                      childWidget: ListView.builder(
                                                          padding: EdgeInsets
                                                                  .symmetric(
                                                              horizontal: SizeConfig.blockSizeHorizontal*3),
                                                          itemCount: controller
                                                              .statesList.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              onTap: () {
                                                                controller
                                                                        .state.value =
                                                                    controller
                                                                        .statesList[
                                                                            index]
                                                                        .stateName;
                                                                if (controller.stateId
                                                                        .value ==
                                                                    controller
                                                                        .statesList[
                                                                            index]
                                                                        .stateId) {
                                                                  Get.back();
                                                                } else {
                                                                  controller.stateId
                                                                          .value =
                                                                      controller
                                                                          .statesList[
                                                                              index]
                                                                          .stateId;
                                                                  controller.city
                                                                          .value =
                                                                      "Select City";
                                                                  Get.back();
                                                                }
                                                              },
                                                              title: Center(
                                                                child: TextWidget(
                                                                  text: controller
                                                                      .statesList[
                                                                          index]
                                                                      .stateName,
                                                                  color: blackShades,
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                }
                                              } else {
                                                Get.snackbar(edit_screen_alert,
                                                    snackbar_alert_state,duration: const Duration(seconds: 2));
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child:
                                                    TextWidget(
                                                      text: controller.state.value,
                                                      color: controller.state.value == "Select State" ?
                                                      normalTextColor : Colors.black,
                                                    )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: colorPrimary,
                                                    size: SizeConfig.semiBoldFontSize,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_city,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    Obx(() => Container(
                                          height: SizeConfig.blockSizeHorizontal * 13.8,
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                          decoration: BoxDecoration(
                                              color: textFieldFillColor,
                                              border: Border.all(
                                                  color: disabledBorderColor,
                                                  width: 1.3),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(
                                                10.0,
                                              ))),
                                          child: InkWell(
                                            onTap: () async {
                                              if (controller.stateId.value != "0") {
                                                await controller.getCity();
                                                if (context.mounted) {
                                                  showCustomBottomSheet(
                                                      context: context,
                                                      title: select_city,
                                                      childWidget: ListView.builder(
                                                          padding: EdgeInsets
                                                                  .symmetric(
                                                              horizontal: SizeConfig.blockSizeHorizontal*3),
                                                          itemCount: controller
                                                              .citiesList.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              onTap: () {
                                                                controller
                                                                        .city.value =
                                                                    controller
                                                                        .citiesList[
                                                                            index]
                                                                        .cityName;
                                                                controller.cityId
                                                                        .value =
                                                                    controller
                                                                        .citiesList[
                                                                            index]
                                                                        .cityId;
                                                                Get.back();
                                                              },
                                                              title: Center(
                                                                child: TextWidget(
                                                                  text: controller
                                                                      .citiesList[
                                                                          index]
                                                                      .cityName,
                                                                  color: blackShades,
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                }
                                              } else {
                                                Get.snackbar(edit_screen_alert,
                                                    snackbar_alert_city,duration: const Duration(seconds: 2));
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child:
                                                    TextWidget(
                                                      text: controller.city.value,
                                                      color: controller.city.value == "Select City" ?
                                                      normalTextColor : Colors.black,
                                                  )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: colorPrimary,
                                                    size: SizeConfig.semiBoldFontSize,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_pincode,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    TextFormWidget(
                                      controller: controller.pinCodeController,
                                      prefixIcon: Icon(Icons.pin,
                                          size: SizeConfig.semiBoldFontSize,
                                          color: colorPrimary),
                                      validator: Validations.validations.validatePinCode,
                                      onlyNumbers: true,
                                      keyboardType: TextInputType.number,
                                      inputAction: TextInputAction.next,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          RichText(
                              text: TextSpan(
                                  text: edit_screen_address,
                                  style: TextStyle(
                                      color: normalTextColor,
                                      fontSize: SizeConfig.mediumFontSize,
                                      fontFamily: fontMedium),
                                  children: [
                                TextSpan(
                                    text: edit_screen_address_desc,
                                    style: TextStyle(
                                        color: normalTextColor,
                                        fontSize: SizeConfig.regularFontSize,
                                        fontFamily: fontRegular))
                              ])),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                            controller: controller.addressController,
                            validator: Validations.validations.validateEmptyFields,
                            inputAction: TextInputAction.next,
                            suffixIcon: InkWell(
                                onTap: () {
                                  controller.goToMap();
                                },
                                child: Icon(Icons.map,
                                    size: SizeConfig.semiBoldFontSize,
                                    color: colorPrimary)),
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_opening_time,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal *2),
                                    Container(
                                        height: SizeConfig.blockSizeHorizontal * 13.8,
                                        padding:
                                             EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                                        decoration: BoxDecoration(
                                            color: textFieldFillColor,
                                            border: Border.all(
                                                color: disabledBorderColor, width: 1.3),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(
                                              10.0,
                                            ))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(() => TextWidget(
                                                  text: controller.openingTime.value,
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  await controller
                                                      .openingTimePicker(context);
                                                },
                                                child: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: SizeConfig.semiBoldFontSize,
                                                    color: colorPrimary)),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_closing_time,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    Container(
                                        height: SizeConfig.blockSizeHorizontal * 13.8,
                                        padding:
                                             EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                                        decoration: BoxDecoration(
                                            color: textFieldFillColor,
                                            border: Border.all(
                                                color: disabledBorderColor, width: 1.3),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(
                                              10.0,
                                            ))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(() => TextWidget(
                                                  text: controller.closingTime.value,
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  await controller
                                                      .closingTimePicker(context);
                                                },
                                                child: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: SizeConfig.semiBoldFontSize,
                                                    color: colorPrimary)),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
                          // average price and minimum order price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_average_price,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    TextFormWidget(
                                        controller:
                                            controller.averagePriceController,
                                        prefixIcon: Icon(Icons.currency_rupee,
                                            size: SizeConfig.mediumFontSize,
                                            color: colorPrimary),
                                        inputAction: TextInputAction.next,
                                        onlyNumbers: true,
                                        keyboardType: TextInputType.number,
                                        hintText: "e.g. 100"),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: edit_screen_min_orderPrice,
                                      fontFamily: fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    TextFormWidget(
                                        controller: controller.minOrderPriceController,
                                        onlyNumbers: true,
                                        keyboardType: TextInputType.number,
                                        prefixIcon: Icon(Icons.currency_rupee,
                                            size: SizeConfig.mediumFontSize,
                                            color: colorPrimary),
                                        inputAction: TextInputAction.done,
                                        hintText: "e.g. 30"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
                          // disable discount
                          Visibility(
                            visible: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: edit_screen_discount,
                                        fontFamily: fontMedium,
                                        fontSize: SizeConfig.mediumFontSize,
                                        color: normalTextColor,
                                      ),
                                      SizedBox(
                                          height: SizeConfig.blockSizeHorizontal * 2),
                                      TextFormWidget(
                                          controller: controller.discountController,
                                          prefixIcon: Icon(Icons.currency_rupee,
                                              size: SizeConfig.mediumFontSize,
                                              color: colorPrimary),
                                          inputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          allowDecimal: true,
                                          hintText: "e.g. 20"),
                                    ],
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: edit_screen_distance_rate,
                                        fontFamily: fontMedium,
                                        fontSize: SizeConfig.mediumFontSize,
                                        color: normalTextColor,
                                      ),
                                      SizedBox(
                                          height: SizeConfig.blockSizeHorizontal * 2),
                                      TextFormWidget(
                                          controller:
                                              controller.chargesPerKmController,
                                          prefixIcon: Icon(Icons.currency_rupee,
                                              size: SizeConfig.mediumFontSize,
                                              color: colorPrimary),
                                          inputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          allowDecimal: true,
                                          hintText: "e.g. 10"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
          
          
                          // minimum delivery distance
                          TextWidget(
                            text: edit_screen_min_delivery_distance,
                            fontFamily: fontMedium,
                            fontSize:SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                              controller: controller
                                  .minDeliveryDistanceController,
                              prefixIcon: Icon(Icons.social_distance,
                                  size: SizeConfig.mediumFontSize,
                                  color: colorPrimary),
                              inputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              allowDecimal: true,
                              hintText: "e.g. 2 km"),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
          
          
                          // minimum delivery charges
                          TextWidget(
                            text: edit_screen_min_deliveryPrice,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                              controller:
                              controller.minDeliveryChargeController,
                              prefixIcon: Icon(Icons.currency_rupee,
                                  size: SizeConfig.mediumFontSize,
                                  color: colorPrimary),
                              inputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              allowDecimal: true,
                              hintText: "e.g. 20"),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
          
          
                          // charges per km
                          TextWidget(
                            text: edit_screen_distance_rate,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                              controller:
                              controller.chargesPerKmController,
                              prefixIcon: Icon(Icons.currency_rupee,
                                  size: SizeConfig.mediumFontSize,
                                  color: colorPrimary),
                              inputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              allowDecimal: true,
                              hintText: "e.g. 10"),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
          
          
          
                          // free delivery amount
                          TextWidget(
                            text: edit_scree_free_delivery_amnt,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: normalTextColor,
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          TextFormWidget(
                            controller: controller.freeDeliveryAmountController,
                            prefixIcon: Icon(Icons.currency_rupee,
                                size: SizeConfig.semiBoldFontSize,
                                color: colorPrimary),
                            inputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            onlyNumbers: true,
                          ),
          
          
                          // disable discount type
                          Visibility(
                            visible: false,
                            child: TextWidget(
                              text: edit_screen_discount_type,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              width: Get.width,
                              height: SizeConfig.blockSizeHorizontal * 15.8,
                              decoration: BoxDecoration(
                                  color: textFieldFillColor,
                                  border: Border.all(
                                      color: disabledBorderColor, width: 1.3),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    10.0,
                                  ))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => MyRadioListTile(
                                      value: "0",
                                      groupValue: controller.discountType.value,
                                      onChanged: (value) {
                                        controller.onChangeType(value!);
                                      },
                                      title: TextWidget(
                                        text: radio_btn_flat,
                                        fontSize: SizeConfig.regularFontSize,
                                        color: normalTextColor,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => MyRadioListTile(
                                      value: "1",
                                      groupValue: controller.discountType.value,
                                      onChanged: (value) {
                                        controller.onChangeType(value!);
                                      },
                                      title: TextWidget(
                                        text: radio_btn_percentage,
                                        fontSize: SizeConfig.regularFontSize,
                                        color: normalTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
          
          
          
          
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                          ButtonWidget(
                            text: edit_screen_button_text,
                            fontSize: SizeConfig.mediumFontSize,
                            onPressed: () {
                              controller.checkValidation();
                            },
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                        ],
                      ),
                    ),
                  ))),
        ));
    widgetList.add(child);
    final modal = Obx(
      () => controller.showLoader.value
          ? Stack(
              alignment: Alignment.center,
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
