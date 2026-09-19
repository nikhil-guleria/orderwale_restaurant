import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'map_controller.dart';

class CustomMap extends GetView<MapController> {
  const CustomMap({super.key});



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          controller.disposeMapController();
          Get.back();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Obx(() => Stack(
         alignment: Alignment.center,
         children: <Widget>[


           Positioned.fill(
             child: SizedBox(
               height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
               child: GoogleMap(
                   zoomControlsEnabled: false,
                   mapType: MapType.normal,
                   initialCameraPosition: CameraPosition(
                       target: controller.initialLatLng.value, zoom: 13.25
                   ),
                   onCameraMove: controller.onCameraMove,
                   onCameraIdle: controller.onCameraIdle,
                   onMapCreated: (GoogleMapController controller1) {
                     controller.updateMapController(controller1);
                     controller.getUserLocation();
                   }
               )) ),



           Align(
            alignment: AlignmentDirectional.bottomCenter,
               child:
               SizedBox(height: SizeConfig.blockSizeHorizontal*55,
                 child: Stack( alignment: Alignment.topCenter,
                     children: [
                     Container(height: SizeConfig.blockSizeHorizontal*43,
                   margin: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*12),
                   padding: EdgeInsets.all( SizeConfig.blockSizeHorizontal*3.25),
                   color: AppColors.white,
                 child:

                 controller.loadLatLng.value ?
                 Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       LinearProgressIndicator(
                         minHeight: 2.5,
                         backgroundColor: AppColors.grey[200],
                         color: AppColors.colorPrimary,
                       ),
                       Shimmer.fromColors(
                           baseColor: AppColors.grey.shade300,
                           highlightColor: AppColors.grey.shade100,
                           enabled: true,
                           child:
                           Container(
                               padding: const EdgeInsets.symmetric(horizontal: 13),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(height: 16.5, width: SizeConfig.blockSizeHorizontal*25, decoration: const BoxDecoration(
                                       color: AppColors.white,
                                       borderRadius: BorderRadius.all(
                                           Radius.circular(3)))),
                                   const SizedBox(height: 5),
                                   Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: [
                                           Container(height: 16.5, width: 15,  decoration: const BoxDecoration(
                                               color: AppColors.white,
                                               borderRadius: BorderRadius.all(
                                                   Radius.circular(3)))),
                                           const SizedBox(width: 5),
                                           Expanded(
                                             child: Container(height: 16.5, decoration: const BoxDecoration(
                                                 color: AppColors.white,
                                                 borderRadius: BorderRadius.all(
                                                     Radius.circular(3)))),
                                           )
                                         ],
                                       ),
                                       const SizedBox(height: 5),
                                       Container(height: 16.5, width: Get.width, decoration: const BoxDecoration(
                                           color: AppColors.white,
                                           borderRadius: BorderRadius.all(
                                               Radius.circular(3))))
                                     ],
                                   ),
                                   const SizedBox(height: 5),
                                   Container( height:SizeConfig.blockSizeHorizontal*11,
                                       width:  SizeConfig.screenWidth,
                                       decoration: const BoxDecoration(
                                           color: AppColors.white,
                                           borderRadius: BorderRadius.all(
                                               Radius.circular(10.0))))
                                 ],
                               ))
                       )]
                 )

                     :

                 Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         TextWidget(text: 'SELECT LOCATION', fontSize: SizeConfig.regularFontSize,
                         fontFamily: FontFamily.fontMedium,color: AppColors.normalTextColor,),
                         InkWell(
                           onTap: (){
                            controller.alertDialog();},
                             child: Icon(Icons.edit, color: AppColors.colorPrimary,size: SizeConfig.semiBoldFontSize))
                       ],
                     ),
                     Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Icon(Icons.location_pin,size: SizeConfig.blockSizeHorizontal*5,color: AppColors.blackText,),
                             Expanded(
                               child: Obx(()=>
                               TextWidget(
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 1,
                                 text: controller.street.value, color: AppColors.blackText,
                               fontFamily: FontFamily.fontMedium,
                               fontSize: SizeConfig.mediumFontSize,),
                               )),
                           ],
                         ),
                         Obx(() =>
                         TextWidget(overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           text: controller.adminArea.value, fontSize: SizeConfig.regularFontSize,
                           color: AppColors.normalTextColor,fontFamily: FontFamily.fontRegular,))

                       ],
                     ),
                     ButtonWidget(text: 'CONFIRM LOCATION', onPressed: (){
                      controller.confirmButtonClick();
                     })
                   ],
                 )),
                   InkWell(onTap: (){controller.locateMe();},
                     child: Container(
                         height: SizeConfig.blockSizeHorizontal*9,
                         width: SizeConfig.blockSizeHorizontal*34,
                         padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*1.25),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(13),
                             color: AppColors.white),
                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(Icons.gps_fixed,color: AppColors.colorPrimary,size:  SizeConfig.blockSizeHorizontal*5),
                             Expanded(
                               child: TextWidget(text: 'LOCATE ME',
                                   color: AppColors.colorPrimary,
                                   textAlign: TextAlign.end,
                                   fontSize: SizeConfig.regularFontSize),
                             )
                           ],
                         ))
                   )


                 ]


                 ),
               )),
           Align(alignment: AlignmentDirectional.topStart,
             child: InkWell(onTap: (){
               controller.disposeMapController();
               Get.back();
               },
               child: Container(
                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5,
                       top: SizeConfig.blockSizeHorizontal*1.25),
                   height: SizeConfig.blockSizeHorizontal * 11.25,
                   width:SizeConfig.blockSizeHorizontal * 11.25,
                   decoration: BoxDecoration(color: AppColors.white,
                       borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 11.25)
                   ),
                   child: Center(
                     child: Icon(Icons.arrow_back, color: AppColors.blackText,
                       size: SizeConfig.blockSizeHorizontal* 5,
                     ),
                   ))
             ),
           ),
            const Align(
             alignment: Alignment.center,
             child:
             Icon(
             Icons.location_on,
             size: 50,
             color: AppColors.colorPrimary,
             ),
           )
         ],
       ),
      )),
    ));
  }
}