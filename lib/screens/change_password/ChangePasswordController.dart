
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../component/DialogBox.dart';
import '../../constant/string_constants.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';

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

  checkValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
        changePasswordProcess();
    }
  }

  changePasswordProcess() async{
    var storage = GetStorage();
    var userData = storage.read(GetStorageConstants.LOGIN_DATA);
   var  param = {
      'old_password': oldPasswordController.text,
      'new_password': confirmPasswordController.text,
      'owner_id': "${userData["id"]}"
    };
    showLoader.value = true;
    var changePassword = await ApiController().changePassword(param);
    showLoader.value = false;
    if (changePassword.responseCode == 1) {
      Get.dialog(PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop,_){
          if(didPop) {
            return ;
          } else {
            Get.close(2);
          }
        },
        child: showDialogBox(title: change_password_title,
          message: password_changed,
          twoButtons: false,
          onConfirm: (){Get.close(2);}),
      ),
      barrierDismissible: false);
    }
    else {
      CommonUtils.utils.handleApiError(
          changePassword.responseCode, changePassword.msg);
    }
  }


  }
