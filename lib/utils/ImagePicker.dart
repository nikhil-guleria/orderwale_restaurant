


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../component/image_preview/ImagePreview.dart';
import '../constant/app_colors.dart';

class ImgPicker{
  static  pickImage(String imgSource) async {
    String? imagePath;
    if (imgSource == "Gallery"){
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
     var croppedPath = await cropImage(pickedFile.path);
     if(croppedPath != null){
       imagePath = croppedPath;
     }else {
        return;
     }
    }
  } else if (imgSource == "Camera"){
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 2400,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        var croppedPath = await cropImage(pickedFile.path);
        if(croppedPath != null){
          imagePath = croppedPath;
        }else {
          return;
        }
      }
    }
    return imagePath;
  }

 static cropImage(var imagePath) async {
     var croppedImage = await ImageCropper().cropImage(
         sourcePath: imagePath,
         /*aspectRatioPresets: [
           CropAspectRatioPreset.original
         ],*/
         uiSettings: [AndroidUiSettings(
           toolbarTitle: 'Image Cropper',
           toolbarColor: AppColors.colorPrimary,
           toolbarWidgetColor: Colors.white,
           initAspectRatio: CropAspectRatioPreset.original,
           lockAspectRatio: false,
           hideBottomControls: true
         ),
          IOSUiSettings(
           minimumAspectRatio: 1.0,
         )]
     );
     if (croppedImage != null) {
       return croppedImage.path;
     }
   }

  static selectMultipleImages() async {
    List<String> imagePaths = [];
    List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    for (var imgPath in selectedImages) {
      imagePaths.add(imgPath.path);
    }
    if(imagePaths.isNotEmpty) {
      await Get.to(() =>  PreviewImages(selectedImages:imagePaths))?.then((value) {
        if(value != null) {
          imagePaths = value;
        }else {
          imagePaths.clear();
        }
    });
    }
    return imagePaths;
  }

}