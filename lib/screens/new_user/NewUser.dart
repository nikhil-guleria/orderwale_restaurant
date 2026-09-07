import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/TextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'NewUserController.dart';

class NewUser extends GetView<NewUserController> {
  const NewUser({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: TextWidget(
          text: new_user_title,
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: fontSemiBold,
          weight: FontWeight.w600,
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
              bottom: SizeConfig.blockSizeHorizontal * 2,
              left: SizeConfig.blockSizeHorizontal * 4,
              right: SizeConfig.blockSizeHorizontal * 4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
                  TextWidget(
                      text: lbl_welcom,
                      fontFamily: fontBold,
                      fontSize: SizeConfig.boldFontSize),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                  TextWidget(
                      text: new_user_desc,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 10),
                  TextWidget(
                      text: user_first_name,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  TextFormWidget(
                    controller: controller.firstNameController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.lastName);
                    },
                    textCapitalization: TextCapitalization.words,
                    validator: Validations.validations.validateEmptyFields,
                    focusNode: controller.firstName,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  TextWidget(
                      text: user_last_name,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  TextFormWidget(
                    controller: controller.lastNameController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.emailId);
                    },
                    textCapitalization: TextCapitalization.words,
                    validator: Validations.validations.validateEmptyFields,
                    focusNode: controller.lastName,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  TextWidget(
                      text: user_email_id,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  TextFormWidget(
                    controller: controller.emailController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.phone);
                    },
                    focusNode: controller.emailId,
                    validator: Validations.validations.validateEmail,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  TextWidget(
                      text: user_phone,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  TextFormWidget(
                    controller: controller.phoneController,
                    validator: Validations.validations.validatePhone,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.pinCode);
                    },
                    focusNode: controller.phone,
                    inputAction: TextInputAction.next,
                    onlyNumbers: true,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: user_country,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                            Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: textFieldFillColor,
                                      border: Border.all(
                                          color: disabledBorderColor, width: 1.3),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(
                                        10.0,
                                      ))),
                                  child: InkWell(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      await controller.getCountry();
                                      if (context.mounted) {
                                        /* showCustomBottomSheet(
                                            context: context,
                                            title: select_country,
                                            childWidget: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                    left: 12, right: 12),
                                                itemCount:
                                                    controller.countriesList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      controller.country.value =
                                                          controller
                                                              .countriesList[index]
                                                              .countryName;
                                                      if (controller
                                                              .countryId.value ==
                                                          controller
                                                              .countriesList[index]
                                                              .countryId) {
                                                        Get.back();
                                                      } else {
                                                        controller.countryId.value =
                                                            controller
                                                                .countriesList[index]
                                                                .countryId;
                                                        controller.state.value ==
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
                                                            SizeConfig.mediumFontSize,
                                                      ),
                                                    ),
                                                  );
                                                }));
                                      }*/
        
        
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
                                                                        text: controller.countriesList[index].countryName,
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
                              text: user_state,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                            Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: textFieldFillColor,
                                      border: Border.all(
                                          color: disabledBorderColor, width: 1.3),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(
                                        10.0,
                                      ))),
                                  child: InkWell(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (controller.countryId.value != "0") {
                                        await controller.getState();
                                        if (context.mounted) {
                                          showCustomBottomSheet(
                                              context: context,
                                              title: select_state,
                                              childWidget: ListView.builder(
                                                  padding:  EdgeInsets.symmetric(
                                                      horizontal: SizeConfig.blockSizeHorizontal*3),
                                                  itemCount:
                                                      controller.statesList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      onTap: () {
                                                        controller.state.value =
                                                            controller
                                                                .statesList[index]
                                                                .stateName;
                                                        if (controller
                                                                .stateId.value ==
                                                            controller
                                                                .statesList[index]
                                                                .stateId) {
                                                          Get.back();
                                                        } else {
                                                          controller.stateId.value =
                                                              controller
                                                                  .statesList[index]
                                                                  .stateId;
                                                          controller.city.value =
                                                              "Select City";
                                                          Get.back();
                                                        }
                                                      },
                                                      title: Center(
                                                        child: TextWidget(
                                                          text: controller
                                                              .statesList[index]
                                                              .stateName,
                                                          color: blackShades,
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                        }
                                      } else {
                                        Get.snackbar(
                                            edit_screen_alert, snackbar_alert_state,duration: const Duration(seconds: 2));
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
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: user_city,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                            Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: textFieldFillColor,
                                      border: Border.all(
                                          color: disabledBorderColor, width: 1.3),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(
                                        10.0,
                                      ))),
                                  child: InkWell(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (controller.stateId.value != "0") {
                                        await controller.getCity();
                                        if (context.mounted) {
                                          showCustomBottomSheet(
                                              context: context,
                                              title: select_city,
                                              childWidget: ListView.builder(
                                                  padding:  EdgeInsets.symmetric(
                                                      horizontal: SizeConfig.blockSizeHorizontal*3),
                                                  itemCount:
                                                      controller.citiesList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      onTap: () {
                                                        controller.city.value =
                                                            controller
                                                                .citiesList[index]
                                                                .cityName;
                                                        controller.cityId.value =
                                                            controller
                                                                .citiesList[index]
                                                                .cityId;
                                                        Get.back();
                                                      },
                                                      title: Center(
                                                        child: TextWidget(
                                                          text: controller
                                                              .citiesList[index]
                                                              .cityName,
                                                          color: blackShades,
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                        }
                                      } else {
                                        Get.snackbar(
                                            edit_screen_alert, snackbar_alert_city,duration: const Duration(seconds: 2));
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
        
                                            )
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
                              text: user_pincode,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                            TextFormWidget(
                              controller: controller.pinCodeController,
                              validator: Validations.validations.validatePinCode,
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              onSubmitted: (v) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              focusNode: controller.pinCode,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  TextWidget(
                      text: user_address,
                      fontFamily: fontMedium,
                      color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  InkWell(
                    onTap: () {
                      controller.goToSearchAddress();
                    },
                    child: TextFormWidget(
                        enabled: false,
                        controller: controller.addressController,
                        focusNode: controller.addressFocus,
                        validator: Validations.validations.validateEmptyFields,
                        suffixIcon: Icon(Icons.search,
                            size: SizeConfig.semiBoldFontSize,
                            color: colorPrimary)),
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 8),
                  ButtonWidget(
                    text: user_submit,
                    fontFamily: fontMedium,
                    onPressed: () {
                      controller.onSubmit(context);
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );

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
