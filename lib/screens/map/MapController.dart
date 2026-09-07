import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/AddressDialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../constant/global_variables.dart';
import '../../routes/app_pages.dart';
import '../../services/api/ApiConstant.dart';
import '../../utils/SizeConfig.dart';
import 'package:location/location.dart' as lc;




class MapController extends GetxController  {
  Completer<GoogleMapController> mapIdController = Completer();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final Dio _dio = Dio();
  LatLng arguments = Get.arguments;

  var street = "".obs;
var adminArea = "".obs;
   GoogleMapController? mapController;
  var loadLatLng = true.obs;
  var variableLatLng = LatLng(0.0,0.0).obs;


  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }
  @override
  void onClose() {
    super.onClose();
    mapController?.dispose();


  }





  void getUserLocation() async {
    lc.Location location = lc.Location();
    bool serviceEnabled;
    lc.PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == lc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      print(permissionGranted);
    }

    if (permissionGranted == lc.PermissionStatus.deniedForever) {
      await Get.dialog(PopScope(
        canPop: false,
          onPopInvoked: (didPop){
            if(didPop) {
              return ;
            } else {
              mapController?.dispose();
              Get.back();
            }
          },
        child: AlertDialog(
          backgroundColor: colorWhite,
          surfaceTintColor: colorWhite,
          title: Text("Permission Denied",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontMedium,
                  fontSize: SizeConfig.mediumFontSize,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)
          ),
          content: Text(
              "To Enable location permission Go To Settings > Permissions > Enable Location Permission",
              style: TextStyle(fontFamily: fontMedium,
                color: blackShades,
                fontSize: SizeConfig.regularFontSize,)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary,
                padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                textStyle:  TextStyle(fontSize: SizeConfig.mediumFontSize, color: colorPrimary),
              ),
              onPressed: () {
                openAppSettings();
                mapController?.dispose();
                Get.back();
              },
              child: Text("Go To Settings",
                  style: TextStyle(fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: colorPrimary)),
            ),
          ],
        ),
      ));

    }

    if(permissionGranted != lc.PermissionStatus.granted) {
      mapController?.dispose();
      Get.back();
      return;
    }

    if (permissionGranted == lc.PermissionStatus.granted) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (serviceEnabled) {
        LatLng latLng = LatLng(arguments.latitude, arguments.longitude);
        if (latLng != const LatLng(0.0, 0.0)) {
          variableLatLng.value =
              LatLng(arguments.latitude, arguments.longitude);
        } else {
          Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.best
            ));
          variableLatLng.value =
              LatLng(position.latitude, position.longitude);
        }
      }
        if (!serviceEnabled) {
          mapController?.dispose();
          Get.back();
          return;
        }
      }

  }
locateMe()  async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  LatLng latLng = LatLng(position.latitude, position.longitude);
  mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
}


  void onCameraMove(CameraPosition position) async {
    variableLatLng.value = LatLng(position.target.latitude, position.target.longitude);

  }


  void onCameraIdle() async{

    loadLatLng.value = true;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${variableLatLng.value.latitude},${variableLatLng.value.longitude}&key=${ApiConstant.androidKey}";
    var response = await _dio.get(url);
    street.value = "${response.data["results"][0]["address_components"][0]["long_name"]}";
    adminArea.value = "${(response.data["results"][0]["formatted_address"]).replaceAll(RegExp(r'\b\w*\+\w*\b'), "")}";
    loadLatLng.value = false;

  }


  confirmButtonClick(){
    mapController?.dispose();
    Get.until((route) {
      if (route.settings.name == Routes.EDIT_DETAILS) {
        GlobalVariables.selectedLocation = "${street.value} ${adminArea.value}";
        GlobalVariables.restaurantLatLng = LatLng(variableLatLng.value.latitude,
            variableLatLng.value.longitude);
        return true;
      } else {
        return false;
      }
    });
  }



alertDialog(){
  nameController.text = street.value;
  addressController.text = adminArea.value;
Get.dialog(
    AddressDialog(
  title: "Update Address",
  nameController: nameController,
  addressController: addressController,
  onConfirm: (){
    mapController?.dispose();
    Get.until((route) {
      if (route.settings.name == Routes.EDIT_DETAILS) {
        GlobalVariables.selectedLocation = "${nameController.text} ${addressController.text}";
        GlobalVariables.restaurantLatLng = LatLng(variableLatLng.value.latitude,
            variableLatLng.value.longitude);
        return true;
      } else {
        return false;
      }
    });
  },
  onCancel: (){
    Get.back();
  },
));
}


}


