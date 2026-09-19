import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:get/get.dart';
import '../../../component/custom_form_field.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';
import 'user_address_controller.dart';

class UserAddress extends GetView<UserAddressController>{
  const UserAddress({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: AppColors.white,
     appBar: buildAppBar(title: AppStrings.userAddressTitle),
     body: SafeArea(
       child: Container(
         height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
         padding: EdgeInsets.symmetric(
             vertical: SizeConfig.padding12,
             horizontal: SizeConfig.padding16,),
         child: SingleChildScrollView(
           child: Column(
             children: [
               CustomFormField(
                   onChanged: (v){
                     v.isNotEmpty ? controller.isHideIcon.value = false : controller.isHideIcon.value = true;
                     v.length >2 ?
                     controller.getLocation(v, Localizations.localeOf(context).languageCode):
                     controller.suggestedList.clear();
                   },
       
                   controller: controller.searchLocation,
                   autoFocus: true,
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
                               Icon(Icons.clear,size: SizeConfig.semiBoldFontSize,color: AppColors.normalTextColor)),
                       )),
                   prefixIcon: Icon(Icons.search,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary)),
              SizeConfig.verticalSpace16,
               Obx(() =>  controller.suggestedList.isNotEmpty ?
               ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: controller.suggestedList.length,
                   itemBuilder: (context, index) {
                     return
                       ListTile(
                         minLeadingWidth: 0.0,
                         horizontalTitleGap: SizeConfig.padding4,
                         contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                         leading:   Icon(CupertinoIcons.location_solid,
                             size: SizeConfig.icon20,color: AppColors.black45),
                         title: Text(  controller.suggestedList[index].description,
                             overflow: TextOverflow.ellipsis,
                             maxLines: 2,
                             style:   TextStyle(
                                 fontSize: SizeConfig.regularTextSize,
                                 color: AppColors.blackText,
                                 fontFamily: FontFamily.fontMedium,
                                 fontWeight: FontWeight.w200)),
                         onTap: () {
                           FocusManager.instance.primaryFocus?.unfocus();
                           Get.back(result:controller.suggestedList[index].description);
       
                         },
                       );
                   }):
               const SizedBox()),
             ],
           ),
         ),
       ),
     ),
   );
  }

}