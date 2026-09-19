
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/custom_text_widget.dart';
import '../constant/app_colors.dart';
import '../constant/font_family.dart';
import 'size_config.dart';

class RunTimePermissions {
  static final RunTimePermissions permissions = RunTimePermissions._internal();

  factory RunTimePermissions() {
    return permissions;
  }
  RunTimePermissions._internal();



   checkPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.camera.request();
    }

    if (status == PermissionStatus.permanentlyDenied) {
      await  Get.dialog(AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title:  TextWidget(text: "Permission Denied",color: AppColors.blackText,
          fontWeight: FontWeight.bold,
          fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.mediumFontSize,),
        content:  TextWidget(text: "To Enable camera permission Go To Settings > Permissions > Enable Camera Permission",
            fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.regularFontSize,
            color: Colors.black54),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.colorPrimary,
              padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
              textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: AppColors.colorPrimary),
            ),
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: Text("Go To Settings",
                style: TextStyle(fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.colorPrimary)),
          ),
        ],
      ));
      return false;
    }
    if(status != PermissionStatus.granted) {
      return false;
    }
    if (status == PermissionStatus.granted) {
      return true;
    }
}









}