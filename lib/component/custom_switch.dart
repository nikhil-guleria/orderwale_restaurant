import 'package:flutter/material.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/utils/SizeConfig.dart';

Widget customSwitch({required bool switchValue, GestureTapCallback? onTap,
 double? fontSize, double? openPadding, double? closedPadding, double? buttonSize}){
 return
   InkWell(
     splashColor: Colors.transparent,
     highlightColor: Colors.transparent,
     onTap: onTap,
     child: AnimatedContainer(
       width: SizeConfig.blockSizeHorizontal*22,
       height: SizeConfig.blockSizeHorizontal*9,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*5),
         color: switchValue ? Colors.green : Colors.red,
       ),
       duration:const Duration(milliseconds: 200),
       child: Stack(
         alignment: Alignment.center,
         children: [
           AnimatedPositioned(
             duration: const Duration(milliseconds: 200),
             left: switchValue ? SizeConfig.blockSizeHorizontal*13 : 0,
             right: switchValue ? 0 : SizeConfig.blockSizeHorizontal*13,
             child: Container(
               width: buttonSize ?? SizeConfig.blockSizeHorizontal*7,
               height: buttonSize ?? SizeConfig.blockSizeHorizontal*7,
               decoration: const BoxDecoration(
                 shape: BoxShape.circle,
                 color: Colors.white,
               ),
             ),
           ),
           Center(
             child: Align(
               alignment: switchValue ? Alignment.centerLeft : Alignment.centerRight,
               child: AnimatedContainer(
                 duration: const Duration(milliseconds: 200),
                 padding: switchValue ?
                 EdgeInsets.only(left: openPadding ?? SizeConfig.blockSizeHorizontal*2.2)
                 : EdgeInsets.only(right: closedPadding ?? SizeConfig.blockSizeHorizontal*1.5),
                 child: TextWidget(
                  text:  switchValue ? 'Open' : 'Closed',
                  color: colorWhite,
                   height: 1.0,
                   fontSize: fontSize ?? SizeConfig.blockSizeHorizontal*3.5,
                   fontFamily: fontBold,
                 ),
               ),
             ),
           ),
         ],
       ),
     ),
   );
}