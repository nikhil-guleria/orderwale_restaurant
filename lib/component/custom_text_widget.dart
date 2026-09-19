import 'package:flutter/material.dart';
import 'package:food_merchant/utils/size_config.dart';
import '../constant/app_colors.dart';
import '../constant/font_family.dart';

class TextWidget extends StatelessWidget{
  final String text;
  final Paint? foreGround;
  final TextOverflow? overflow;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final double? wordSpacing;
  final TextDecoration? decoration;
  final TextDecorationStyle? textDecorationStyle;
  final TextBaseline? textBaseline;
  final Color? decorationColor;
  final Color? backgroundColor;
  final double? height;
  final bool? softWrap;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? decorationThickness;


  const TextWidget({super.key, required this.text ,this.overflow, this.fontSize, this.color, this. fontWeight, this.fontFamily,
    this.letterSpacing,this.fontStyle,this.wordSpacing,this.decoration,this.textDecorationStyle,
    this.textBaseline,this.decorationColor,this.backgroundColor, this.height,
    this.textAlign ,this.softWrap, this.maxLines, this.foreGround, this.decorationThickness});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: overflow,
        softWrap: softWrap,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          foreground: foreGround,
          fontSize: fontSize ?? SizeConfig.regularTextSize,
          color: color ?? AppColors.blackText,
          fontWeight: fontWeight,
          fontFamily: fontFamily ?? FontFamily.fontMedium,
          letterSpacing: letterSpacing,
          fontStyle: fontStyle,
          decoration: decoration,
          decorationStyle: textDecorationStyle,
          decorationColor: decorationColor,
          decorationThickness: decorationThickness,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          backgroundColor: backgroundColor,
          height: height,
        ));
  }
}

Widget  buildInputFieldHeading(String text, {double? fontSize, Color? color, FontWeight? fontWeight, String? fontFamily})  => Padding(
  padding: EdgeInsets.only(bottom: SizeConfig.padding8),
  child: TextWidget(
      text: text,
      color: color ?? AppColors.normalTextColor,
      fontWeight: fontWeight,
      fontFamily: fontFamily ?? FontFamily.fontMedium,
      fontSize: fontSize ?? SizeConfig.mediumFontSize),
);


AppBar buildAppBar({required String title, Color? txtColor,
  bool automaticallyImplyLeading = true}){
  return AppBar(
    title: TextWidget(text: title,
      color: txtColor,
      fontSize: SizeConfig.appbarTitleSize,
      fontFamily: FontFamily.fontSemiBold,
      fontWeight: FontWeight.w600,),
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: automaticallyImplyLeading
  );
}


String showCapitalizeEachWord(String? value){
  String text = value ?? '';
  if (text.trim().isEmpty) {
    return text ;
  }
  String formattedText = text
      .split(' ')
      .map((word) => word.isEmpty
      ? word
      : word[0].toUpperCase() + word.substring(1))
      .join(' ');

  return formattedText;
}