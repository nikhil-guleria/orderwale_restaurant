import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'MapController.dart';

class CustomMap extends GetView<MapController> {
  const CustomMap({super.key});



  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          controller.mapController?.dispose();
          Get.back();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child:

        controller.variableLatLng.value == LatLng(0.0,0.0) ? Center(child: ColorLoader())

       : Stack(
         alignment: Alignment.center,
         children: <Widget>[


           Positioned.fill(
             child: SizedBox(
               height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
               child:
                 GoogleMap (
                 zoomControlsEnabled: false,
                 mapType: MapType.normal,
                 onCameraMove: controller.onCameraMove,
                   onCameraIdle: controller.onCameraIdle,

                   onMapCreated: (GoogleMapController controller1) {
                   controller.mapController = controller1;
                     controller.mapIdController.complete(controller1);
                   },
                 initialCameraPosition: CameraPosition(
                     target: controller.variableLatLng.value, zoom: 17.3),

                  ),
               ) ),
           //),



           Align(
            alignment: AlignmentDirectional.bottomCenter,
               child:
               SizedBox(height: SizeConfig.blockSizeHorizontal*55,
                 child: Stack( alignment: Alignment.topCenter,
                     children: [
                     Container(height: SizeConfig.blockSizeHorizontal*43,
                   margin: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*12),
                   padding: EdgeInsets.all( SizeConfig.blockSizeHorizontal*3.25),
                   color: colorWhite,
                 child:

                 controller.loadLatLng.value ?
                 Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       LinearProgressIndicator(
                         minHeight: 2.5,
                         backgroundColor: Colors.grey[200],
                         color: colorPrimary,
                       ),
                       Shimmer.fromColors(
                           baseColor: Colors.grey[300]!,
                           highlightColor: Colors.grey[100]!,
                           enabled: true,
                           child:
                           Container(
                               padding: const EdgeInsets.symmetric(horizontal: 13),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(height: 16.5, width: SizeConfig.blockSizeHorizontal*25, decoration: const BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.all(
                                           Radius.circular(3)))),
                                   const SizedBox(height: 5),
                                   Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: [
                                           Container(height: 16.5, width: 15,  decoration: const BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.all(
                                                   Radius.circular(3)))),
                                           const SizedBox(width: 5),
                                           Expanded(
                                             child: Container(height: 16.5, decoration: const BoxDecoration(
                                                 color: Colors.white,
                                                 borderRadius: BorderRadius.all(
                                                     Radius.circular(3)))),
                                           )
                                         ],
                                       ),
                                       const SizedBox(height: 5),
                                       Container(height: 16.5, width: Get.width, decoration: const BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.all(
                                               Radius.circular(3))))
                                     ],
                                   ),
                                   const SizedBox(height: 5),
                                   Container( height:SizeConfig.blockSizeHorizontal*11,
                                       width:  SizeConfig.screenWidth,
                                       decoration: const BoxDecoration(
                                           color: Colors.white,
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
                         fontFamily: fontMedium,color: normalTextColor,),
                         InkWell(
                           onTap: (){
                            controller.alertDialog();},
                             child: Icon(Icons.edit, color: colorPrimary,size: SizeConfig.semiBoldFontSize))
                       ],
                     ),
                     Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Icon(Icons.location_pin,size: SizeConfig.blockSizeHorizontal*5,color: colorBlack,),
                             Expanded(
                               child: Obx(()=>
                               TextWidget(
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 1,
                                 text: controller.street.value, color: colorBlack,
                               fontFamily: fontMedium,
                               fontSize: SizeConfig.mediumFontSize,),
                               )),
                           ],
                         ),
                         Obx(() =>
                         TextWidget(overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           text: controller.adminArea.value, fontSize: SizeConfig.regularFontSize,
                           color: normalTextColor,fontFamily: fontRegular,))

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
                             color: Colors.white),
                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(Icons.gps_fixed,color: colorPrimary,size:  SizeConfig.blockSizeHorizontal*5),
                             Expanded(
                               child: TextWidget(text: 'LOCATE ME',
                                   color: colorPrimary,
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
               controller.mapController?.dispose();
               Get.back();
               },
               child: Container(
                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5,
                       top: SizeConfig.blockSizeHorizontal*1.25),
                   height: SizeConfig.blockSizeHorizontal * 11.25,
                   width:SizeConfig.blockSizeHorizontal * 11.25,
                   decoration: BoxDecoration(color: colorWhite,
                       borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 11.25)
                   ),
                   child: Center(
                     child: Icon(Icons.arrow_back, color: colorBlack,
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
             color: colorPrimary,
             ),
           )
         ],
       ),
      )),
    ));
  }
}