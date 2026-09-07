import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:get/get.dart';
import '../constant/app_color.dart';
import 'SizeConfig.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }



  void _updateConnectionStatus(List<ConnectivityResult> result) async {

    if (result.contains(ConnectivityResult.none)) {
      Get.dialog(PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: colorWhite,
          surfaceTintColor: colorWhite,
          title:   Text("OrderWale",
            style: TextStyle(fontFamily: fontMedium,
                fontSize: SizeConfig.mediumFontSize,
                fontWeight: FontWeight.bold,
                color: colorBlack)),
          content:   Text('PLEASE CONNECT TO THE INTERNET', style: TextStyle(
              fontFamily: fontMedium,
              fontSize: SizeConfig.regularFontSize,
              color: redBackground
          ),),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary,
                padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: colorPrimary),
              ),
              onPressed: () {
                Get.back(result:  "checkConnectivity");
              },
              child:  Text('OK',
                style: TextStyle(fontFamily: fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: colorPrimary),),
            ),
          ],
        ),
      ),
          barrierDismissible: false).then((value) {
        if(value == "checkConnectivity"){
          checkInitialConnectivity();
        }});
    } else {
      bool? isDialogOpen = Get.isDialogOpen;
      if (isDialogOpen != null && isDialogOpen) {
        Get.back();
       /* if(GlobalVariables.token.value != "") {
          Get.back();
        } else {
          print("from Network");
          await PushNotificationService.registerNotification();
          Get.offAllNamed(Routes.USER_LOGIN);
        }*/
      }
    }
  }

  checkInitialConnectivity() async {
   /// var result = await  _connectivity.checkConnectivity();


    bool result = await   hasConnection();


    if(!result){
      Get.dialog(PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: colorWhite,
          surfaceTintColor: colorWhite,
          title:   Text("OrderWale",
            style: TextStyle(fontFamily: fontMedium,
                fontSize: SizeConfig.mediumFontSize,
                fontWeight: FontWeight.bold,
                color: colorBlack)),
          content:   Text('PLEASE CONNECT TO THE INTERNET', style: TextStyle(
              fontFamily: fontMedium,
              fontSize: SizeConfig.regularFontSize,
              color: redBackground
          ),),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary,
                padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: colorPrimary),
              ),
              onPressed: () {
                Get.back(result:  "checkConnectivity");
              },
              child:  Text('OK',
                  style: TextStyle(fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: colorPrimary)),
            ),
          ],
        ),
      ),
          barrierDismissible: false).then((value) {
        print(value);
        if(value == "checkConnectivity"){
          checkInitialConnectivity();
        }});
    }
  }



  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

}