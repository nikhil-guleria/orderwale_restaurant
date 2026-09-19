
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';
import '../constant/font_family.dart';
import '../utils/size_config.dart';
import 'custom_text_widget.dart';

 Future showCustomBottomSheet({required BuildContext context, required String title, required childWidget}){
  return showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
       return SafeArea(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           mainAxisSize: MainAxisSize.max,
           children: [
             SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
             Container(
               height:3,
               width: SizeConfig.blockSizeHorizontal*15,
               decoration: BoxDecoration(
                   color: Colors.grey,
                   borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1)
               ),
             ),
             SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
             Container(
               alignment: Alignment.topLeft,
               padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
               child: TextWidget(text: title,
                   fontFamily: FontFamily.fontMedium,
                   fontSize: SizeConfig.mediumFontSize,
                   color: Colors.black, fontWeight: FontWeight.bold,),
             ),
             SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
             Expanded(
                 child:
                 SingleChildScrollView(
                   child:  childWidget,
                 ))
           ],
         ),
       );
      });
}