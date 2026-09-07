import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/PasswordTextFormFieldWidget.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/screens/login/controller/login_controller.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/TextFormFieldWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/string_constants.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/SizeConfig.dart';
import '../../../component/TextWidget.dart';


class MobileLoginScreen extends GetView<LoginController> {
  const MobileLoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    CommonUtils.utils.statusBarColored();
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: TextWidget(text: login,
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: fontSemiBold,
          weight: FontWeight.w600,),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
              bottom:  SizeConfig.blockSizeHorizontal*2,
              left: SizeConfig.blockSizeHorizontal*4,
              right: SizeConfig.blockSizeHorizontal*4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.blockSizeHorizontal*4),
                  TextWidget(text: lbl_welcom, fontFamily: fontBold,
                      fontSize: SizeConfig.boldFontSize),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                  TextWidget(text: login_desc, fontFamily: fontMedium,color: normalTextColor,
                      fontSize: SizeConfig.mediumFontSize),
        
                  SizedBox(height: SizeConfig.blockSizeHorizontal*12),
                  TextFormWidget(controller: controller.emailController,
                    onSubmitted:  (v) {
                      FocusScope.of(context)
                          .requestFocus(controller.focusPassword);
                    },
                    focusNode: controller.focusEmailPassword,
                    validator: Validations.validations.validateEmail,
                    hintText: email_hint,inputAction: TextInputAction.next,),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*6),
                 Obx(() =>  PasswordTextFormWidget(controller: controller.passwordController,
                    focusNode: controller.focusPassword,
                    validator: Validations.validations.validatePassword,
                      obscureText:
                      controller.visiblePassword.value,
                      toggle: () =>
                      controller.visiblePassword.value =
                      !controller.visiblePassword.value,
                    hintText: password_hint)),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*7.6),
                  Align(alignment: Alignment.topRight,
                  child: InkWell( onTap: (){
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.toNamed(Routes.FORGOT_PASSWORD);},
                      child: TextWidget(
                          text: forgot_password,color:blackShades ,
                          fontSize: SizeConfig.blockSizeHorizontal*4))),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*12),
                 ButtonWidget(text: btnLogin,fontFamily: fontMedium,
        
                   onPressed: (){
                     controller.loginUser();
                   },
                 ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                  Padding( padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
                    child: RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: TextStyle(color: normalTextColor,
                                fontSize: SizeConfig.mediumFontSize,
                                fontFamily: fontMedium),
                            children: [
                              TextSpan(
                                text:  ' Create Account',
                                     style:TextStyle(
                                      color: colorPrimary,
                                      fontSize: SizeConfig.mediumFontSize,
                                      fontFamily: fontMedium),
                              recognizer: TapGestureRecognizer()..onTap = (){
                                FocusManager.instance.primaryFocus?.unfocus();
                                Get.toNamed(Routes.NEW_USER);
                              })
                              ])),
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*2),
        
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


