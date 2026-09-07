import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/screens/forgotPassword/controller/forgotPasswordController.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/TextFormFieldWidget.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_constant.dart';


class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colorWhite,
        appBar: AppBar(
        title: TextWidget(text: forgot_password_title,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,),
    elevation: 0.0,
    centerTitle: true,
    ),
    body:SafeArea(
      child: Container(
      height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(
      bottom:  SizeConfig.blockSizeHorizontal*2,
      left: SizeConfig.blockSizeHorizontal*4,
      right: SizeConfig.blockSizeHorizontal*4),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [ SizedBox(height: SizeConfig.blockSizeHorizontal*4),
            TextWidget(text: forgot_password_lbl, fontFamily: fontBold,
              fontSize: SizeConfig.boldFontSize),
            SizedBox(height: SizeConfig.blockSizeHorizontal*3),
            TextWidget(text: forgot_password_desc, fontFamily: fontMedium,color: normalTextColor,
                fontSize: SizeConfig.mediumFontSize),
        SizedBox(height: SizeConfig.blockSizeHorizontal*10),
        Form(
          key: controller.formKey,
          child: TextFormWidget(hintText: email_hint,
          controller: controller.emailController,
            validator: Validations.validations.validateEmail,
          ),
        ),
            SizedBox(height: SizeConfig.blockSizeHorizontal*8),
            ButtonWidget(text: forgot_password_btn,
                onPressed: (){controller.onClickForgotPassword();},)
      
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