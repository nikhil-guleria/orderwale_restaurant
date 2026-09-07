import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/screens/sub_category_title_screen/controller/sub_category_controller.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';

import '../../../component/ColorLoader.dart';
import '../../../component/TextFormFieldWidget.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';

class SubCategoryScreen extends GetView<SubCategoryController> {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: TextWidget(text: subCategoryAppTitle,
        color: Colors.black,
        fontSize: SizeConfig.appbarTitleSize,
        fontFamily: fontSemiBold,
        weight: FontWeight.w600,),
    elevation: 0.0,
    centerTitle: true),
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.only(
            bottom:  SizeConfig.blockSizeHorizontal*2,
            left: SizeConfig.blockSizeHorizontal*3,
            right: SizeConfig.blockSizeHorizontal*3 ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: subCategoryMenuTitle,
                fontFamily: fontMedium,
                fontSize: SizeConfig.mediumFontSize,
                color: normalTextColor,
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal*5),
              Form( key: controller.formKey,
                child: TextFormWidget(
                  hintText: subCategoryHint,
                  controller: controller.titleController,
                  validator: Validations.validations.validateEmptyFields,
                  inputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeHorizontal*9),
              ButtonWidget(
                  text: subCategoryButton,
                  onPressed: (){
                    controller.submitBtnClick();
                  })


            ],
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