import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_bottom_sheet.dart';
import 'package:food_merchant/component/custom_drop_down.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:food_merchant/services/commonModels/countries_model.dart';
import 'package:food_merchant/utils/validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/color_loader.dart';
import '../../component/custom_form_field.dart';
import '../../component/custom_text_widget.dart';
import '../../constant/font_family.dart';
import '../../constant/app_images.dart';
import '../../constant/app_strings.dart';
import '../../utils/size_config.dart';
import 'manage_restaurant_controller.dart';


class ManageRestaurant extends GetView<ManageRestaurantController> {
  const ManageRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: AppColors.white,
        appBar: buildAppBar(title: AppStrings.manageRestaurantTitle),
        body: SafeArea(
          child: Obx(() => controller.initialLoad.value
              ? Center(
                  child: TextWidget(
                      text: AppStrings.headingPleaseWait,
                      color: AppColors.colorPrimary,
                      fontSize: SizeConfig.mediumFontSize,
                      fontFamily: FontFamily.fontMedium))
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
                                controller.imageFile.value != null
                                    ? ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                              child: Image.file(controller.imageFile.value!,
                                                  fit: BoxFit.cover),
                                            )
                                    : ClipRRect(
                                            borderRadius: const BorderRadius.all( Radius.circular(6)),
                                            child: CachedNetworkImage(
                                              height: SizeConfig.blockSizeHorizontal * 55,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                              imageUrl: controller.restaurantsDetail.value.bannerThumbnail ?? '',
                                              placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                              errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                            )
                                        )
                                    )),
                            Container(
                              margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.25,
                                  bottom: SizeConfig.blockSizeHorizontal*1.25),
                              decoration: BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  border: Border.all(color: AppColors.white, width: 2.5),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    10.0,
                                  ))),
                              height: SizeConfig.blockSizeHorizontal * 10,
                              width: SizeConfig.blockSizeHorizontal * 10,
                              child: Center(
                                child: InkWell(
                                    onTap: controller.pickImage,
                                    child: Icon(
                                      (controller.restaurantsDetail.value.bannerImage ?? '').trim().isNotEmpty
                                          ? Icons.edit : Icons.add,
                                      color: AppColors.white,
                                      size: SizeConfig.blockSizeHorizontal * 6.2,
                                    )),
                              ),
                            ),
                          ]),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
                          
                          // restaurant name
                          buildHeadingAndField(
                              heading: AppStrings.manageRestaurantName,
                              field: CustomFormField(
                                controller: controller.restNameController,
                                textCapitalization: TextCapitalization.words,
                                validator: Validations.validations.validateName,
                                prefixIcon: Icon(Icons.person,
                                    size: SizeConfig.semiBoldFontSize,
                                    color: AppColors.colorPrimary),
                                inputAction: TextInputAction.next,
                              )),


                          // email
                          buildHeadingAndField(
                            heading: AppStrings.headingEmail,
                            field: CustomFormField(
                              controller: controller.emailController,
                              readOnly: true,
                              validator: Validations.validations.validateEmail,
                              prefixIcon: Icon(Icons.email_outlined,
                                  size: SizeConfig.semiBoldFontSize,
                                  color: AppColors.colorPrimary),
                              inputAction: TextInputAction.next,
                            )
                          ),

                          // phone
                          buildHeadingAndField(
                            heading: AppStrings.headingPhone,
                            field: CustomFormField(
                              controller: controller.phoneController,
                              validator: Validations.validations.validatePhone,
                              prefixIcon: Icon(Icons.phone,
                                  size: SizeConfig.semiBoldFontSize,
                                  color: AppColors.colorPrimary),
                              inputAction: TextInputAction.done,
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                            )
                          ),


                          // country & state
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // country
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: AppStrings.headingCountry,
                                      fontFamily: FontFamily.fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: AppColors.normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal *2),
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
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                              // state
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: AppStrings.headingState,
                                      fontFamily: FontFamily.fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: AppColors.normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    Obx(() => Container(
                                          height: SizeConfig.blockSizeHorizontal * 13.8,
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                          decoration: BoxDecoration(
                                              color: AppColors.textFieldFillColor,
                                              border: Border.all(
                                                  color: AppColors.disabledBorderColor,
                                                  width: 1.3),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(
                                                10.0,
                                              ))),
                                          child: InkWell(
                                            onTap: () async {
                                              if (controller.country.value.countryId != "0") {
                                                await controller.getState();
                                                if (context.mounted) {
                                                  showCustomBottomSheet(
                                                      context: context,
                                                      title: AppStrings.hintSelectState,
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
                                                                controller.state.value =
                                                                    controller.statesList[index].name ?? AppStrings.hintSelectState;
                                                                if (controller.stateId.value ==
                                                                    controller.statesList[index].stateId) {
                                                                  Get.back();
                                                                } else {
                                                                  controller.stateId.value =
                                                                      controller.statesList[index].stateId ?? '0';
                                                                  controller.city.value = AppStrings.hintSelectCity;
                                                                  Get.back();
                                                                }
                                                              },
                                                              title: Center(
                                                                child: TextWidget(
                                                                  text: controller.statesList[index].name ?? '',
                                                                  color: AppColors.blackShades,
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                }
                                              } else {
                                                Get.snackbar(AppStrings.alertTitle,
                                                    AppStrings.manageRestaurantSnackBarState,duration: const Duration(seconds: 2));
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
                                                      color: controller.state.value == AppStrings.hintSelectState ?
                                                      AppColors.normalTextColor : AppColors.black,
                                                    )),
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
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

                          // city & pin code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // city
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: AppStrings.hintSelectCity,
                                      fontFamily: FontFamily.fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: AppColors.normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    Obx(() => Container(
                                          height: SizeConfig.blockSizeHorizontal * 13.8,
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                          decoration: BoxDecoration(
                                              color: AppColors.textFieldFillColor,
                                              border: Border.all(
                                                  color: AppColors.disabledBorderColor,
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
                                                      title: AppStrings.hintSelectCity,
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
                                                                controller.city.value =
                                                                    controller.citiesList[index].name ?? AppStrings.hintSelectCity;
                                                                controller.cityId.value =
                                                                    controller.citiesList[index].cityId ?? '0';
                                                                Get.back();
                                                              },
                                                              title: Center(
                                                                child: TextWidget(
                                                                  text: controller.citiesList[index].name ?? '',
                                                                  color: AppColors.blackShades,
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                }
                                              } else {
                                                Get.snackbar(AppStrings.alertTitle,
                                                    AppStrings.manageRestaurantSnackBarCity,duration: const Duration(seconds: 2));
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
                                                      color: controller.city.value == AppStrings.hintSelectCity ?
                                                      AppColors.normalTextColor : AppColors.black,
                                                  )),
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
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                              // pin code
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: AppStrings.manageRestaurantPinCode,
                                      fontFamily: FontFamily.fontMedium,
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: AppColors.normalTextColor,
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeHorizontal * 2),
                                    CustomFormField(
                                      controller: controller.pinCodeController,
                                      prefixIcon: Icon(Icons.pin,
                                          size: SizeConfig.semiBoldFontSize,
                                          color: AppColors.colorPrimary),
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


                          // address
                          RichText(
                              text: TextSpan(
                                  text: AppStrings.manageRestaurantAddress,
                                  style: TextStyle(
                                      color: AppColors.normalTextColor,
                                      fontSize: SizeConfig.mediumFontSize,
                                      fontFamily: FontFamily.fontMedium),
                                  children: [
                                TextSpan(
                                    text: AppStrings.manageRestaurantAddressDesc,
                                    style: TextStyle(
                                        color: AppColors.normalTextColor,
                                        fontSize: SizeConfig.regularFontSize,
                                        fontFamily: FontFamily.fontRegular))
                              ])),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                          CustomFormField(
                            controller: controller.addressController,
                            validator: Validations.validations.validateEmptyFields,
                            inputAction: TextInputAction.next,
                            suffixIcon: InkWell(
                                onTap: controller.goToMap,
                                child: Icon(Icons.map,
                                    size: SizeConfig.semiBoldFontSize,
                                    color: AppColors.colorPrimary)),
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),


                         // opening , closing time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // opening time
                              Expanded(
                                child: buildHeadingAndField(
                              heading: AppStrings.manageRestaurantOpeningTime,
                              field: CustomFormField(
                                controller: controller.openingTimeController,
                                readOnly: true,
                                onTap: () async{
                                  await controller
                                      .openingTimePicker(context);
                                },
                                validator: (value){
                                  if((value ?? '').trim().isNotEmpty){
                                    return null;
                                  }
                                  return "Select time";
                                },
                                suffixIcon: Icon(Icons.watch_later_outlined,
                                    size: SizeConfig.semiBoldFontSize,
                                    color: AppColors.colorPrimary),
                              ))
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                              // closing time
                              Expanded(
                                child: buildHeadingAndField(
                                  heading: AppStrings.manageRestaurantClosingTime,
                                  field: CustomFormField(
                                    controller: controller.closingTimeController,
                                    readOnly: true,
                                    onTap: () async{
                                      await controller
                                          .closingTimePicker(context);
                                    },
                                    validator: (value){
                                      if((value ?? '').trim().isNotEmpty){
                                        return null;
                                      }
                                      return "Select time";
                                    },
                                    suffixIcon: Icon(Icons.watch_later_outlined,
                                        size: SizeConfig.semiBoldFontSize,
                                        color: AppColors.colorPrimary),
                                  )
                                ),
                              )
                            ],
                          ),

          
                          // average price and minimum order price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // avg price
                              Expanded(
                                child: buildHeadingAndField(
                                    heading: AppStrings.manageRestaurantAvgPrice,
                                    field: CustomFormField(
                                        controller: controller.averagePriceController,
                                        prefixIcon: Icon(Icons.currency_rupee,
                                            size: SizeConfig.mediumFontSize,
                                            color: AppColors.colorPrimary),
                                        inputAction: TextInputAction.next,
                                        onlyNumbers: true,
                                        keyboardType: TextInputType.number,
                                        hintText: "e.g. 100"),
                                )),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                              // min order price
                              Expanded(
                                child: buildHeadingAndField(
                                  heading: AppStrings.manageRestaurantMinOrderPrice,
                                  field: CustomFormField(
                                      controller: controller.minOrderPriceController,
                                      onlyNumbers: true,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icon(Icons.currency_rupee,
                                          size: SizeConfig.mediumFontSize,
                                          color: AppColors.colorPrimary),
                                      inputAction: TextInputAction.next,
                                      hintText: "e.g. 30"),
                                )),
                            ],
                          ),

          
          
                          // minimum delivery distance
                          buildHeadingAndField(
                            heading: AppStrings.manageRestaurantMinDeliveryDistance,
                            field: CustomFormField(
                                controller: controller.minDeliveryDistanceController,
                                prefixIcon: Icon(Icons.social_distance,
                                    size: SizeConfig.mediumFontSize,
                                    color: AppColors.colorPrimary),
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                allowDecimal: true,
                                hintText: "e.g. 2 km"),
                          ),
          
          
          
                          // minimum delivery charges
                          buildHeadingAndField(
                            heading: AppStrings.manageRestaurantMinDeliveryPrice,
                            field:  CustomFormField(
                                controller:
                                controller.minDeliveryChargeController,
                                prefixIcon: Icon(Icons.currency_rupee,
                                    size: SizeConfig.mediumFontSize,
                                    color: AppColors.colorPrimary),
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                allowDecimal: true,
                                hintText: "e.g. 20"),
                          ),
          
          
          
                          // charges per km
                          buildHeadingAndField(
                            heading: AppStrings.manageRestaurantChargesPerKm,
                            field: CustomFormField(
                                controller:
                                controller.chargesPerKmController,
                                prefixIcon: Icon(Icons.currency_rupee,
                                    size: SizeConfig.mediumFontSize,
                                    color: AppColors.colorPrimary),
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                allowDecimal: true,
                                hintText: "e.g. 10"),
                          ),
          
          
          
          
                          // free delivery amount
                          buildHeadingAndField(
                            heading: AppStrings.manageRestaurantFreeDeliveryAmt,
                            field:  CustomFormField(
                              controller: controller.freeDeliveryAmountController,
                              prefixIcon: Icon(Icons.currency_rupee,
                                  size: SizeConfig.semiBoldFontSize,
                                  color: AppColors.colorPrimary),
                              inputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onlyNumbers: true,
                            )
                          ),



                          // fssai no
                          buildHeadingAndField(
                              heading: AppStrings.manageRestaurantFssaiNo,
                              field:  CustomFormField(
                                controller: controller.fssaiController,
                                prefixIcon: Icon(Icons.currency_rupee,
                                    size: SizeConfig.semiBoldFontSize,
                                    color: AppColors.colorPrimary),
                                inputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                onlyNumbers: true,
                                validator: Validations.validations.validateEmptyFields,
                              )
                          ),

          
          




                          ButtonWidget(
                            text: AppStrings.btnUpdate,
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


  Widget buildHeadingAndField({
    required String heading,
    required Widget field}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          text: heading,
          fontFamily: FontFamily.fontMedium,
          fontSize: SizeConfig.mediumFontSize,
          color: AppColors.normalTextColor,
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
        field,
        SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
      ]
    );

  }
}
