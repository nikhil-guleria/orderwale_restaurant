import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/CustomRadioButton.dart';
import 'package:food_merchant/component/TextFormFieldWidget.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
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
      backgroundColor: colorWhite,
      appBar: AppBar(
          title: TextWidget(
            text: controller.argument != null ?
            updateToppingTitle : addToppingTitle,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,
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
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ]),
      body: SafeArea(
          child: controller.initialLoad.value ?
      Container(
        color: Colors.white,
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
                  text: toppingTitle,
                  fontFamily: fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  color: normalTextColor,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                TextFormWidget(
                  controller: controller.titleController,
                  textCapitalization: TextCapitalization.words,
                  validator: Validations.validations.validateEmptyFields,
                  inputAction: TextInputAction.next,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

                // price
                TextWidget(
                  text: toppingPrice,
                  fontFamily: fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  color: normalTextColor,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                TextFormWidget(
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
                      text: toppingType,
                      fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: normalTextColor,
                    ),
                    Obx(
                          () => MyRadioListTile(
                        value: "1",
                        groupValue: controller.foodType.value,
                        onChanged: (value) {
                          controller.onChangeFoodType(value!);
                        },
                        title: TextWidget(
                          text: radio_btn_veg,
                          fontSize: SizeConfig.regularFontSize,
                          color: normalTextColor,
                        ),
                      ),
                    ),
                    Obx(
                          () => MyRadioListTile(
                        value: "2",
                        groupValue: controller.foodType.value,
                        onChanged: (value) {
                          controller.onChangeFoodType(value!);
                        },
                        title: TextWidget(
                          text: radio_btn_nonVeg,
                          fontSize: SizeConfig.regularFontSize,
                          color: normalTextColor,
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
                    child: Text("Please select toppings type",
                    style: TextStyle(
                      color: Colors.red.shade900, fontSize: 12,
                    )),
                  ),
                )),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 15),



                ButtonWidget(
                  text: controller.updateTopping.value ?
                  toppingUpdateButton : toppingAddButton,
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