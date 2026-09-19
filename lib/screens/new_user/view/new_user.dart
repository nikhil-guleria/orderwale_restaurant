import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_drop_down.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:food_merchant/services/commonModels/cities_model.dart';
import 'package:food_merchant/services/commonModels/countries_model.dart';
import 'package:food_merchant/services/commonModels/states_model.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/custom_form_field.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';
import '../controller/new_user_controller.dart';

class NewUser extends GetView<NewUserController> {
  const NewUser({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: buildAppBar(title: AppStrings.newUserTitle),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // welcome
                  TextWidget(
                      text: AppStrings.welcome,
                      fontFamily: FontFamily.fontBold,
                      fontSize: SizeConfig.semiboldTextSize),
                  SizeConfig.verticalSpace12,


                  // description
                  TextWidget(
                      text: AppStrings.newUserDesc,
                      color: AppColors.normalTextColor),
                  SizeConfig.verticalSpace40,


                  // first name
                  buildInputFieldHeading(AppStrings.headingFirstName),
                  CustomFormField(
                    controller: controller.firstNameController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.lastName);
                    },
                    textCapitalization: TextCapitalization.words,
                    validator: Validations.validations.validateName,
                    focusNode: controller.firstName,
                    inputAction: TextInputAction.next,
                  ),
                  SizeConfig.verticalSpace20,


                  // last name
                  buildInputFieldHeading(AppStrings.headingLastName),
                  CustomFormField(
                    controller: controller.lastNameController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.emailId);
                    },
                    textCapitalization: TextCapitalization.words,
                    validator: Validations.validations.validateEmptyFields,
                    focusNode: controller.lastName,
                    inputAction: TextInputAction.next,
                  ),
                  SizeConfig.verticalSpace20,


                  // email
                  buildInputFieldHeading(AppStrings.headingEmail),
                  CustomFormField(
                    controller: controller.emailController,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(controller.phone);
                    },
                    focusNode: controller.emailId,
                    validator: Validations.validations.validateEmail,
                    inputAction: TextInputAction.next,
                  ),
                  SizeConfig.verticalSpace20,


                  // phone
                  buildInputFieldHeading(AppStrings.headingPhone),
                  CustomFormField(
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
                  SizeConfig.verticalSpace20,


                  // country & state
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // country
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputFieldHeading(AppStrings.headingCountry),
                            Obx(() => customDropDown<CountryData>(
                              hintText: AppStrings.hintSelectCountry,
                              value: controller.country.value,
                              validator: Validations.validations.validateDropDown,
                              items: GlobalVariables.ddCountriesList,
                              enableBorderColor: true,
                              onChanged: (newValue){
                                if(newValue != null){
                                  controller.setCountry(newValue);
                                }
                              },
                              displayItemName: (item) => item.name ?? '',
                            )),
                            /*Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: AppColors.textFieldFillColor,
                                      border: Border.all(
                                          color: AppColors.disabledBorderColor, width: 1.3),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(
                                        10.0,
                                      ))),
                                  child: InkWell(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      await controller.getCountry();
                                      if (context.mounted) {
                                        showModalBottomSheet(
                                            useSafeArea: true,
                                            context: context,
                                            backgroundColor: AppColors.white,
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
                                                            color: AppColors.grey,
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
                                                          fontFamily: FontFamily.fontMedium,
                                                          fontSize: SizeConfig
                                                              .mediumFontSize,
                                                          color: AppColors.blackText,
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
                                                                        color: AppColors.blackShades,
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
                                                  AppColors.normalTextColor : AppColors.blackText,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColors.colorPrimary,
                                            size: SizeConfig.semiBoldFontSize,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),*/
                          ],
                        ),
                      ),
                      SizeConfig.horizontalSpace12,

                      // state
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputFieldHeading(AppStrings.headingState),
                            Obx(()=>customDropDown<StateData>(
                                hintText: AppStrings.hintSelectState,
                                value: controller.state.value,
                                items: controller.stateList,
                                validator: Validations.validations.validateDropDown,
                                enableBorderColor: true,
                                onChanged: (newValue){
                                  if(newValue != null){
                                    controller.fetchCitiesList(context, newValue);
                                  }
                                },
                                displayItemName: (item) => item.name ?? ''
                            )),


                            /*Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: AppColors.textFieldFillColor,
                                      border: Border.all(
                                          color: AppColors.disabledBorderColor, width: 1.3),
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
                                                          color: AppColors.blackShades,
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
                                                  AppColors.normalTextColor : AppColors.blackText,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColors.colorPrimary,
                                            size: SizeConfig.semiBoldFontSize,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),*/
                          ],
                        ),
                      )
                    ],
                  ),
                  SizeConfig.verticalSpace20,


                  // city & pin code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // city
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputFieldHeading(AppStrings.headingCity),
                            Obx(()=> customDropDown<CityData>(
                                hintText: AppStrings.hintSelectCity,
                                value: controller.city.value,
                                items: controller.cityList,
                                validator: Validations.validations.validateDropDown,
                                enableBorderColor: true,
                                onChanged: (newValue){
                                  if(newValue != null){
                                    controller.setCity(newValue);
                                  }
                                },
                                displayItemName: (item) => item.name ?? ''
                            )),
                            /*Obx(() => Container(
                                  height: SizeConfig.blockSizeHorizontal * 13.8,
                                  padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                  decoration: BoxDecoration(
                                      color: AppColors.textFieldFillColor,
                                      border: Border.all(
                                          color: AppColors.disabledBorderColor, width: 1.3),
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
                                                          color: AppColors.blackShades,
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
                                                  AppColors.normalTextColor : AppColors.blackText,
        
                                            )
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*0.5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColors.colorPrimary,
                                            size: SizeConfig.semiBoldFontSize,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),*/
                          ],
                        ),
                      ),
                      SizeConfig.horizontalSpace12,

                      // pin code
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputFieldHeading(AppStrings.headingPinCode),
                            CustomFormField(
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
                  SizeConfig.verticalSpace20,


                  // address
                  buildInputFieldHeading(AppStrings.headingAddress),
                  InkWell(
                    onTap: () {
                      controller.goToSearchAddress();
                    },
                    child: CustomFormField(
                        enabled: false,
                        controller: controller.addressController,
                        focusNode: controller.addressFocus,
                        validator: Validations.validations.validateEmptyFields,
                        suffixIcon: Icon(Icons.search,
                            size: SizeConfig.semiBoldFontSize,
                            color: AppColors.colorPrimary)),
                  ),


                  SizeConfig.verticalSpace28,
                  ButtonWidget(
                    text: AppStrings.btnSubmit,
                    onPressed: controller.submitClick,
                  ),
                  SizeConfig.verticalSpace24,
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
