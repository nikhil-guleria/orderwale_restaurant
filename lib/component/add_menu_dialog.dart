import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:get/get.dart';

import '../constant/font_family.dart';
import '../constant/app_strings.dart';
import '../utils/size_config.dart';
import 'custom_form_field.dart';

class AddMenuDialog extends StatelessWidget{
  TextEditingController menuNameController = TextEditingController();

   AddMenuDialog({super.key});




  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Container(height:
            SizeConfig.blockSizeHorizontal*60,
            width: SizeConfig.blockSizeHorizontal*90,
            decoration: const BoxDecoration(
                color: Colors.transparent),
            padding: const EdgeInsets.all(15),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Menu Title" , style: TextStyle( color: Colors.black,
                    decoration: TextDecoration.none,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize)),

                CustomFormField(
                    labelText: "Title",
                    controller: menuNameController,
                    inputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                ),

                SizedBox(
                  width: SizeConfig.blockSizeHorizontal*60,
                  child: ButtonWidget(
                      height: SizeConfig.blockSizeHorizontal*10,
                      text: "Create New",
                      onPressed: (){
                        if(menuNameController.text.isEmpty){
                          Get.snackbar(AppStrings.alertTitle, "Please Enter Title");
                        } else {
                          Get.back(result: menuNameController.text);
                        }
                      }),
                ),
              ],
            )



        ),
      ),

    );

  }






}