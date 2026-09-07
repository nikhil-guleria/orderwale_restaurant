
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_constant.dart';
import '../constant/app_color.dart';
import '../utils/SizeConfig.dart';
import 'TextFormFieldWidget.dart';

class AddressDialog extends StatelessWidget{
  final title;
  final nameController;
  final addressController;
  final onCancel;
  final onConfirm;

  const AddressDialog({super.key,   this.title, this.nameController,
    this.onConfirm,
    this.onCancel, this.addressController
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: colorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*6.5)
        ),
        child: Container(height: SizeConfig.blockSizeHorizontal*80,
            width: SizeConfig.blockSizeHorizontal*90,
            decoration: const BoxDecoration(
                color: Colors.transparent),
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title , style: TextStyle( color: Colors.black,
                    decoration: TextDecoration.none,
                    fontFamily: fontMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.mediumFontSize)),
                TextFormWidget(
                    labelText: "Name",
                    controller: nameController,
                    inputAction: TextInputAction.done
                ),
                TextFormWidget(
                    labelText: "Address",
                    controller: addressController,
                    inputAction: TextInputAction.done),

                Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: onCancel,
                        child: Text('CANCEL',
                          style: TextStyle(color: colorPrimary,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium) ,)),
                    TextButton(onPressed: onConfirm, child: Text('OK',
                      style: TextStyle(color: colorPrimary,
                          fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium) ,)),
                  ],
                )
              ],
            )



        ),
      ),

    );

  }

}