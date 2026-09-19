import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/select_delivery_area/delivery_area_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../constant/app_colors.dart';
import '../../utils/size_config.dart';

class DeliveryArea extends GetView<DeliveryAreaController> {
  const DeliveryArea({super.key});

  @override
  Widget build(BuildContext context) {
    return  PopScope(
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
          child: Obx(() =>  Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // google map
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
                          onTap: controller.alreadyExists.value
                              ? null : controller.addTapPoint,
                          polylines: controller.alreadyExists.value ?
                          controller.previousPolyLine() : controller.createPolyLines(),
                          onMapCreated: (GoogleMapController controller1) {
                            controller.updateMapController(controller1);
                            controller.getUserLocation();
                          }
                      ),
                    ) ),

                // back button
                Align(alignment: AlignmentDirectional.topStart,
                  child: InkWell(onTap: (){
                    controller.disposeMapController();
                    Get.back();
                  },
                    child: Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5,
                        top: SizeConfig.blockSizeHorizontal* 1.25),
                        height: SizeConfig.blockSizeHorizontal*11.25,
                        width:SizeConfig.blockSizeHorizontal* 11.25,
                        decoration: BoxDecoration(color: AppColors.white,
                            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*11.25)
                        ),
                        child:  Center(
                          child: Icon(Icons.arrow_back, color: AppColors.blackText,
                            size: SizeConfig.blockSizeHorizontal*5,
                          ),
                        )),
                  ),
                ),


                // clear points on conditions
                Align(alignment: AlignmentDirectional.topEnd,
                  child:
                      controller.alreadyExists.value ?

                  InkWell(
                    onTap: controller.clearPreviousArea,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3,
                          top: SizeConfig.blockSizeHorizontal*2.25),
                      padding:  EdgeInsets.all( SizeConfig.blockSizeHorizontal*2),
                      child: TextWidget(text: "Clear Area",
                        fontSize: SizeConfig.regularFontSize,
                        fontFamily: FontFamily.fontRegular,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600),
                    ),
                  )


               : controller.tapPoints.isNotEmpty ?
                      InkWell(onTap:controller.removePolyLine,
                        child: Container(
                            margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2.5,
                            top: SizeConfig.blockSizeHorizontal*1.25),
                            height: SizeConfig.blockSizeHorizontal*11.25,
                            width:SizeConfig.blockSizeHorizontal*11.25,
                            decoration: BoxDecoration(color: AppColors.white,
                                borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*11.25)
                            ),
                            child:  Center(
                              child: Icon(Icons.undo_sharp, color: AppColors.red,
                                size: SizeConfig.blockSizeHorizontal*5,
                              ),
                            )),
                      )

                  : controller.resetArea.value &&
                          controller.previousAreaList.isEmpty ?

                      InkWell(
                        onTap: controller.resetPreviousArea,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3,
                              top: SizeConfig.blockSizeHorizontal*2.25),
                          padding:  EdgeInsets.all( SizeConfig.blockSizeHorizontal*2),
                          child: TextWidget(text: "Reset Area",
                              fontSize: SizeConfig.regularFontSize,
                              fontFamily: FontFamily.fontRegular,
                              color: AppColors.red,
                              fontWeight: FontWeight.w600),
                        ),
                      )

                  : SizedBox(),
                ),

                // confirm area
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                   Visibility(
                    visible: controller.tapPoints.length > 3,
                    child: Padding(
                      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                      child: ButtonWidget(text: 'CONFIRM AREA', onPressed: (){
                        controller.submitBtnClick();
                      }),
                    ),
                  ),
                ),



                 // centre loader
                 Visibility(
                   visible: controller.showLoader.value,
                   child: Align(
                    alignment: Alignment.center,
                    child:
                   ColorLoader(),
                ),
                 )
              ],
            ),
      )),
    ));
  }



}