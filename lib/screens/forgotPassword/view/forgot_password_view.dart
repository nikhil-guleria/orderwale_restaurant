import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/forgotPassword/controller/forgot_password_controller.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/custom_form_field.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/font_family.dart';


class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        appBar: buildAppBar(title: AppStrings.forgotPasswordTitle),
    body:SafeArea(
      child: Container(
      height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(
      bottom:  SizeConfig.padding8,
      left: SizeConfig.padding16,
      right: SizeConfig.padding16),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // forgot password lbl
            TextWidget(text: AppStrings.forgotPasswordLbl,
                fontFamily: FontFamily.fontBold,
              fontSize: SizeConfig.semiboldTextSize),
            SizeConfig.verticalSpace12,

           // forgot password description
            TextWidget(text: AppStrings.forgotPasswordDesc,
                color: AppColors.normalTextColor),
        SizeConfig.verticalSpace40,


        // email field
        Form(
          key: controller.formKey,
          child: CustomFormField(
            hintText: AppStrings.headingEmail,
            controller: controller.emailController,
            validator: Validations.validations.validateEmail,
          ),
        ),
            SizeConfig.verticalSpace28,


            ButtonWidget(text: AppStrings.btnResetPassword,
                onPressed:controller.onClickForgotPassword,
            ),
            SizeConfig.verticalSpace24,
          ],
        ),
      ),
      
      
      
      ),
    )  );

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