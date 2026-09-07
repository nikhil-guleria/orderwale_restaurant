
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ImagePreviewController extends GetxController{
  List<String> pathList;
  ImagePreviewController(this.pathList);
  var activePage = 0.obs;
  var newList = [].obs;
  PageController pageController = PageController(viewportFraction: 1,initialPage: 0);
  @override
  void onInit() {
newList.value = pathList;
    super.onInit();
  }
  done(){
    List<String> stringList = newList.map((item) => item.toString()).toList();
    Get.back(result: stringList);
  }
 deleteImage(){
   newList.removeAt(activePage.value);
   newList.refresh();
   if (activePage.value == newList.length ){
     activePage.value = activePage.value-1;
   }
     if (newList.isEmpty){
     Get.back();
   }
 }
}