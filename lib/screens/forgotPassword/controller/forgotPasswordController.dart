import 'package:flutter/material.dart';
import 'package:food_merchant/component/DialogBox.dart';
import 'package:get/get.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';


class ForgotPasswordController extends GetxController {
  var showLoader = false.obs;
  final emailController =  TextEditingController();
  final formKey = GlobalKey<FormState>();

  onClickForgotPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      showLoader.value = true;
      var param = {'email': emailController.text};
      var userModel = await ApiController().forgotPassword(param);
      showLoader.value = false;
      if (userModel.responseCode == 1) {
        Get.dialog(PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            } else {
              Get.close(2);
            }
          },
          child: showDialogBox(title: 'Email Sent',
            message: userModel.msg,
            twoButtons: false,
            onConfirm: () {
              Get.close(2);
            },
          ),
        ),
            barrierDismissible: false);
      } else {
        CommonUtils.utils.handleApiError(userModel.responseCode, userModel.msg);
      }
    }

  }
}
