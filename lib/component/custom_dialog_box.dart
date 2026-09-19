import 'package:flutter/material.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../constant/app_colors.dart';


 Widget showDialogBox({
   String? title,
   String? message,
   VoidCallback? onConfirm,
   VoidCallback? onCancel,
   String? cancelTxt,
   String? confirmTxt,
   bool twoButtons = false,
 }) {
        return AlertDialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17))),
          title: Text( title ?? AppStrings.alertTitle,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: FontFamily.fontMedium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText)),
          content: Text(message ?? '', style: TextStyle(
            fontFamily: FontFamily.fontMedium,
            fontSize: 16)),
          actions: <Widget>[
            Visibility(
              visible: twoButtons,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.colorPrimary,
                  padding:  EdgeInsets.all(12),
                  textStyle:  TextStyle(
                      fontFamily: FontFamily.fontMedium,
                      fontSize: 18,
                      color: AppColors.stormGrey),
                ),
                onPressed: (){
                 Get.back();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                child:  Text(cancelTxt ?? 'Cancel',
                    style:  TextStyle(
                        fontSize: 18,
                        fontFamily: FontFamily.fontMedium,
                        color: AppColors.stormGrey)),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor:  AppColors.colorPrimary,
                padding:  EdgeInsets.all(12),
                textStyle:  TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily.fontMedium,
                    color: AppColors.colorPrimary),
              ),
              onPressed: (){
                Get.back();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              child:  Text(confirmTxt ?? 'Ok',
                  style:  TextStyle(
                      fontSize: 18,
                      fontFamily: FontFamily.fontMedium,
                      color: AppColors.colorPrimary)),
            ),
          ],
        );
}