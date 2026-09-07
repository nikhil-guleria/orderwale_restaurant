import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/TextFormFieldWidget.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';
import 'user_address_controller.dart';

class UserAddress extends GetView<UserAddressController>{
  const UserAddress({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: colorWhite,
     appBar: AppBar(
       title: TextWidget(text: user_address_title, fontFamily: fontBold,
           fontSize: SizeConfig.appbarTitleSize),
       elevation: 0.0,
       centerTitle: true,
     ),
     body: SafeArea(
       child: Container(
         height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
         padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*3,
             bottom:  SizeConfig.blockSizeHorizontal*2,
             left: SizeConfig.blockSizeHorizontal*4,
             right: SizeConfig.blockSizeHorizontal*4),
         child: SingleChildScrollView(
           child: Column(
             children: [
               TextFormWidget(
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
                               Icon(Icons.clear,size: SizeConfig.semiBoldFontSize,color: normalTextColor)),
                       )),
                   prefixIcon: Icon(Icons.search,size: SizeConfig.semiBoldFontSize,color: colorPrimary)),
               SizedBox(height: SizeConfig.blockSizeHorizontal*5),
               Obx(() =>  controller.suggestedList.isNotEmpty ?
               ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: controller.suggestedList.length,
                   itemBuilder: (context, index) {
                     return
                       ListTile(
                         minLeadingWidth: 0.0,
                         horizontalTitleGap: SizeConfig.blockSizeHorizontal*1,
                         contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                         leading:   Icon(CupertinoIcons.location_solid,
                             size: SizeConfig.blockSizeHorizontal*5,color: Colors.black45),
                         title:
                         Text(  controller.suggestedList[index].description,
                             overflow: TextOverflow.ellipsis,
                             maxLines: 2,
                             style:   TextStyle(
                                 fontSize: SizeConfig.regularFontSize,
                                 color: Colors.black,
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