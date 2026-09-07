
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/TextWidget.dart';
import '../constant/app_color.dart';
import '../constant/app_constant.dart';
import 'SizeConfig.dart';

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
        backgroundColor: colorWhite,
        surfaceTintColor: colorWhite,
        title:  TextWidget(text: "Permission Denied",color: colorBlack,
          weight: FontWeight.bold,
          fontFamily: fontMedium,fontSize: SizeConfig.mediumFontSize,),
        content:  TextWidget(text: "To Enable camera permission Go To Settings > Permissions > Enable Camera Permission",
            fontFamily: fontMedium,fontSize: SizeConfig.regularFontSize,
            color: Colors.black54),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorPrimary,
              padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
              textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: colorPrimary),
            ),
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: Text("Go To Settings",
                style: TextStyle(fontFamily: fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: colorPrimary)),
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