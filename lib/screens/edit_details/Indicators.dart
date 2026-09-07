import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

List<Widget> indicators(imagesLength,currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? colorPrimary : normalTextColor,
          shape: BoxShape.circle),
    );
  });
}