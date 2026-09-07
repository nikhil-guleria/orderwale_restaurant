import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';



class CustomImgPicker {
//--------------------------> image path <-------------------------------------

  static Future<String?> getImagePath(String imgSource) async {
     var gettingData = await _pickImage(imgSource);
     if(gettingData != null) {
       return gettingData.path;
     }
     return null;
  }

  static Future<String?> getCroppedImagePath(String imgSource) async {

    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      var croppedData = await _cropImage(gettingData.path);
      if(croppedData != null){
        return croppedData.path;
      }
    }
    return null;
  }




//--------------------------> image path Uri <-------------------------------------


  static Future<Uri?> getImagePathUri(String imgSource) async {
    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      return Uri.file(gettingData.path);
    }
    return null;
  }


  static Future<Uri?> getCroppedImagePathUri(String imgSource) async {

    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      var croppedData = await _cropImage(gettingData.path);
      if(croppedData != null){
        Uri uri = Uri.file(croppedData.path);
        return uri;
      }
    }
    return null;
  }



//--------------------------> image XFile &  CroppedFile <-------------------------------------


  static  Future<XFile?> getXFileImage(String imgSource) async {
    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      return gettingData;
    }
    return null;
  }

  static  Future<CroppedFile?> getCroppedFileImage(String imgSource ) async {
    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      var croppedData = await _cropImage(gettingData.path);
      if(croppedData != null){
        return croppedData;
      }
    }
    return null;
  }



//-------------------------->  image bytes <-------------------------------------
  static Future<Uint8List?> getImageBytes(String imgSource) async {
    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      return await gettingData.readAsBytes();
    }
    return null;
  }

  static Future<Uint8List?> getCroppedImageBytes(String imgSource) async {

    var gettingData = await _pickImage(imgSource);
    if(gettingData != null) {
      var croppedData = await _cropImage(gettingData.path);
      if(croppedData != null){
        return await croppedData.readAsBytes();
      }
    }
    return null;
  }



//-------------------------->  internal methods <-------------------------------------

  static Future<XFile?> _pickImage(String imgSource) async {
    XFile? xFileImage;
    if (imgSource == "Gallery"){
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        xFileImage = pickedFile;
      }
    } else if (imgSource == "Camera"){
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 2400,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        xFileImage = pickedFile;
      }
    }
    return xFileImage;
  }


  static Future<CroppedFile?> _cropImage(String imagePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.white,
              toolbarWidgetColor: colorPrimary,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              hideBottomControls: true,
              aspectRatioPresets: [CropAspectRatioPreset.original]),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
           /*WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.dialog,
              barrierColor: AppColors.transparent,
              movable: true,
              viewwMode: WebViewMode.mode_1,
              zoomable: false,
             zoomOnWheel: false,
             zoomOnTouch: false,
             rotatable: true,

          ),*/
        ]
    );
    if (croppedImage != null) {
      return croppedImage;
    }
    return null;
  }










  // compress image
  static Future<File?> compressTo1MB(File file) async {
    const int maxSizeBytes = 1 * 1024 * 1024; // 1 MB
    int quality = 95;

    debugPrint("Original size: ${(await file.length()) / 1024 / 1024} MB");

    File? compressedFile = file;

    while (await compressedFile!.length() > maxSizeBytes && quality > 10) {
      final targetPath = "${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        compressedFile.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedXFile == null) break;

      compressedFile = File(compressedXFile.path);
      debugPrint("Compressed size at quality=$quality → ${(await compressedFile.length()) / 1024 / 1024} MB");

      quality -= 10; // reduce step by step
    }

    return compressedFile;
  }


  static Future<List<File>> compressImagesTo1MB(List<File> files) async {
    List<File> compressedFiles = [];
    for (File file in files) {
      File? compressed = await compressTo1MB(file);
      if (compressed != null) {
        compressedFiles.add(compressed);
      }
    }
    return compressedFiles;
  }



//---------------------------> multiple images <-----------------------------

 static Future<List<Uri>> pickMultipleImageUris({int limit = 3}) async {
    try {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final limitedFiles = pickedFiles.take(limit).toList();
        return limitedFiles.map((file) => Uri.file(file.path)).toList();
      }
    } catch (e) {
      debugPrint("Exception picking multiple images: $e");
    }
    return [];
  }

}