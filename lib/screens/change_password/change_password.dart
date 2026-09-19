import 'package:flutter/material.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/custom_password_form_field.dart';
import '../../component/custom_text_widget.dart';
import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';
import '../../constant/app_strings.dart';
import '../../utils/size_config.dart';
import 'change_password_controller.dart';

class ChangePassword extends GetView<ChangePasswordController>{
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(title: AppStrings.passwordTitle),
      body:  SafeArea(
        child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 2,
            horizontal: SizeConfig.blockSizeHorizontal * 4),
            child: SingleChildScrollView(
            child: Form(key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeHorizontal*4),
            // old password
            TextWidget(
              text: AppStrings.passwordOld,
              fontFamily: FontFamily.fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: AppColors.normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>  CustomPasswordFormField(
                controller: controller.oldPasswordController,
              focusNode: controller.focusOldPassword,
             validator: Validations.validations.validatePassword,
             onSubmitted:  (v) {
               FocusScope.of(context)
                   .requestFocus(controller.focusNewPassword);
             },
             obscureText: controller.oldPasswordVisible.value,
                toggle: () =>
                controller.oldPasswordVisible.value =
                !controller.oldPasswordVisible.value,
              )),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 7),

            // new password
            TextWidget(
              text: AppStrings.passwordNew,
              fontFamily: FontFamily.fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: AppColors.normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>
            CustomPasswordFormField(
              focusNode: controller.focusNewPassword,
                controller: controller.newPasswordController,
              validator: (value){
                if((value ?? '').length > 5 &&
                    (value ?? '').trim() != controller.oldPasswordController.text.trim()) {
                  return null;
                } else {
                  if((value ?? '').trim() == controller.oldPasswordController.text.trim()){
                    return 'New password must be different';
                  }
                  return 'Password must have 6 characters or above.';
                }
              },
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

            // confirm password
            TextWidget(
              text: AppStrings.passwordConfirm,
              fontFamily: FontFamily.fontMedium,
              fontSize: SizeConfig.mediumFontSize,
              color: AppColors.normalTextColor,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal *5),
           Obx(() =>
            CustomPasswordFormField(
                controller: controller.confirmPasswordController,
                focusNode: controller.focusConfirmPassword,
                validator: (value){
                  if((value ?? '').trim() == controller.newPasswordController.text.trim()) {
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
              text: AppStrings.btnSubmit,
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