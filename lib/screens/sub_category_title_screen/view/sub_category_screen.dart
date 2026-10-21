import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/screens/sub_category_title_screen/controller/sub_category_controller.dart';
import 'package:food_merchant/utils/validations.dart';
import 'package:get/get.dart';

import '../../../component/color_loader.dart';
import '../../../component/custom_form_field.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';

class SubCategoryScreen extends GetView<SubCategoryController> {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(title: AppStrings.subcategoryAppBarTitle),
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
              // menu title
              TextWidget(
                text: AppStrings.subcategoryMenuTitle,
                fontFamily: FontFamily.fontMedium,
                fontSize: SizeConfig.mediumFontSize,
                color: AppColors.normalTextColor,
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal*5),
              Form( key: controller.formKey,
                child: CustomFormField(
                  hintText: AppStrings.hintSubcategoryTitle,
                  controller: controller.titleController,
                  validator: Validations.validations.validateTitle,
                  inputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeHorizontal*9),
              ButtonWidget(
                  text: AppStrings.btnSubmit,
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