import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/CustomRadioButton.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import 'add_update_topping_controller.dart';

class AddUpdateTopping extends GetView<AddUpdateToppingController> {
  const AddUpdateTopping({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =
    Obx(() =>
    Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          title: TextWidget(
            text: controller.argument != null ?
            AppStrings.toppingsUpdateTitle : AppStrings.toppingsAddTitle,
            color: AppColors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: FontFamily.fontSemiBold,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            Visibility(
              visible: controller.updateTopping.value,
              child: Padding(
                padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                child: IconButton(
                  onPressed: () {
                    controller.deleteToppingClick();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.red,
                  ),
                ),
              ),
            )
          ]),
      body: SafeArea(
          child: controller.initialLoad.value ?
      Container(
        color: AppColors.white,
        child: Center(
          child: ColorLoader(),
        ),
      )
      
      
      :  Container(
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
                // title
                TextWidget(
                  text: AppStrings.headingTitle,
                  fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  color: AppColors.normalTextColor,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                CustomFormField(
                  controller: controller.titleController,
                  textCapitalization: TextCapitalization.words,
                  validator: Validations.validations.validateTitle,
                  inputAction: TextInputAction.next,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

                // price
                TextWidget(
                  text: AppStrings.toppingsPrice,
                  fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  color: AppColors.normalTextColor,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                CustomFormField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  onlyNumbers: true,
                  validator: Validations.validations.validateEmptyFields,
                  inputAction: TextInputAction.next,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

                // topping type
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: AppStrings.toppingsType,
                      fontFamily: FontFamily.fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: AppColors.normalTextColor,
                    ),
                    Obx(
                          () => MyRadioListTile(
                        value: "1",
                        groupValue: controller.foodType.value,
                        onChanged: (value) {
                          controller.onChangeFoodType(value);
                        },
                        title: TextWidget(
                          text: AppStrings.btnRadioVeg,
                          fontSize: SizeConfig.regularFontSize,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                    ),
                    Obx(
                          () => MyRadioListTile(
                        value: "2",
                        groupValue: controller.foodType.value,
                        onChanged: (value) {
                          controller.onChangeFoodType(value);
                        },
                        title: TextWidget(
                          text: AppStrings.btnRadioNonVeg,
                          fontSize: SizeConfig.regularFontSize,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

               Obx(()=> Visibility(
                  visible: controller.showFoodError.value,
                  child: Padding(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                    top: SizeConfig.blockSizeHorizontal*1),
                    child: Text(AppStrings.errorSelectToppingType,
                    style: TextStyle(
                      color: AppColors.red.shade900, fontSize: 12,
                    )),
                  ),
                )),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 15),



                ButtonWidget(
                  text: controller.updateTopping.value ?
                  AppStrings.toppingsUpdateTitle : AppStrings.toppingsAddTitle,
                  onPressed: () {
                    controller.addUpdateClick();
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

              ]
            )
          )
        )
      )
    )));


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