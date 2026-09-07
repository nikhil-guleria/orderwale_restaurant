import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_picker.dart';


class ImgPickerDialogBox {

//-----------------------------> calling methods <--------------------------------------
 static Future<dynamic>? pickImagePath(
      {bool onlyGallery = false, bool onlyCamera = false}) async {
   return await _showDialog(
        onlyCamera: onlyCamera, onlyGallery: onlyGallery,
        returnType: "path"
    );
  }


 static Future<dynamic>? pickCroppedImagePath(
      {bool onlyGallery = false, bool onlyCamera = false}) async {
  return  await _showDialog(
        onlyCamera: onlyCamera, onlyGallery: onlyGallery,
        returnType: "croppedPath"
    );
  }


 static Future<dynamic>? pickImagePathUri(
      {bool onlyGallery = false, bool onlyCamera = false}) async {
   return await _showDialog(
        onlyCamera: onlyCamera, onlyGallery: onlyGallery,
        returnType: "pathUri"
    );
  }


 static Future<dynamic>? pickCroppedImagePathUri(
      {bool onlyGallery = false, bool onlyCamera = false}) async {
  return  await _showDialog(
        onlyCamera: onlyCamera, onlyGallery: onlyGallery,
        returnType: "croppedPathUri"
    );
  }












//-----------------------------> picker dialog <--------------------------------------

  static Future<dynamic> _showDialog(
      {bool onlyGallery = false, bool onlyCamera = false, String returnType = 'croppedPath'}) async {
    dynamic imageResult;
    await Get.dialog(
        AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17)),
            title: Text("Select Photo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
            actions: [
              // camera
              Visibility(
                visible: !onlyGallery,
                child: Center(
                  child: MaterialButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text("Take Photo",
                          style: TextStyle(
                              fontSize: 16)),
                      onPressed: () {
                        Get.back(result: "Camera");
                      }),
                ),
              ),

              // gallery
              Visibility(
                visible: !onlyCamera,
                child: Center(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Get.back(result: "Gallery");
                    },
                    child: Text("Choose From Library",
                        style: TextStyle(
                            fontSize: 16)),
                  ),
                ),
              ),
              Center(
                child: MaterialButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel",
                      style: TextStyle(
                          fontSize: 16)),
                ),
              ),
            ]),
        barrierDismissible: false)
        .then((value) async {
      if (value != null) {
        var result = await checkPermissions();
        if (result) {
          imageResult = await _pickerMethod(returnType, value);
        }
      }
    });
    return imageResult;
  }

  static  Future<dynamic> _pickerMethod(String type, imgSource) async {
    switch (type.trim()) {
      case "path":
        return CustomImgPicker.getImagePath(imgSource);
      case "croppedPath":
        return CustomImgPicker.getCroppedImagePath(imgSource);
      case "pathUri":
        return CustomImgPicker.getImagePathUri(imgSource);
      case "croppedPathUri":
        return CustomImgPicker.getCroppedImagePathUri(imgSource);
      case "XFile":
        return CustomImgPicker.getXFileImage(imgSource);
      case "croppedFile":
        return CustomImgPicker.getCroppedFileImage(imgSource);
      case "imageBytes":
        return CustomImgPicker.getImageBytes(imgSource);
      case "croppedImageBytes":
        return CustomImgPicker.getCroppedImageBytes(imgSource);
      default:
        return;
    }
  }


//---------------------------------> permission <----------------------------------------
  static Future<bool> checkPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.camera.request();
    }

    if (status == PermissionStatus.permanentlyDenied) {
      await Get.dialog(AlertDialog(
        title: Center(
          child: Text("Permission Denied",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,),
        ),
        content: Text(
            "To Enable camera permission Go To Settings > Permissions > Enable Camera Permission",
            style: TextStyle(color: Colors.black)),
        actions: [
          MaterialButton(
              child: Text(
                  "Not Now", style: TextStyle(color: Colors.green)
              ),
              onPressed: () {
                Get.back();
              }),
          MaterialButton(
              child: Text(
                "Go To Settings",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                openAppSettings();
                Get.back();
              }),
        ],
      ));
      return false;
    }

    if (status == PermissionStatus.granted) {
      return true;
    }
    return false;
  }


//---------------------------------> multiple images <----------------------------------------




}