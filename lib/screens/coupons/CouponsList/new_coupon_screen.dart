import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:get/get.dart';

import 'coupons_controller.dart';

class NewCouponScreen extends GetView<CouponsController> {
  const NewCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =  Scaffold(
   backgroundColor: AppColors.white,
     appBar: buildAppBar(title: AppStrings.couponsListTitle),
   body: SafeArea(
     child: RefreshIndicator(
       color: AppColors.colorPrimary,
       onRefresh: controller.pullToRefresh,
       child: Container(
           color: AppColors.white,
           padding: EdgeInsets.symmetric(horizontal: 8,
               vertical: SizeConfig.blockSizeHorizontal*3),
         child: ListView(
           physics: AlwaysScrollableScrollPhysics(),
           children: [
       Obx(()=>   AnimatedSwitcher(
         duration: const Duration(milliseconds: 777),
           transitionBuilder: (child, animation) => FadeTransition(
             opacity: animation,
             child: child,
           ),
           child: controller.couponsList.isNotEmpty
               || controller.showLoader.value ?
            Column(
       children: controller.couponsList
           .asMap().entries.map((entry) {
         //final index = entry.key;
         final coupon = entry.value;
         return InkWell(
           highlightColor: AppColors.transparent,
           splashColor: AppColors.transparent,
           onTap: (){
             controller.goToUpdateCoupon(coupon);
           },
           child: Container(
             color: AppColors.white,
             margin: EdgeInsets.only(bottom: 24),
             constraints: BoxConstraints(
                 maxWidth: 274,
                 maxHeight: 100,
                 minHeight: 0,
                 minWidth: 0
             ),
             child: Stack(
               children: [
                 !controller.isCouponValid(coupon.endDate ?? "") ?
                 Row(
                   children: [
                     Flexible(
                       flex: 1,
                       child: ColorFiltered(
                         colorFilter: ColorFilter.mode(
                           AppColors.grey,
                           BlendMode.saturation,
                         ),
                         child: Container(
                           width: 92,
                           margin: EdgeInsets.only(left: 1),
                           child: ClipRRect(
                             child: CachedNetworkImage(
                               height: 100, width: 100,
                               fit: BoxFit.cover,
                               imageUrl: coupon.thumbnailUrl ?? '',
                               placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                               errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent,fit: BoxFit.cover),
                             )
                           ),
                         ),
                       ),
                     ),
                     Expanded(
                       flex: 2,
                       child: Container(
                         width: 180,
                         margin: EdgeInsets.only(right: 1),
                         padding: EdgeInsets.symmetric(
                             horizontal: 16,
                             vertical: 12
                         ),
                         decoration: BoxDecoration(
                             color: AppColors.disabledBorderColor
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             RichText(
                                 maxLines: 1,
                                 text: TextSpan(
                                     text: " ",
                                     style: TextStyle(fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                         color: AppColors.blackShades,
                                     ),
                                     children: [
                                       TextSpan(
                                         text: coupon.discountType == 1 ?
                                         "${coupon.discount ?? 0}%" : "${AppStrings.currSymbolIn}${coupon.discount ?? 0}",
                                         style: TextStyle(fontSize: 18,
                                           color: AppColors.blackShades,
                                             fontWeight: FontWeight.bold,
                                            ),
                                       ),
                                       TextSpan(
                                           text: "  OFF",
                                           style: TextStyle(fontSize: 12,
                                               color: AppColors.blackShades,
                                           )
                                       )
                                     ]
                                 )),
                             TextWidget(text: coupon.couponCode ?? '-',
                               maxLines: 1,
                               fontSize: 14,
                               fontWeight: FontWeight.bold,
                               color: AppColors.blackShades),

                             TextWidget(text: "Valid Till ${coupon.endDate ?? '-'}",
                               maxLines: 1,
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: AppColors.blackShades,
                             ),
                           ],
                         ),
                       ),
                     )
                   ],
                 )

                     : Row(
                   children: [
                     Flexible(
                       flex: 1,
                       child: Container(
                         width: 92,
                         margin: EdgeInsets.only(left: 1),
                         child: ClipRRect(
                           child: CachedNetworkImage(
                             height: 100, width: 100,
                             fit: BoxFit.cover,
                             imageUrl: coupon.thumbnailUrl ?? '',
                             placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                             errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent,fit: BoxFit.cover),
                           )
                         ),
                       ),
                     ),
                     Expanded(
                       flex: 2,
                       child: Container(
                         width: 180,
                         margin: EdgeInsets.only(right: 1),
                         padding: EdgeInsets.symmetric(
                             horizontal: 16,
                             vertical: 12
                         ),
                         decoration: BoxDecoration(
                             color: AppColors.warmToneGrey
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             RichText(
                                 maxLines: 1,
                                 text: TextSpan(
                                     text: " ",
                                     style: TextStyle(fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                         color: AppColors.blackText,
                                     ),
                                     children: [
                                       TextSpan(
                                         text: coupon.discountType == 1 ?
                                         "${coupon.discount ?? 0}%" : "${AppStrings.currSymbolIn}${coupon.discount ?? 0}",
                                         style: TextStyle(
                                             fontSize: 18,
                                             color: AppColors.blackText,
                                             fontWeight: FontWeight.bold),
                                       ),
                                       TextSpan(
                                           text: "  OFF",
                                           style: TextStyle(
                                               fontSize: 12,
                                               color: AppColors.blackText
                                           )
                                       )
                                     ]
                                 )),
                             TextWidget(text: coupon.couponCode ?? '-',
                               maxLines: 1,
                               fontSize: 14,
                               fontWeight: FontWeight.bold,
                               ),

                             TextWidget(text: "Valid Till ${coupon.endDate ?? '-'}",
                               maxLines: 1,
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                             ),

                           ],
                         ),
                       ),
                     )
                   ],
                 ),

                 // left cutouts
                 Positioned(
                   top: 2,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),
                 Positioned(
                   top: 16,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),

                 Positioned(
                   top: 30,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),

                 Positioned(
                   top: 44,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),

                 Positioned(
                   top: 58,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),

                 Positioned(
                   top: 72,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),

                 Positioned(
                   top: 86,
                   left: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6,
                   ),
                 ),


                 // right cutouts
                 Positioned(
                   top: 2,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 16,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 30,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 44,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 58,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 72,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),
                 Positioned(
                   top: 86,
                   right: -8,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 6.5,
                   ),
                 ),


                 // center cutouts
                 Positioned(
                   top: -10,
                   left: 84,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 7,
                   ),
                 ),

                 Positioned(
                   bottom: -10,
                   left: 84,
                   child: CircleAvatar(
                     backgroundColor: AppColors.white,
                     radius: 7,
                   ),
                 ),

               ],
             ),
           ),
         );
       }).toList(),
     )
           : Center(
      child: TextWidget( text:  AppStrings.couponsListEmptyMsg, color: AppColors.colorPrimary,
        fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.mediumFontSize,)
    )
         ))]
       )),
     )),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorPrimary,
        onPressed: () {
          controller.goToAddCoupon();
        },
        child: const Icon(Icons.add,color: AppColors.white,),

      ),


    );

    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack( alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: AppColors.white),
          ),
          ColorLoader()

        ],
      )
          : const SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);

  }

}


/*Obx(()=> controller.couponsList.isNotEmpty ?
     RefreshIndicator(
       color: AppColors.colorPrimary,
       onRefresh: controller.pullToRefresh,
       child: Container(
         color: AppColors.white,
         padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5,
             vertical: SizeConfig.blockSizeHorizontal*3),
         child: ListView.builder(
           physics: const AlwaysScrollableScrollPhysics(),
             shrinkWrap: true,
             itemCount: controller.couponsList.length,
             padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal*20),
             itemBuilder: (context,index){
               return
                 InkWell(
                   onTap: (){
                    controller.goToUpdateCoupon(index);
                   },
                   child: Container(width: Get.width,
                     height: SizeConfig.blockSizeHorizontal*41,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(
                             15.0),
                         boxShadow: [
                           BoxShadow(
                               color: AppColors.black.withAlpha((0.2 * 255).round()),
                               offset: const Offset(0.2, 0.3),
                             blurRadius: 0.3,
                             spreadRadius: 0.3,
                             blurStyle: BlurStyle.inner

                           ),
                         ],
                         color: AppColors.white
                     ),
                     margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal*4),
                     child: Row(
                       children: [
                         SizedBox( width: SizeConfig.blockSizeHorizontal*12,
                           child: Stack(
                             alignment: Alignment.center,
                             children: [
                               Container(
                                 decoration: const BoxDecoration(
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0),),
                                   color : AppColors.colorPrimary,
                                 ),
                                 width: SizeConfig.blockSizeHorizontal*12,
                               ),
                               controller.couponsList.elementAt(index).discountType == 1 ?
                               RotatedBox(
                                 quarterTurns: 3,
                                 child: TextWidget(  text:
                                    "${controller.couponsList.elementAt(index).discount}% OFF",
                                     fontSize: SizeConfig.blockSizeHorizontal*5,
                                     color: AppColors.white,
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                     weight: FontWeight.w600),
                               )
                              : RotatedBox(
                                 quarterTurns: 3,
                                 child: TextWidget(  text:"FLAT OFF",
                                     fontSize: SizeConfig.blockSizeHorizontal*5,color: AppColors.white,
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                     weight: FontWeight.w600),
                               )



                               ,
                               Positioned(
                                 top: SizeConfig.blockSizeHorizontal*10,
                                 left: -SizeConfig.blockSizeHorizontal*1.75,
                                 child:  CircleAvatar(
                                   backgroundColor: AppColors.white,
                                   radius: SizeConfig.blockSizeHorizontal*1.75,
                                 ),
                               ),
                               Positioned(
                                 top: SizeConfig.blockSizeHorizontal*16,
                                 left: -SizeConfig.blockSizeHorizontal*1.75,
                                 child:   CircleAvatar(
                                   backgroundColor: AppColors.white,
                                   radius: SizeConfig.blockSizeHorizontal*1.75,
                                 ),
                               ),
                               Positioned(
                                 top: SizeConfig.blockSizeHorizontal*22,
                                 left: -SizeConfig.blockSizeHorizontal*1.75,
                                 child:  CircleAvatar(
                                   backgroundColor: AppColors.white,
                                   radius: SizeConfig.blockSizeHorizontal*1.75,
                                 ),
                               ),
                               Positioned(
                                 top: SizeConfig.blockSizeHorizontal*28,
                                 left: -SizeConfig.blockSizeHorizontal*1.75,
                                 child:  CircleAvatar(
                                   backgroundColor: AppColors.white,
                                   radius: SizeConfig.blockSizeHorizontal*1.75,
                                 ),
                               )
                             ],
                           ),
                         ),
                         Container(width:SizeConfig.blockSizeHorizontal*78,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0) ),
                             color: AppColors.white,
                           ),
                           padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.75),
                           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               SizedBox(width:SizeConfig.blockSizeHorizontal*70,
                                 child: Row(children: [
                                   Container(
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(width: 0.5, color: AppColors.black)),
                                     child: ClipRRect(
                                         borderRadius: BorderRadius.circular(3),
                                         child: CachedNetworkImage(
                                           height: SizeConfig.blockSizeHorizontal*7,
                                           width: SizeConfig.blockSizeHorizontal*7,
                                           fit: BoxFit.cover,
                                           imageUrl:  controller.couponsList.elementAt(index).image!,
                                           placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                           errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                         )),
                                   ),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*2.5),
                                   SizedBox(width:SizeConfig.blockSizeHorizontal*60,
                                     child: TextWidget(
                                         text:
                                         "${controller.couponsList.elementAt(index).couponCode}",
                                         fontSize: SizeConfig.mediumFontSize,color:
                                         AppColors.black,
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                         weight: FontWeight.w600),
                                   )
                                 ],),
                               ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*2.25),
                               TextWidget( text : "${controller.calculateDiscount(index)} savings with this coupon",
                                   fontSize: SizeConfig.regularFontSize,
                                   color: AppColors.green, overflow: TextOverflow.ellipsis,
                                   weight: FontWeight.w500, maxLines: 1),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*0.50),
                               const  Divider(),
                                 SizedBox(height: SizeConfig.blockSizeHorizontal*0.50),
                               TextWidget( text: "${controller.couponsList.elementAt(index).description}",
                                   fontSize: SizeConfig.regularFontSize,
                                   color: AppColors.blackShades, overflow: TextOverflow.ellipsis,
                                   maxLines: 2),
                             ],
                           ),
                         )
                       ],
                     ),
                   ),
                 );

             }),
       ),
     )


         :
     Center(child: TextWidget( text:  noCoupon, color: AppColors.colorPrimary,
     fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.mediumFontSize,))),
   ),*/