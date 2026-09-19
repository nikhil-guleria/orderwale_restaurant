import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';


class ForgotPasswordController extends GetxController {
  var showLoader = false.obs;
  final emailController =  TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> onClickForgotPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (formKey.currentState?.validate() ?? false) {
        showLoader.value = true;
        var param = {'email': emailController.text};
        var userModel = await ApiController().forgotPassword(param);
        showLoader.value = false;
        if (userModel.responseCode == AppStrings.apiSuccess) {
          emailController.clear();
          CommonUtils.utils.handleAlertMsg(
              title: AppStrings.alertSuccess,
              message: userModel.msg);
        } else {
          CommonUtils.utils.handleAlertMsg(
              code: userModel.responseCode,
              message: userModel.msg);
        }
      }
    } catch (e){
      showLoader.value = false;
    }

  }
}
