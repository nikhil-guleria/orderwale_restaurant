import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController {
  PageController pageController = PageController(initialPage: 1);
  var tabIndex = 1.obs;






  void changePageIndex(int index){
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }





}