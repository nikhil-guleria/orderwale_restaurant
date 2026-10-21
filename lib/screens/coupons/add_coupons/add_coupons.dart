import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/color_loader.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/validations.dart';
import 'package:get/get.dart';
import 'add_coupons_controller.dart';


class AddCoupons extends GetView<AddCouponsController> {
  const AddCoupons({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: TextWidget(text:
          controller.couponsData != null  ?
          AppStrings.couponUpdateTitle : AppStrings.couponAddTitle,
            color: AppColors.blackText,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: FontFamily.fontSemiBold,
            fontWeight: FontWeight.w600,),
          actions: [
            Visibility(
              visible: controller.couponsData != null,
              child: Padding(
                padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                child: IconButton(
                  onPressed: () {
                    controller.deleteCouponClick();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.red,
                  ),
                ),
              ),
            )
          ]
      ),

      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeHorizontal * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image
                  Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9)
                        ),
                        height: SizeConfig.blockSizeHorizontal * 55,
                        width: Get.width,
                        child: Obx(()=>
                        controller.imageFile.value != null ?
                        ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.file(controller.imageFile.value!,
                                fit: BoxFit.cover))
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: CachedNetworkImage(
                              height: SizeConfig.blockSizeHorizontal * 55,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: controller.couponsData?.thumbnailUrl ?? '' ,
                              placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                            )
                        )
                        )
                    ),


                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.25,
                          bottom: SizeConfig.blockSizeHorizontal*1.25),
                      decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          border: Border.all(color: AppColors.white, width: 2.5),
                          borderRadius: const BorderRadius.all(Radius.circular(
                            10.0,
                          ))),
                      height: SizeConfig.blockSizeHorizontal * 10,
                      width: SizeConfig.blockSizeHorizontal * 10,
                      child: Center(
                        child: InkWell(
                            onTap: controller.pickImage,
                            child: Icon(
                              (controller.couponsData?.image ?? '').trim().isNotEmpty ?
                              Icons.edit : Icons.add,
                              color: AppColors.white,
                              size: SizeConfig.blockSizeHorizontal * 6.2,
                            )),
                      ),
                    )]),
                  Obx(()=> Visibility(
                    visible: controller.showImageError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text(AppStrings.errorSelectImage,
                          style: TextStyle(
                            color: AppColors.red.shade900,
                            fontSize: 12,
                          )),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 7),

                  // coupon code
                  TextWidget(
                    text: AppStrings.couponCode,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  CustomFormField(
                    controller: controller.couponCodeController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [UpperCaseTextFormatter()],
                    validator: Validations.validations.validateCouponCode,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // description
                  TextWidget(
                    text: AppStrings.headingDescription,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  CustomFormField(
                    controller: controller.descriptionController,
                    validator: Validations.validations.validateCouponDescription,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [CapitalizeEachWordFormatter()],
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // start & end date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // start date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponStartDate,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              controller: controller.startDateController,
                              readOnly: true,
                              suffixIcon: Icon(Icons.date_range),
                              validator: Validations.validations.fieldCantEmpty,
                              onTap: () async {
                                await controller.startDatePicker(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                      // end date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponEndDate,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              controller: controller.endDateController,
                              readOnly: true,
                              validator: Validations.validations.fieldCantEmpty,
                              onTap: () async {
                                await controller.endDatePicker(context);
                              },
                              suffixIcon: Icon(Icons.date_range),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // usage time & discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // usage time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponUsage,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              validator: Validations.validations.validateCoupon,
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              controller: controller.usageController,
                              inputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                      // discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponDiscount,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              validator: Validations.validations.fieldCantEmpty,
                              keyboardType:  TextInputType.number,
                              onlyNumbers: true,
                              controller: controller.discountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // discount type
                  TextWidget(
                    text: AppStrings.couponDiscountType,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Obx(()=>  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.disabledBorderColor,
                            width: 1.0
                        )
                    ),
                    padding: const EdgeInsets.all(1),
                    child: RadioGroup(
                      groupValue: controller.discountType.value,
                      onChanged: (value) {
                        if(value != null){
                        controller.onChangeDiscountType(value);}
                      },
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: RadioListTile(
                                dense: true,
                                radioScaleFactor: 0.9,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                value: "0",
                                activeColor: AppColors.colorPrimary,
                                title: TextWidget(text: AppStrings.btnRadioFlat,
                                  color: AppColors.normalTextColor,)
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: RadioListTile(
                                value: "1",
                                dense: true,
                                radioScaleFactor: 0.9,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                activeColor: AppColors.colorPrimary,
                                title: TextWidget(text: AppStrings.btnRadioPercentage,
                                  color: AppColors.normalTextColor,)
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  Obx(()=> Visibility(
                    visible: controller.showDiscountError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text(AppStrings.errorSelectDiscountType,
                          style: TextStyle(
                            color: AppColors.red.shade900,
                            fontSize: 12,
                          )),
                    ),
                  )),

                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),

                  // min & max discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // min discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponMinDiscount,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              validator: (value){
                                if(controller.discountType.trim() == "1" ||
                                    controller.discountType.trim().isEmpty ||
                                    (num.tryParse(controller.discountController.text) ?? 0)<= 0 ||
                                    (num.tryParse(value ?? '0') ?? 0) > 0
                                ){
                                  return null;
                                }
                                return "greater than 0";
                              },
                              keyboardType:  TextInputType.number,
                              onlyNumbers: true,
                              controller: controller.minDiscountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),


                      // max discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: AppStrings.couponMaxDiscount,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              validator: (value){
                                if(controller.discountType.trim() == "0" ||
                                    controller.discountType.trim().isEmpty ||
                                    (num.tryParse(controller.discountController.text) ?? 0)<= 0 ||
                                    (num.tryParse(value ?? '0') ?? 0) > 0
                                    ){
                                  return null;
                                }
                                return "greater than 0";
                              },
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              controller: controller.maxDiscountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),



                    ],
                  ),


                  SizedBox(height: SizeConfig.blockSizeHorizontal * 11),
                  ButtonWidget(
                    text:
                    controller.couponsData != null  ?
                    AppStrings.btnUpdate : AppStrings.btnAdd,
                    onPressed: controller.couponsData != null ?
                    controller.updateCouponClick : controller.addCouponClick
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),






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