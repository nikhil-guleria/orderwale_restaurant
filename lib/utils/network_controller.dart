import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:get/get.dart';
import '../constant/app_colors.dart';
import 'size_config.dart';

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
      _showNoInternetDialog();
    } else {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  void checkInitialConnectivity() async {
    final hasInternet = await hasConnection();
    if (!hasInternet) _showNoInternetDialog();
  }

  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(PopScope(
        canPop: false,
        child: AlertDialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          title:  Text(AppStrings.alertTitleNoConnection,
              style: TextStyle(fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.appbarTitleSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redBackground)),
          content:  Text(AppStrings.alertMsgConnectInternet,
              style: TextStyle(
                fontFamily: FontFamily.fontMedium,
                fontSize: SizeConfig.mediumTextSize,)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorPrimary,
                padding:  EdgeInsets.all(15),
                textStyle:  TextStyle(fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.regularFontSize,
                    color: AppColors.colorPrimary),
              ),
              onPressed: () {
                Get.back(result:  "checkConnectivity");
              },
              child: Text(AppStrings.btnOk,
                  style:  TextStyle(fontFamily: FontFamily.fontMedium,
                      fontSize: SizeConfig.mediumTextSize,
                      color: AppColors.colorPrimary)),
            ),
          ],
        ),
      ),
          barrierDismissible: false).then((value) {
        if(value == "checkConnectivity"){
          checkInitialConnectivity();
        }});
    }
  }
}