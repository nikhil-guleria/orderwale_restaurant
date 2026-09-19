import 'package:flutter/material.dart';
import '../../constant/app_colors.dart';

List<Widget> indicators(int imagesLength, int currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? AppColors.colorPrimary : AppColors.normalTextColor,
          shape: BoxShape.circle),
    );
  });
}