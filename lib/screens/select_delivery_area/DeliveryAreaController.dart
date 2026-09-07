import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import '../../utils/SizeConfig.dart';


class DeliveryAreaController extends GetxController {
  Completer<GoogleMapController> mapIdController = Completer();
  GoogleMapController? mapController;
  var loadLatLng = false.obs;
  var variableLatLng = const LatLng(0.0,0.0).obs;
  var tapPoints = <LatLng>[].obs;
  var deliverLatLngString = "".obs;
  var confirmLoader = false.obs;
  var alreadyExist = false.obs;
  var previousList = <LatLng>[].obs;
  var storage = GetStorage();


  @override
  void onInit() {
    super.onInit();
     alreadyExist.value = false;
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
        LatLng latLng = const LatLng(0.0, 0.0);
        try {
          latLng = storage.read(GetStorageConstants.RESTAURANT_LATLNG);
        } catch(e){
          var list = storage.read(GetStorageConstants.RESTAURANT_LATLNG);
          latLng = LatLng(list[0], list[1]);
        }

        if(latLng != const LatLng(0.0, 0.0)) {
          variableLatLng.value =
              LatLng(latLng.latitude, latLng.longitude);
          await getPreviousArea();
        } else {
          Position position = await Geolocator.getCurrentPosition(
              locationSettings: LocationSettings(
                accuracy: LocationAccuracy.best
              ));

          variableLatLng.value =
              LatLng(position.latitude, position.longitude);
          await getPreviousArea();
        }
      }
      if (!serviceEnabled) {
        mapController?.dispose();
        Get.back();
        return;
      }
    }

  }


  getPreviousArea() async {
    var  restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {
      "restaurant_id": restId
    };
    var apiResult = await ApiController().getDeliveryLocations(param);
    if(apiResult.responseCode == 1){
      String stringArea =  apiResult.response!.data["locations"];
      if(stringArea != "") {
        previousList.value = stringArea.split(',').map((coordinatePair) {
          List<String> parts = coordinatePair.trim().split(' ');
          double latitude = double.parse(parts[0]);
          double longitude = double.parse(parts[1]);
          return LatLng(latitude, longitude);
        }).toList();
        alreadyExist.value = true;
      } else {
        alreadyExist.value = false;
      }
    }
    else {
      CommonUtils.utils.handleApiError(
          apiResult.responseCode, apiResult.msg);
    }
  }
  
  
  previousPolyLine(){
    final Set<Polyline> polyLines = {};
      polyLines.add(
        Polyline(
          polylineId: const PolylineId('polylinePrevious'),
          color: Colors.red,
          points: previousList,
          width: 3,
        ),
      );
    return polyLines;
  }

  clearPreviousArea(){
    previousList.clear();
    previousList.refresh();
    alreadyExist.value = false;
  }
  
  
  


  void addTapPoint(LatLng point) {
      tapPoints.add(point);
      tapPoints.refresh();
  }


  Set<Polyline> createPolyLines() {
    final Set<Polyline> polyLines = {};
    if (tapPoints.length > 1) {
      polyLines.add(
        Polyline(
          polylineId: const PolylineId('polyline'),
          color: Colors.red,
          points: tapPoints,
          width: 3,
        ),
      );
    }
    return polyLines;
  }

  removePolyLine(){
    tapPoints.removeLast();
    tapPoints.refresh();
  }




  confirmAreaClick() async {

    for(LatLng latLng in tapPoints){
      deliverLatLngString.value += "${latLng.latitude} ${latLng.longitude},";
    }

    if(deliverLatLngString.value != "") {
      confirmLoader.value = true;
      deliverLatLngString.value = deliverLatLngString.value.substring(0,deliverLatLngString.value.length -1);

     var  restId = storage.read(GetStorageConstants.RESTAURANT_ID);
      var param = {
        "restaurant_id": restId,
        "locations": deliverLatLngString.value
      };
      var apiResult = await ApiController().manageDeliveryLocations(param);
      confirmLoader.value = false;
      if(apiResult.responseCode == 1){
        mapController?.dispose();
        Get.back();
      }
      else {
        CommonUtils.utils.handleApiError(
            apiResult.responseCode, apiResult.msg);
      }
    }
  }

}