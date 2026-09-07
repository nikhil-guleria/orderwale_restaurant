


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../component/image_preview/ImagePreview.dart';
import '../constant/app_color.dart';

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
           toolbarColor: colorPrimary,
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






/*class SelectImages {
  static Future<List<String>> pickImage(
    String imageSource,
    int count,
  ) async {
    List<String> imageFile = [];
    if (imageSource == 'Gallery') {
      if (Platform.isIOS) {
        await ImagesPicker.pick(count: count, pickType: PickType.image)
            .then((value) {
          imageFile.add(value![0].path);
        }).catchError((error) {
          print(error.toString());
        });
      } else {
        await MultipleImagesPicker.pickImages(
          maxImages: count,
          enableCamera: false,
          materialOptions: MaterialOptions(
            actionBarColor: '#F27649',
            actionBarTitle: appName,
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectionLimitReachedText: "Please select $count images at a time",
            selectCircleStrokeColor: '#F27649',
          ),
        ).then((value) async {
          for (var path in value) {
            final filePath =
                await FlutterAbsolutePath.getAbsolutePath(path.identifier!);
            imageFile.add(filePath);

          }
         *//* for (int i = 0; i < value.length; i++) {
            var path = await FlutterAbsolutePath.getAbsolutePath(
                value.elementAt(i).identifier!);
            imageFile.add(path!);
          }*//*
        }).catchError((error) {
          print(error.toString());
        });
      }
    } else if (imageSource == 'Camera') {
      await ImagesPicker.openCamera(
        pickType: PickType.image,
        maxTime: 30,
      ).then((value) {
        imageFile.add(value![0].path);
      }).catchError((error) {
        print(error.toString());
      });
    }

    return imageFile;
  }

  static Future<CompressedImage> resizeImage(
      String imagePath, int imageQuality) async {
    var path;
    var fileName = imagePath.split('/').last;
    if (!fileName.contains(".")) fileName = fileName + ".png";
    if (Platform.isAndroid) {
      path = await FlutterAbsolutePath.getAbsolutePath(imagePath);
    }
    var compressedImage = await FlutterImageCompress.compressWithList(
      File(Platform.isAndroid ? path : imagePath).readAsBytesSync(),
      quality: imageQuality,
    );

    return CompressedImage(compressedImage, fileName);
  }
}

class CompressedImage {
  final Uint8List compressedImage;
  final String fileName;

  CompressedImage(
    this.compressedImage,
    this.fileName,
  );
}*/
