import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_switch.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/restaurant_details/details/details_controller.dart';
import 'package:get/get.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../utils/size_config.dart';
import '../model/restaurant_details_model.dart';

class Details extends GetView<DetailsController> {
   const Details({super.key, required this.details,
  });
   final RestaurantDetailsModel  details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
       body: Container(height: SizeConfig.screenHeight,
           width: SizeConfig.screenWidth,
             padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*4,
          right: SizeConfig.blockSizeHorizontal*4),
           child: SingleChildScrollView(
             physics: const AlwaysScrollableScrollPhysics(),
             child: Column( crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: SizeConfig.blockSizeHorizontal*4),

          // restaurant address
          RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child:  Icon(Icons.location_on,color: AppColors.colorPrimary,size:SizeConfig.mediumFontSize),
                      ),
                      WidgetSpan(
                        child:   SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                      ),

                      TextSpan(text: details.address ?? '',
                        style: TextStyle(fontSize: SizeConfig.regularFontSize,
                            color: AppColors.blackShades,
                            fontFamily: FontFamily.fontRegular),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: SizeConfig.blockSizeHorizontal*1.5),
          const Divider(),
          SizedBox(height: SizeConfig.blockSizeHorizontal*1.5),

          // timing , phone & map location
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // restaurant timing
              SizedBox(
               width: SizeConfig.blockSizeHorizontal*32,
                child: Column(
                    children: [
                      Icon(Icons.watch_later_outlined,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                      TextWidget(text: "${controller.extractTime(details.openingTime)} - ${controller.extractTime(details.closingTime)}",
                          fontSize: SizeConfig.blockSizeHorizontal*2.8,
                         color: AppColors.blackShades,fontFamily: FontFamily.fontMedium)]),
              ),

              // restaurant phone number
              SizedBox(
                width: SizeConfig.blockSizeHorizontal*30,
                child: Column(
                    children: [
                      Icon(Icons.phone,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                      TextWidget(
                          text: details.phone ?? '',
                        fontSize: SizeConfig.blockSizeHorizontal*2.9,
                        color: AppColors.blackShades,fontFamily: FontFamily.fontMedium,)]),
              ),


              // restaurant map location
              SizedBox(
                width: SizeConfig.blockSizeHorizontal*30,
                child: InkWell(
                  onTap: (){controller.openGoogleMap(
                      details.latitude ?? '',
                      details.longitude ?? '');},
                  child: Column(
                      children: [ Icon(Icons.map,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                        TextWidget(text: AppStrings.restaurantViewOnMap,
                            fontSize: SizeConfig.blockSizeHorizontal*2.9,
                            color: AppColors.blackShades,fontFamily: FontFamily.fontMedium)]),
                ),
              )
            ],),

          SizedBox(height: SizeConfig.blockSizeHorizontal*7),


          // restaurant delivery
           buildDeliveryAvailability(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeHorizontal*1),
            child: const Divider(),
          ),

          // fssai  number
          if((details.fssaiNo ?? '').trim().isNotEmpty)
          buildFieldWithColon(
            title: AppStrings.restaurantFssaiNo,
            value: details.fssaiNo ?? ''
          ),

          // average price
          buildFieldWithColon(
            title: AppStrings.restaurantAveragePrice,
            value: "${AppStrings.currSymbolIn}${details.averagePrice ?? ''}"
          ),

          // min order price
          buildFieldWithColon(
            title: AppStrings.restaurantMinOrderPrice,
            value: "${AppStrings.currSymbolIn}${details.minOrderPrice ?? ''}"
          ),


          // delivery charge
          buildFieldWithColon(
            title: AppStrings.restaurantMinDeliveryCharge,
            value: "${AppStrings.currSymbolIn}${details.minDeliveryCharges ?? ''}"
          ),


          // charges per km
          buildFieldWithColon(
            title: AppStrings.restaurantChargesPerKm,
            value: "${AppStrings.currSymbolIn}${details.chargesPerKm ?? ''}"
          ),

          // free delivery amount
          buildFieldWithColon(
            title: AppStrings.restaurantFreeDeliveryAmount,
            value: "${AppStrings.currSymbolIn}${details.freeDeliveryAmount ?? ''}"
          ),

          // min delivery distance
          buildFieldWithColon(
            title: AppStrings.restaurantMinDeliveryDistance,
            value: "${details.minDeliveryDistance} km"
          ),
        ]),
           )
       ),
    );
  }


  Widget buildFieldWithColon({
     String? title, String? value}){
    return Padding(
      padding: EdgeInsets.only(
          bottom: SizeConfig.blockSizeHorizontal*3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextWidget(text: title ?? '',
                      fontFamily: FontFamily.fontMedium,
                      color: AppColors.blackShades,
                      fontSize: SizeConfig.regularFontSize,),
                  ),
                  TextWidget(text: ":",
                    fontFamily: FontFamily.fontRegular,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.blackText,),
                ],
              )),

          SizedBox(
            width: SizeConfig.blockSizeHorizontal*41,
            child:  TextWidget(text: " $value",
              fontFamily: FontFamily.fontMedium,
              color: AppColors.blackText,fontSize: SizeConfig.mediumFontSize,),
          ),
        ],),
    );
  }


  Widget buildDeliveryAvailability(){
    if(controller.deliveryAvailability.value.trim().isEmpty){
    controller.deliveryAvailability.value = details.deliveryAvailability ?? '';}
    return Row(
        children: [
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(text: AppStrings.restaurantDeliveryAvailability,
                    fontSize: SizeConfig.regularFontSize,
                    fontFamily: FontFamily.fontMedium,color: AppColors.blackShades,),
                ),
                TextWidget(text: ":",fontFamily: FontFamily.fontRegular,
                  fontSize: SizeConfig.regularFontSize,color: AppColors.black,),
              ],
            ),
          ),
          SizedBox( width: SizeConfig.blockSizeHorizontal*41,
            child: Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(()=>
                    customSwitch(
                        switchValue: controller.deliveryAvailability.value == "1",
                        onTap: (){
                          controller.changeDeliveryAvailability(!(controller.deliveryAvailability.value == "1"));
                        }
                    )),
              ],
            ),
          )
        ]);
  }

}