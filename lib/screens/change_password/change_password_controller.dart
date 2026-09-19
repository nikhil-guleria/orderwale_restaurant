import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/app_strings.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';


class ChangePasswordController extends GetxController{
  var showLoader = false.obs;
  var oldPasswordVisible = true.obs;
  var newPasswordVisible = true.obs;
  var confirmPasswordVisible = true.obs;
  final focusOldPassword = FocusNode();
  final focusNewPassword = FocusNode();
  final focusConfirmPassword = FocusNode();
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void checkValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
        changePasswordProcess();
    }
  }

  Future<void> changePasswordProcess() async {
    try {
      var param = {
        'old_password': oldPasswordController.text.trim(),
        'new_password': confirmPasswordController.text.trim(),
      };
      showLoader.value = true;
      var changePassword = await ApiController().restaurantChangeUserPassword(
          param);
      showLoader.value = false;
      if (changePassword.responseCode == AppStrings.apiSuccess) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        CommonUtils.utils.handleAlertMsg(
            title: AppStrings.alertSuccess,
            message: changePassword.msg);
      }
      else {
        CommonUtils.utils.handleAlertMsg(
           code:  changePassword.responseCode,
           message:  changePassword.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


  }
