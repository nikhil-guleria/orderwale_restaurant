import 'package:get/get.dart';

class SizeConfig {
  static double screenWidth = Get.width;
  static double screenHeight = Get.height;
  static double blockSizeHorizontal = screenWidth / 100;
  static double appbarTitleSize = SizeConfig.blockSizeHorizontal*5;
  static double boldFontSize = SizeConfig.blockSizeHorizontal*6.5;
  static double mediumFontSize = SizeConfig.blockSizeHorizontal*4.2;
  static double regularFontSize =  SizeConfig.blockSizeHorizontal*3.7;
  static double semiBoldFontSize =  SizeConfig.blockSizeHorizontal*5.5;
}
