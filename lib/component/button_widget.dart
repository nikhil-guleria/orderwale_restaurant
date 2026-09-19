import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import '../constant/app_colors.dart';
import '../constant/font_family.dart';
import '../utils/size_config.dart';

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
  final Color? borderColor;
  final double? borderWidth;

  const ButtonWidget({super.key,  required this.text, this.onPressed,
    this.txtColor ,this.fontFamily,this.fontSize, this.width, this.height, this.backGroundColor,
    this.borderColor, this.borderWidth, this.roundedCorner,});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      width:  width ?? SizeConfig.screenWidth,
      decoration: BoxDecoration(
        border: Border.all(color:  borderColor ??  backGroundColor ?? AppColors.colorPrimary,
            width: borderWidth ?? 0.0),
    borderRadius:  BorderRadius.all(
        Radius.circular(roundedCorner ?? 8.0))),

      child:  ElevatedButton(style: ElevatedButton.styleFrom(
        backgroundColor:  backGroundColor ?? AppColors.colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedCorner ?? 8.0),
        ),
        padding: EdgeInsets.zero
      ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
          child: TextWidget(text: text,
          fontFamily: fontFamily ?? FontFamily.fontSemiBold,
          color:  txtColor ?? AppColors.white,
          maxLines: 1,overflow: TextOverflow.ellipsis,
          fontSize: fontSize ?? SizeConfig.commonButtonTextSize),
        ),
      ),

    );
  }
}