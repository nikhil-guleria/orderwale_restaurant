import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/address_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';
import '../../constant/global_variables.dart';
import '../../routes/app_routes.dart';
import '../../utils/size_config.dart';
import 'package:location/location.dart' as lc;




class MapController extends GetxController  {
  Completer<GoogleMapController> mapIdController = Completer();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final LatLng arguments = Get.arguments;
  final initialLatLng = const LatLng(AppStrings.hpLatitude,
      AppStrings.hpLongitude).obs;
  var street = "".obs;
  var adminArea = "".obs;
  var loadLatLng = true.obs;
  //var variableLatLng = LatLng(0.0,0.0).obs;


  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

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
        initialRestaurantLatLng();
      }
      if (!serviceEnabled) {
        disposeMapController();
        Get.back();
        return;
      }
    }
  }

  Future<void> initialRestaurantLatLng() async {
    try {
      LatLng latLng = LatLng(arguments.latitude, arguments.longitude);
      if (latLng.latitude > 0 && latLng.longitude > 0) {
        initialLatLng.value = latLng;
      } else {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.best));
        initialLatLng.value =
            LatLng(position.latitude, position.longitude);
      }
      animateCameraToLatLng(initialLatLng.value);
    } catch (e){
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
              accuracy: LocationAccuracy.best
          ));
      initialLatLng.value =
          LatLng(position.latitude, position.longitude);
      animateCameraToLatLng(initialLatLng.value);
    }

  }

  Future<void> animateCameraToLatLng(LatLng latLng) async {
    final GoogleMapController controller = await mapIdController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng,13.25));
  }


  Future<void> locateMe()  async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best));
    LatLng latLng = LatLng(position.latitude, position.longitude);
    animateCameraToLatLng(latLng);
    //mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void onCameraMove(CameraPosition position) async {
   // variableLatLng.value = LatLng(position.target.latitude, position.target.longitude);
    initialLatLng.value = LatLng(position.target.latitude, position.target.longitude);
  }

  void onCameraIdle() async{
    loadLatLng.value = true;
    await getAddressFromLatLng(initialLatLng.value);
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      var param = {
        'lat': latLng.latitude,
        'lng':  latLng.longitude
      };
      var apiResponse = await ApiController().mapsAddressFromLatLng(param);
      if(apiResponse.responseCode == AppStrings.apiSuccess){
        street.value = apiResponse.response?.data['data']['address_type'] ?? 'Unknown';
        adminArea.value = apiResponse.response?.data['data']['formatted_address'] ?? 'Unknown';
      } else {
        street.value = "Unknown";
        adminArea.value = "Unknown";
      }
    } catch (e) {
      debugPrint("Error in getAddressFromLatLng: $e");
      street.value = "Unknown";
      adminArea.value = "Unknown";
    }finally {
      loadLatLng.value = false;
    }
  }



  void confirmButtonClick(){
    disposeMapController();
    Get.until((route) {
      if (route.settings.name == AppRoutes.manageRestaurant) {
        GlobalVariables.selectedLocation = "${street.value} ${adminArea.value}";
        GlobalVariables.restaurantLatLng = LatLng(initialLatLng.value.latitude,
            initialLatLng.value.longitude);
        return true;
      } else {
        return false;
      }
    });
  }




void alertDialog(){
  nameController.text = street.value;
  addressController.text = adminArea.value;
Get.dialog(
    AddressDialog(
  title: "Update Address",
  nameController: nameController,
  addressController: addressController,
  onConfirm: (){
    disposeMapController();
    Get.until((route) {
      if (route.settings.name == AppRoutes.manageRestaurant) {
        GlobalVariables.selectedLocation = "${nameController.text} ${addressController.text}";
        GlobalVariables.restaurantLatLng = LatLng(initialLatLng.value.latitude,
            initialLatLng.value.longitude);
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


