import 'package:flutter/cupertino.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import '../constant/app_color.dart';
import '../constant/app_constant.dart';

class TextWidget extends StatelessWidget{
  final text;
  final foreGround;
  TextOverflow? overflow;
  double? fontSize;
  Color? color;
  FontWeight? weight;
  String? fontFamily;
  double? letterSpacing;
  FontStyle? fontStyle;
  double? wordSpacing;
  TextDecoration? decoration;
  TextDecorationStyle? textDecorationStyle;
  TextBaseline? textBaseline;
  Color? decorationColor;
  Color? backgroundColor;
  double? height;
  bool? softWrap;
  int? maxLines;
  TextAlign? textAlign;
  double? decorationThickness;


  TextWidget({required this.text ,this.overflow, this.fontSize, this.color, this. weight, this.fontFamily,
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
  fontSize: fontSize ?? SizeConfig.regularFontSize,
  color: color ?? colorBlack,
  fontWeight: weight,
  fontFamily: fontFamily ?? fontMedium,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
  decoration: decoration,
  decorationStyle: textDecorationStyle,
  decorationColor: decorationColor,
  wordSpacing: wordSpacing,
  textBaseline: textBaseline,
  backgroundColor: backgroundColor,
  height: height,
  decorationThickness: decorationThickness
));
  }

}