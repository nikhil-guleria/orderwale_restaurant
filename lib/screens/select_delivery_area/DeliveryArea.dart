import 'package:flutter/material.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/screens/select_delivery_area/DeliveryAreaController.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../constant/app_color.dart';
import '../../utils/SizeConfig.dart';

class DeliveryArea extends GetView<DeliveryAreaController> {
  const DeliveryArea({super.key});

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
        controller.variableLatLng.value == const LatLng(0.0,0.0) ? Center(child: ColorLoader())

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

                        onMapCreated: (GoogleMapController controller1) {
                          controller.mapController = controller1;
                          controller.mapIdController.complete(controller1);
                        },
                        initialCameraPosition: CameraPosition(
                            target: controller.variableLatLng.value, zoom: 13.5),
                        onTap: controller.alreadyExist.value ? null : controller.addTapPoint,
                        polylines: controller.alreadyExist.value ?
                        controller.previousPolyLine() : controller.createPolyLines(),
                      ),
                    ) ),

                Align(alignment: AlignmentDirectional.topStart,
                  child: InkWell(onTap: (){
                    controller.mapController?.dispose();
                    Get.back();
                  },
                    child: Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5,
                        top: SizeConfig.blockSizeHorizontal* 1.25),
                        height: SizeConfig.blockSizeHorizontal*11.25,
                        width:SizeConfig.blockSizeHorizontal* 11.25,
                        decoration: BoxDecoration(color: colorWhite,
                            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*11.25)
                        ),
                        child:  Center(
                          child: Icon(Icons.arrow_back, color: colorBlack,
                            size: SizeConfig.blockSizeHorizontal*5,
                          ),
                        )),
                  ),
                ),


                Align(alignment: AlignmentDirectional.topEnd,
                  child:
                      controller.alreadyExist.value ?

                  InkWell(
                    onTap: (){
                      controller.clearPreviousArea();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3,
                          top: SizeConfig.blockSizeHorizontal*2.25),
                      padding:  EdgeInsets.all( SizeConfig.blockSizeHorizontal*2),
                      child: TextWidget(text: "Clear Area",
                        fontSize: SizeConfig.regularFontSize,
                        fontFamily: fontRegular,
                        color: Colors.red,
                        weight: FontWeight.w600),
                    ),
                  )


               : Visibility(
                  visible:  controller.tapPoints.isNotEmpty,
                  child:
                        InkWell(onTap: (){
                      controller.removePolyLine();
                    },
                      child: Container(margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2.5,
                          top: SizeConfig.blockSizeHorizontal*1.25),
                          height: SizeConfig.blockSizeHorizontal*11.25,
                          width:SizeConfig.blockSizeHorizontal*11.25,
                          decoration: BoxDecoration(color: colorWhite,
                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*11.25)
                          ),
                          child:  Center(
                            child: Icon(Icons.undo_sharp, color: Colors.red,
                              size: SizeConfig.blockSizeHorizontal*5,
                            ),
                          )),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                   Visibility(
                    visible: controller.tapPoints.length > 3,
                    child: Padding(
                      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                      child: ButtonWidget(text: 'CONFIRM AREA', onPressed: (){
                        controller.confirmAreaClick();
                      }),
                    ),
                  ),
                ),



                 Visibility(
                   visible: controller.confirmLoader.value,
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