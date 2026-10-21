import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;



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
              toolbarWidgetColor: AppColors.colorPrimary,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              hideBottomControls: true,
              aspectRatioPresets: [CropAspectRatioPreset.original]),
          IOSUiSettings(
              title: 'Crop Image',
              rotateButtonsHidden: false,
              hidesNavigationBar: true,
              aspectRatioPickerButtonHidden: true,
              rotateClockwiseButtonHidden: true,
              aspectRatioPresets: const [CropAspectRatioPreset.original]),
           /*WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.dialog,
              barrierColor: AppColors.transparent,
              movable: true,
              viewMode: WebViewMode.mode_1,
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


  static Future<Uint8List?> compressImageFromBytesTo1MB(Uint8List inputBytes,
      {CompressFormat? format}) async {
    const int maxSizeBytes = 1 * 1024 * 1024;
    int quality = 95;
    int minWidth = 1920;
    int minHeight = 1080;

    try {
      Uint8List? compressedBytes;
      do {
        compressedBytes = await FlutterImageCompress.compressWithList(
          inputBytes,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
          format: format ?? CompressFormat.jpeg,
          rotate: 0,
          keepExif: false,
        );

        if (compressedBytes.lengthInBytes > maxSizeBytes) {
          if (quality > 20) {
            quality -= 10;
          } else if (minWidth > 400) {
            minWidth = (minWidth / 1.5).round();
            minHeight = (minHeight / 1.5).round();
          } else {
            break;
          }
        } else {
          break;
        }
      } while (true);

      return compressedBytes;
    } catch (_) {
      return null;
    }
  }


  static Future<dio.MultipartFile?> multipartImageFromBytes(String path , Uint8List bytes) async {
    try {
      String myPath = path;
      if(myPath.trim().isEmpty){
        myPath = 'abc/xyz';
      }
      String fileName = myPath.split('/').last;
      String extension = fileName.contains(".") ? fileName.split('.').last.toLowerCase() : 'png';
      if (!fileName.contains(".")) {
        fileName = "$fileName.png";
      }

      CompressFormat format;
      if (extension == 'png') {
        format = CompressFormat.png;
      } else if (extension == 'jpeg' || extension == 'jpg') {
        format = CompressFormat.jpeg;
      } else if (extension == 'heic') {
        format = CompressFormat.heic;
      } else {
        // Default to PNG if the extension is unknown
        format = CompressFormat.png;
        fileName = fileName.replaceAll(RegExp(r'\.[^.]+$'), '.png');
      }

      // Create MultipartFile from bytes
      return dio.MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: dio.DioMediaType('image', format.name),
      );
    } catch (e) {
      debugPrint("Compression/Multipart conversion failed: $e");
      return null;
    }
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