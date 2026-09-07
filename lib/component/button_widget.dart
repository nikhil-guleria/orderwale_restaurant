import 'package:flutter/material.dart';
import 'package:food_merchant/component/TextWidget.dart';
import '../constant/app_color.dart';
import '../constant/app_constant.dart';
import '../utils/SizeConfig.dart';

class ButtonWidget extends StatelessWidget{
  final VoidCallback? onPressed;
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? txtColor;
  final double? width;
  final double? height;
  final Color? backGroundColor;
  final double? roundedCorner;
  const ButtonWidget({super.key,  required this.text, required this.onPressed,
    this.txtColor ,this.fontFamily,this.fontSize, this.width, this.height, this.backGroundColor, this.roundedCorner});
  @override
  Widget build(BuildContext context) {
    return Container( height: height ?? SizeConfig.blockSizeHorizontal*12.7,
      width:  width ?? SizeConfig.screenWidth,
      decoration: BoxDecoration(
        border: Border.all(color:   backGroundColor ?? colorPrimary,width: 0.0),
    borderRadius:  BorderRadius.all(
    Radius.circular(roundedCorner ?? 10.0))

      ),

      child:  ElevatedButton(style: ElevatedButton.styleFrom(
        backgroundColor:  backGroundColor ?? colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedCorner ?? 10.0),
        ),
      ),
        onPressed: onPressed,
        child: TextWidget(text: text,
        fontFamily: fontFamily ?? fontMedium,
        color:  txtColor ?? colorWhite,
        maxLines: 1,overflow: TextOverflow.ellipsis,
        fontSize: fontSize ?? SizeConfig.mediumFontSize),
      ),

    );
  }
}