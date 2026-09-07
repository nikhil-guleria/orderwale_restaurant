import 'package:flutter/material.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/constant/string_constants.dart';
import '../constant/app_color.dart';
import '../utils/SizeConfig.dart';

// ignore: must_be_immutable
/*class DialogBox extends StatelessWidget{
  String? title;
  String? middleText;
  VoidCallback? onConfirm;
  VoidCallback? onCancel;
  String? cancelTxt;
  String? confirmTxt;
  bool? twoButtons = false;
  double? middleTextSize;
  double? titleTextSize;
  double? btnTextSize;
  DialogBox({super.key,
    this.title, this.middleText,
     this.onConfirm,
     this.onCancel, this.confirmTxt, this.cancelTxt,
    this.twoButtons,
    this.middleTextSize,
    this.titleTextSize,
    this.btnTextSize
     });
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container( height: SizeConfig.blockSizeHorizontal*49,
          width: SizeConfig.blockSizeHorizontal*80,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.blockSizeHorizontal*5),
                    topRight: Radius.circular(SizeConfig.blockSizeHorizontal*5),
                    bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*5)),
                color: colorWhite),
            padding: EdgeInsets.symmetric(
              vertical:  SizeConfig.blockSizeHorizontal*4,
              horizontal:   SizeConfig.blockSizeHorizontal*4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget( text:title ?? alert,
                  color: colorBlack,
                  maxLines: 1,
                  weight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: titleTextSize ?? SizeConfig.semiBoldFontSize),
              TextWidget(text: middleText  ?? '',
                  color: blackShades,
                  decoration: TextDecoration.none,
                  weight: FontWeight.normal,
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                  fontSize: middleTextSize ??  SizeConfig.mediumFontSize),

              Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: twoButtons == true,
                      child: TextButton(onPressed: onCancel,
                          child: Text(cancelTxt ?? 'CANCEL',
                            style: TextStyle(color: colorPrimary,
                                fontSize: btnTextSize ?? SizeConfig.mediumFontSize,
                                fontFamily: fontMedium))),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
                    TextButton(onPressed: onConfirm, child: Text(confirmTxt ?? 'OK',
                      style: TextStyle(color: colorPrimary,
                          fontSize: btnTextSize ?? SizeConfig.mediumFontSize,
                          fontFamily: fontMedium) ,)),
                  ],
              )]))


    );

  }

}*/


 Widget showDialogBox({
   String? title,
   String? message,
   VoidCallback? onConfirm,
   VoidCallback? onCancel,
   String? cancelTxt,
   String? confirmTxt,
   bool twoButtons = false,
 }) {
        return AlertDialog(
          surfaceTintColor: colorWhite,
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17))),
          title: Text( title ?? alert,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontMedium,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          content: Text(message ?? '', style: TextStyle(
            fontFamily: fontMedium,
            fontSize: 16)),
          actions: <Widget>[
            Visibility(
              visible: twoButtons,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: colorPrimary,
                  padding:  EdgeInsets.all(12),
                  textStyle:  TextStyle(
                      fontFamily: fontMedium,
                      fontSize: 18,
                      color: stormGrey),
                ),
                onPressed: onCancel,
                child:  Text(cancelTxt ?? 'Cancel',
                    style:  TextStyle(
                        fontSize: 18,
                        fontFamily: fontMedium,
                        color: stormGrey)),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor:  colorPrimary,
                padding:  EdgeInsets.all(12),
                textStyle:  TextStyle(
                    fontSize: 18,
                    fontFamily: fontMedium,
                    color: colorPrimary),
              ),
              onPressed: onConfirm,
              child:  Text(confirmTxt ?? 'Ok',
                  style:  TextStyle(
                      fontSize: 18,
                      fontFamily: fontMedium,
                      color: colorPrimary)),
            ),
          ],
        );
}