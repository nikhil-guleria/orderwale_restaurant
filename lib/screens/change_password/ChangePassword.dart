import 'package:flutter/material.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/PasswordTextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'ChangePasswordController.dart';

class ChangePassword extends GetView<ChangePasswordController>{
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
          title: TextWidget(text: change_password_title,
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: fontSemiBold,
          weight: FontWeight.w600,),
          elevation: 0.0,
      centerTitle: true,),
      body:  SafeArea(
        child: Container(
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
            SizedBox(height: SizeConfig.blockSizeHorizontal*4),
            TextWidget(
              text: old_password,
              fontFamily: fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>  PasswordTextFormWidget(
                controller: controller.oldPasswordController,
              focusNode: controller.focusOldPassword,
             validator: Validations.validations.validatePassword,
             onSubmitted:  (v) {
               FocusScope.of(context)
                   .requestFocus(controller.focusNewPassword);
             },
             obscureText:
                controller.oldPasswordVisible.value,
                toggle: () =>
                controller.oldPasswordVisible.value =
                !controller.oldPasswordVisible.value,
              )),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
            TextWidget(
              text: new_password,
              fontFamily: fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>
            PasswordTextFormWidget(
              focusNode: controller.focusNewPassword,
                controller: controller.newPasswordController,
              validator: Validations.validations.validatePassword,
              onSubmitted:  (v) {
                FocusScope.of(context)
                    .requestFocus(controller.focusConfirmPassword);
              },
                obscureText:
                controller.newPasswordVisible.value,
                toggle: () =>
                controller.newPasswordVisible.value =
                !controller.newPasswordVisible.value,
                )),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
            TextWidget(
              text: confirm_password,
              fontFamily: fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>
            PasswordTextFormWidget(
                controller: controller.confirmPasswordController,
                focusNode: controller.focusConfirmPassword,
                validator: (value){
                  if(value == controller.newPasswordController.text) {
                    return null;
                  } else {
                    return 'Passwords do not match';
                  }
                },
                obscureText:
                controller.confirmPasswordVisible.value,
                toggle: () =>
                controller.confirmPasswordVisible.value =
                !controller.confirmPasswordVisible.value,
                )),
            SizedBox(height: SizeConfig.blockSizeHorizontal *9),
            ButtonWidget(
              text: change_password_btn,
              onPressed: () {
                controller.checkValidations();
              },
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          ],
        ),
            ),
        
            )),
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