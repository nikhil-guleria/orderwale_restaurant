import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import '../constant/app_colors.dart';
import '../utils/size_config.dart';
import 'custom_form_field.dart';

class AddressDialog extends StatelessWidget{
  final String? title;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const AddressDialog({super.key,
    this.title,
    required this.nameController,
    this.onConfirm,
    this.onCancel,
    required this.addressController
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*6.5)
        ),
        child: Container(height: SizeConfig.blockSizeHorizontal*80,
            width: SizeConfig.blockSizeHorizontal*90,
            decoration: const BoxDecoration(
                color: AppColors.transparent),
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title ?? '',
                    style: TextStyle( color: AppColors.blackText,
                    decoration: TextDecoration.none,
                    fontFamily: FontFamily.fontMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.mediumFontSize)),
               // name
                CustomFormField(
                    labelText: AppStrings.headingName,
                    controller: nameController,
                    inputAction: TextInputAction.done
                ),


                CustomFormField(
                    labelText: AppStrings.headingAddress,
                    controller: addressController,
                    inputAction: TextInputAction.done),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // cancel button
                    TextButton(onPressed: onCancel,
                        child: Text(AppStrings.btnCancel,
                          style: TextStyle(color: AppColors.colorPrimary,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium) ,)),

                    // ok button
                    TextButton(onPressed: onConfirm,
                        child: Text(AppStrings.btnOk,
                      style: TextStyle(color: AppColors.colorPrimary,
                          fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium) ,)),
                  ],
                )
              ],
            )
        ),
      ),

    );

  }

}