import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../component/TextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_constant.dart';
import '../../constant/global_variables.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'GetLocationController.dart';

class GetLocation extends GetView<GetLocationController>{
  const GetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorWhite,
        appBar: AppBar(
        title: TextWidget(text: locationScreenTitle,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,),
    elevation: 0.0,
    centerTitle: true,
           automaticallyImplyLeading: true,
    ),
    body: Container(
    height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
    padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*2,
    bottom: SizeConfig.blockSizeHorizontal*2,
    left: SizeConfig.blockSizeHorizontal*4,
    right: SizeConfig.blockSizeHorizontal*4),
    child: SingleChildScrollView(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(height: SizeConfig.blockSizeHorizontal*4),
      TextFormWidget(
          onTap: ()  {
           /* showSearch(
              context: context,
              delegate: AddressSearch(),
            );*/
          },
          onChanged: (v){
            v.length >0 ? controller.isHideIcon.value = false : controller.isHideIcon.value = true;
            v.length >2 ?
              controller.getLocation(v, Localizations
                  .localeOf(context)
                  .languageCode):
            controller.suggestedList.clear();
             },

        controller: controller.searchLocation,
         /* onSubmitted:  (v) {
            FocusScope.of(context)
                .requestFocus(controller.focusPassword);
          },
          focusNode: controller.focusEmailPassword,
         validator: (s) {
            if (s.trim().isEmpty) {
              return email_error;
            }
          },*/
          suffixIcon:
          InkWell(
                onTap: (){
                  controller.searchLocation.clear();
                  controller.suggestedList.clear();
                  controller.searchLocation.text.isNotEmpty ? controller.isHideIcon.value = false : controller.isHideIcon.value = true;
                },
                child:
                    Obx(()=>
                Visibility(
                    visible: !controller.isHideIcon.value,
                    child:
                Icon(Icons.clear,size: SizeConfig.semiBoldFontSize,color: normalTextColor)),
                    )),
        prefixIcon: Icon(Icons.search,size: SizeConfig.semiBoldFontSize,color: normalTextColor)),

      SizedBox(height: SizeConfig.blockSizeHorizontal*6),
      InkWell(onTap: (){
        Get.toNamed(Routes.MAP);
        },
        child: Row(
          children:[ Icon(CupertinoIcons.location_fill,size: SizeConfig.mediumFontSize,color: colorPrimary),
            SizedBox(width: SizeConfig.blockSizeHorizontal*2),
            TextWidget(text: currentLocation, fontFamily: fontSemiBold,color: colorPrimary,
              fontSize: SizeConfig.mediumFontSize),
          ]
        )),

      SizedBox(height: SizeConfig.blockSizeHorizontal*1),
      Divider(),
      SizedBox(height: SizeConfig.blockSizeHorizontal*1),
    TextWidget(text: recentSearches, fontFamily: fontRegular,color: normalTextColor,
    fontSize: SizeConfig.regularFontSize),
      SizedBox(height: SizeConfig.blockSizeHorizontal*4),
    Obx(() =>
    ListView.builder(padding: const EdgeInsets.only(left: 10, right: 10),

    shrinkWrap: true,
        itemCount: controller.suggestedList.length,

    itemBuilder: (context, index) {
      return
        ListTile(
          leading:  Icon(CupertinoIcons.location_solid,
              size: SizeConfig.mediumFontSize,color: enabledBorderColor),
          title:
          TextWidget( text: controller.suggestedList[index].description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,

          fontSize: SizeConfig.mediumFontSize,
            color: colorBlack,fontFamily: fontMedium,),
          onTap: () {
            GlobalVariables.selectedLocation = controller.suggestedList[index].description;
            Get.back();
          },
        );
    })
    )



    ])




    )));
  }

}



