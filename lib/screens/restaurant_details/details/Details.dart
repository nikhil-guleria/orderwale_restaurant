import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_switch.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/restaurant_details/details/DetailsController.dart';
import 'package:get/get.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/size_config.dart';
import '../model/restaurant_details_model.dart';

// ignore: must_be_immutable
class Details extends StatelessWidget {
   Details({super.key,
    required this.details, required this.isEdit
  });
   RestaurantDetailsModel  details;
   bool isEdit;
  @override
  Widget build(BuildContext context) {
    DetailsController controller = Get.put(DetailsController(details));
    return Scaffold(
        backgroundColor: AppColors.white,
       body: Container(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
             padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*4,
          right: SizeConfig.blockSizeHorizontal*4),
           child: SingleChildScrollView(
             physics: const AlwaysScrollableScrollPhysics(),
             child: Column( crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeHorizontal*4),
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

                      TextSpan(text: "${controller.restaurantDetails.value.address}",
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
               width: SizeConfig.blockSizeHorizontal*32,
                child: Column(
                    children: [ Icon(Icons.watch_later_outlined,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                      TextWidget(text: "${controller.extractTime(controller.restaurantDetails.value.openingTime)} - ${controller.extractTime(controller.restaurantDetails.value.closingTime)}",
                          fontSize: SizeConfig.blockSizeHorizontal*2.8,
                         color: AppColors.blackShades,fontFamily: FontFamily.fontMedium)]),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal*30,
                child: Column(
                    children: [ Icon(Icons.phone,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                      TextWidget(
                          text: "${controller.restaurantDetails.value.phone}",
                        fontSize: SizeConfig.blockSizeHorizontal*2.9,
                        color: AppColors.blackShades,fontFamily: FontFamily.fontMedium,)]),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal*30,
                child: InkWell(
                  onTap: (){
                    controller.openGoogleMap();
                  },
                  child: Column(
                      children: [ Icon(Icons.map,size: SizeConfig.semiBoldFontSize,color: AppColors.colorPrimary),
                        TextWidget(text: "View on Map",
                            fontSize: SizeConfig.blockSizeHorizontal*2.9,
                            color: AppColors.blackShades,fontFamily: FontFamily.fontMedium)]),
                ),
              )
            ],),

          SizedBox(height: SizeConfig.blockSizeHorizontal*7),

          // disabled restaurant availability
          /*Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: 'Restaurant Availability', fontSize: SizeConfig.regularFontSize,
                          fontFamily: FontFamily.fontMedium,color: AppColors.blackShades,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,
                        fontSize: SizeConfig.regularFontSize,color: Colors.black,),
                    ],
                  ),
                ),

                SizedBox( width: SizeConfig.blockSizeHorizontal*41,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(()=>
                          customSwitch(
                              switchValue: controller.restaurantDetails.value.isAvailable == 1,
                              onTap: (){
                                print("restaurant avail value change  --- ${!(controller.restaurantDetails.value.isAvailable == 1)}");
                                controller.changeRestaurantAvailability(!(controller.restaurantDetails.value.isAvailable == 1));
                              }
                          )),
                    ],
                  ),
                ),
                 *//*   SizedBox( width: SizeConfig.blockSizeHorizontal*41,
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(()=>
                          TextWidget(text: controller.restaurantDetails.value.isAvailable == 1 ?  "Open" : "Closed",
                            fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.regularFontSize,)),

                          SizedBox(width: SizeConfig.blockSizeHorizontal*1),

                          Obx(() =>
                              Transform.scale(scale: 0.9,
                                child: CupertinoSwitch(
                                  value: controller.restaurantDetails.value.isAvailable == 1,
                                  onChanged: (bool value) {
                                    controller.changeRestaurantAvailability(value);
                                  },
                                  activeColor: CupertinoColors.activeGreen,
                                  thumbColor: CupertinoColors.white,
                                  trackColor: Colors.red,),
                              ))

                        ],
                      ),
                ),*//*
               ]),
          SizedBox(height: SizeConfig.blockSizeHorizontal*2.5),*/
          Row(
              children: [
                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: 'Delivery Availability', fontSize: SizeConfig.regularFontSize,
                          fontFamily: FontFamily.fontMedium,color: AppColors.blackShades,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,
                        fontSize: SizeConfig.regularFontSize,color: Colors.black,),
                    ],
                  ),
                ),
                SizedBox( width: SizeConfig.blockSizeHorizontal*41,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(()=>
                          customSwitch(
                              switchValue: controller.restaurantDetails.value.deliveryAvailability == "1",
                              onTap: (){
                                controller.changeDeliveryAvailability(!(controller.restaurantDetails.value.deliveryAvailability == "1"));
                              }
                          )),
                    ],
                  ),
                ),


               /* SizedBox( width: SizeConfig.blockSizeHorizontal*41,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(()=>
                          TextWidget(text: controller.restaurantDetails.value.deliveryAvailability == "1" ?  "Open" : "Closed",
                            fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.regularFontSize,),
                      ),

                      SizedBox(width: SizeConfig.blockSizeHorizontal*1),

                      Obx(() =>
                          Transform.scale(scale: 0.9,
                            child: CupertinoSwitch(
                              value: controller.restaurantDetails.value.deliveryAvailability == "1",
                              onChanged: (bool value) {
                                controller.changeDeliveryAvailability(value);
                              },
                              activeColor: CupertinoColors.activeGreen,
                              thumbColor: CupertinoColors.white,
                              trackColor: Colors.red,),
                          ))

                    ],
                  ),
                ),*/]),
          SizedBox(height: SizeConfig.blockSizeHorizontal*1),
          const Divider(),
          SizedBox(height: SizeConfig.blockSizeHorizontal*1),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(text: "Avg. cost/meal",fontFamily: FontFamily.fontMedium,
                          color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                    ],
                  )),

              SizedBox(
                width: SizeConfig.blockSizeHorizontal*41,
                child:  TextWidget(text: " ${AppStrings.currSymbolIn}${controller.restaurantDetails.value.averagePrice}",
                  fontFamily: FontFamily.fontMedium,
                  color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
              ),
            ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextWidget(text: "Min. Order Price",fontFamily: FontFamily.fontMedium,
                        color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                    ),
                    TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                  ],
                )),

            SizedBox(
              width: SizeConfig.blockSizeHorizontal*41,
              child:  TextWidget(text: " ${AppStrings.currSymbolIn}${controller.restaurantDetails.value.minOrderPrice}",
                fontFamily: FontFamily.fontMedium,
                color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
            ),
          ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(text: "Min. Delivery Charges",fontFamily: FontFamily.fontMedium,
                          color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                    ],
                  )),

              SizedBox(
                width: SizeConfig.blockSizeHorizontal*41,
                child:  TextWidget(text: " ${AppStrings.currSymbolIn}${controller.restaurantDetails.value.minDeliveryCharges}",
                  fontFamily: FontFamily.fontMedium,
                  color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
              ),
            ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*3,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(text: "Charges Per KM",fontFamily: FontFamily.fontMedium,
                          color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                    ],
                  )),

              SizedBox(
                width: SizeConfig.blockSizeHorizontal*41,
                child:  TextWidget(text: " ${AppStrings.currSymbolIn}${controller.restaurantDetails.value.chargesPerKm}",
                  fontFamily: FontFamily.fontMedium,
                  color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
              ),
            ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(text: "Free Delivery Amount",fontFamily: FontFamily.fontMedium,
                          color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                    ],
                  )),

              SizedBox(
                width: SizeConfig.blockSizeHorizontal*41,
                child:  TextWidget(text: " ${AppStrings.currSymbolIn}${controller.restaurantDetails.value.freeDeliveryAmount}",
                  fontFamily: FontFamily.fontMedium,
                  color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
              ),
            ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(text: "Min. Delivery Distance",fontFamily: FontFamily.fontMedium,
                          color: AppColors.blackShades,fontSize: SizeConfig.regularFontSize,),
                      ),
                      TextWidget(text: ":",fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: Colors.black,),
                    ],
                  )),

              SizedBox(
                width: SizeConfig.blockSizeHorizontal*41,
                child:  TextWidget(text: " ${controller.restaurantDetails.value.minDeliveryDistance} km",
                  fontFamily: FontFamily.fontMedium,
                  color: Colors.black,fontSize: SizeConfig.mediumFontSize,),
              ),
            ],),
          SizedBox(height: SizeConfig.blockSizeHorizontal*4),

        ],
             ),
           )
       ),
    floatingActionButton: Visibility(
      visible: isEdit,
      child: FloatingActionButton(
        onPressed: (){ Get.toNamed(AppRoutes.manageRestaurant, arguments: controller.restaurantDetails.value.restaurantId);},
backgroundColor: AppColors.colorPrimary,
        child: const Icon(Icons.edit, color: AppColors.white,),
      ),
    ),
    );
  }

}