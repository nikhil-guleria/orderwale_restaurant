import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart';
import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/size_config.dart';


class DeliveryAreaController extends GetxController {
  Completer<GoogleMapController> mapIdController = Completer();
  final showLoader = false.obs;
  final initialLatLng = const LatLng(AppStrings.hpLatitude,
      AppStrings.hpLongitude).obs;
  final alreadyExists = false.obs;
  final resetArea = false.obs;
  final deliveryArea = <LatLng>[].obs;
  final previousAreaList = <LatLng>[].obs;
  final tapPoints = <LatLng>[].obs;



  @override
  void onClose() {
    super.onClose();
    disposeMapController();
  }


  void updateMapController(GoogleMapController controller) {
    mapIdController.complete(controller);
  }

  void disposeMapController(){
    if (mapIdController.isCompleted) {
      mapIdController.future.then((controller) => controller.dispose());
    }
  }


   Future<void> getUserLocation() async {
    lc.Location location = lc.Location();
    bool serviceEnabled;
    lc.PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == lc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (permissionGranted == lc.PermissionStatus.deniedForever) {
      await Get.dialog(PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _){
          if(didPop) {
            return ;
          } else {
            disposeMapController();
            Get.back();
          }
        },
        child: AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: Text("Permission Denied",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText)
          ),
          content: Text(
              "To Enable location permission Go To Settings > Permissions > Enable Location Permission",
              style: TextStyle(fontFamily: FontFamily.fontMedium,
                fontSize: SizeConfig.regularFontSize,)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorPrimary,
                padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: AppColors.colorPrimary),
              ),
              onPressed: () {
                openAppSettings();
                disposeMapController();
                Get.back();
              },
              child: Text("Go To Settings",
                  style: TextStyle(fontFamily: FontFamily.fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: AppColors.colorPrimary)),
            ),
          ],
        ),
      ));

    }

    if(permissionGranted != lc.PermissionStatus.granted) {
      disposeMapController();
      Get.back();
      return;
    }

    if (permissionGranted == lc.PermissionStatus.granted) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (serviceEnabled) {
        fetchDeliveryArea();
      }
      if (!serviceEnabled) {
        disposeMapController();
        Get.back();
        return;
      }
    }

  }

  Future<void> fetchDeliveryArea({bool loader = true}) async {
    try {
      if(loader){
        showLoader.value = true;}
      var apiResult = await ApiController().restaurantDeliveryArea();
      showLoader.value = false;
      if (apiResult.responseCode == AppStrings.apiSuccess) {
        String stringArea = apiResult.response?.data["locations"] ?? "";
        if (stringArea.trim().isNotEmpty) {
          List<LatLng> tempList = stringArea.split(',').map((coordinatePair) {
            List<String> parts = coordinatePair.trim().split(' ');
            double latitude = double.parse(parts[0]);
            double longitude = double.parse(parts[1]);
            return LatLng(latitude, longitude);
          }).toList();

              alreadyExists.value =  true;
              previousAreaList.value = List<LatLng>.from(tempList);
              deliveryArea.value = List<LatLng>.from(tempList);
              tapPoints.value = [];
          if(!loader) {
            return;
          }
          double latitude = double.tryParse(apiResult.response?.data["latitude"] ?? '0') ?? 0;
          double longitude = double.tryParse(apiResult.response?.data["longitude"] ?? "0") ?? 0;
          final GoogleMapController controller = await mapIdController.future;
          if(latitude > 0 && longitude > 0){
            controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(latitude, longitude),13.25));
          } else {
            controller.animateCamera(CameraUpdate.newLatLngZoom(tempList.first,13.25));
          }

        } else {
          alreadyExists.value = false;
        }
      }
      else {
        if(apiResult.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        } else{
          CommonUtils.utils.handleAlertMsg(
            code: apiResult.responseCode,
            message: apiResult.msg,
          );
        }
      }
    } catch (e) {
      showLoader.value = false;
      debugPrint('fetching delivery area exception: $e');
    }
  }


  void addTapPoint(LatLng point) {
    tapPoints.add(point);
    tapPoints.refresh();
  }

  Set<Polyline> previousPolyLine(){
    final Set<Polyline> polyLines = {};
    polyLines.add(
      Polyline(
        polylineId: const PolylineId('polylinePrevious'),
        color: AppColors.red,
        points: previousAreaList,
        width: 3,
      ),
    );
    return polyLines;
  }


  Set<Polyline> createPolyLines() {
    final Set<Polyline> polyLines = {};
    if (tapPoints.length > 1) {
      polyLines.add(
        Polyline(
          polylineId: const PolylineId('polyline'),
          color: AppColors.red,
          points: tapPoints,
          width: 3,
        ),
      );
    }
    return polyLines;
  }

  void removePolyLine(){
    if(tapPoints.isNotEmpty) {
      tapPoints.removeLast();
      tapPoints.refresh();
    } else {
      if(deliveryArea.isNotEmpty) {
        resetArea.value = true;
      }
    }
  }

  void clearPreviousArea(){
        previousAreaList.clear();
        previousAreaList.refresh();
        alreadyExists.value = false;
        resetArea.value = true;
  }

  void resetPreviousArea(){
        resetArea.value = false;
        alreadyExists.value = true;
        previousAreaList.value = List<LatLng>.from(deliveryArea);
        previousAreaList.refresh();
  }



  Future<void> submitBtnClick() async {
    try {
      if(previousAreaList.isNotEmpty) {return;}

      if(tapPoints.length < 4){
          return CommonUtils.utils.handleAlertMsg(
            message: "Please select at least 4 location points",
           title: AppStrings.alertTitle
          );

      }


      String deliveryAreaString = tapPoints
          .map((latLng) => "${latLng.latitude} ${latLng.longitude}")
          .join(',');

      if (deliveryAreaString.isEmpty) {
        showLoader.value = false;
        return;
      }
      showLoader.value = true;
      var param = {
        "locations": deliveryAreaString
      };
      var apiResult = await ApiController().restaurantUpdateDeliveryArea(param);
      showLoader.value = false;
      if (apiResult.responseCode == AppStrings.apiSuccess) {
          fetchDeliveryArea(loader: false);
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: apiResult.responseCode,
            message: apiResult.msg,
          );
      }

    } catch(e){
      showLoader.value = false;
      debugPrint('updating delivery area exception: $e');
    }
  }

}