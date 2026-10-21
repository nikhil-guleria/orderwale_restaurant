import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/custom_password_form_field.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/login/controller/login_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:food_merchant/utils/validations.dart';
import 'package:get/get.dart';
import '../../../component/color_loader.dart';
import '../../../component/custom_form_field.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';
import '../../../component/custom_text_widget.dart';


class MobileLoginScreen extends GetView<LoginController> {
  const MobileLoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    CommonUtils.utils.statusBarColored();
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: buildAppBar(title: AppStrings.loginTitle,
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
              bottom:  SizeConfig.padding8,
              left: SizeConfig.padding16,
              right: SizeConfig.padding16),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // welcome
                  TextWidget(text: AppStrings.welcome,
                      fontFamily: FontFamily.fontBold,
                      fontSize: SizeConfig.semiboldTextSize),
                  SizeConfig.verticalSpace12,

                  // login description
                  TextWidget(text: AppStrings.loginDesc,
                      color: AppColors.normalTextColor,),
                  SizeConfig.verticalSpace40,


                 // email field
                  CustomFormField(
                    controller: controller.emailController,
                    onSubmitted:  (v) {
                      FocusScope.of(context)
                          .requestFocus(controller.focusPassword);
                    },
                    focusNode: controller.focusEmailPassword,
                    validator: Validations.validations.validateEmail,
                    hintText: AppStrings.headingEmail,
                    inputAction: TextInputAction.next,),
                  SizeConfig.verticalSpace24,


                 // password field
                 Obx(() =>  CustomPasswordFormField(controller: controller.passwordController,
                    focusNode: controller.focusPassword,
                    validator: Validations.validations.validatePassword,
                      obscureText:
                      controller.visiblePassword.value,
                      toggle: () =>
                      controller.visiblePassword.value =
                      !controller.visiblePassword.value,
                    hintText: AppStrings.headingPassword)),
                  SizeConfig.verticalSpace28,


                  // forgot password
                  Align(alignment: Alignment.topRight,
                  child: InkWell( onTap: controller.forgotPasswordClick,
                      highlightColor: AppColors.transparent,
                      splashColor: AppColors.transparent,
                      child: TextWidget(
                          text: "${AppStrings.forgotPasswordLbl}?",
                          color:AppColors.blackShades ,
                          fontSize: SizeConfig.regularTextSize))),
                  SizeConfig.verticalSpace28,

                  // login btn
                  ButtonWidget(
                    text: AppStrings.btnLogin,
                    onPressed: controller.loginUser
                  ),
                  SizeConfig.verticalSpace24,


                  // create new account
                  Padding( padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
                    child: RichText(
                        text: TextSpan(
                            text: AppStrings.loginHaveAccount,
                            style: TextStyle(color: AppColors.normalTextColor,
                                fontSize: SizeConfig.regularTextSize,
                                fontFamily: FontFamily.fontMedium),
                            children: [
                              TextSpan(
                                text: AppStrings.loginCreateAccount,
                                     style:TextStyle(
                                      color: AppColors.colorPrimary,
                                      fontSize: SizeConfig.regularTextSize,
                                      fontFamily: FontFamily.fontMedium),
                              recognizer: TapGestureRecognizer()..onTap = controller.createAccountClick)
                              ])),
                  ),
                  SizeConfig.verticalSpace8,
        
                ],
              ),
            ),
          )
        ),
      ));

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


