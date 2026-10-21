import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/restaurant_details/menu/restaurant_menu.dart';
import 'package:food_merchant/screens/restaurant_details/reviews/reviews.dart';
import 'package:food_merchant/screens/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:get/get.dart';
import '../../../component/color_loader.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_images.dart';
import '../../../utils/size_config.dart';
import '../details/details.dart';

class RestaurantDetails extends  GetView<RestaurantDetailsController>  {
  const RestaurantDetails({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        body: SafeArea(
          top: false,
            child: Obx(()=>
            (controller.restaurantsDetail.value.email ?? '').trim().isEmpty
                ? Container() :
        DefaultTabController(
          length: 3,
         child:
         NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
           {  return <Widget>[
             // restaurant name & rating
              SliverAppBar (
                 systemOverlayStyle: SystemUiOverlayStyle(
                   statusBarColor: AppColors.transparent,
                   statusBarIconBrightness: innerBoxIsScrolled  ?   Brightness.dark : Brightness.light,
                 ),
                 elevation: 0.0,
                 expandedHeight:SizeConfig.blockSizeHorizontal*60,
                 pinned: true,
                   primary: false,
                 flexibleSpace: FlexibleSpaceBar(
                     centerTitle: true,
                     titlePadding: const EdgeInsets.all(0),
                     title: LayoutBuilder(builder: (context, constraints){
                       if(constraints.maxHeight > SizeConfig.blockSizeHorizontal*17) {
                         return  Padding(
                           padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
                           child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [  Expanded(
                                 child: TextWidget(
                                     text:controller.restaurantsDetail.value.name ?? '',
                                     maxLines: 3,
                                     color: AppColors.white,
                                     textAlign: TextAlign.start,
                                     fontFamily: FontFamily.fontBold,fontSize: SizeConfig.mediumFontSize),
                               ),
                                 (num.tryParse(controller.restaurantsDetail.value.avgReview ?? '0') ?? 0) > 0 ?
                                 Container() :
                                 Container(padding:
                                 EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5,
                                     right:  SizeConfig.blockSizeHorizontal*0.75),
                                     margin:  EdgeInsets.only(right:  SizeConfig.blockSizeHorizontal*1.75),
                                     decoration: const BoxDecoration(
                                         color: AppColors.green,
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(5.0))),
                                     height: SizeConfig.blockSizeHorizontal*5,width: SizeConfig.blockSizeHorizontal*11,
                                     child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Expanded(
                                           child: TextWidget(
                                               text: '${controller.restaurantsDetail.value.avgReview}',
                                               maxLines: 1,
                                               color: AppColors.white ,fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.blockSizeHorizontal*3),
                                         ),
                                         Icon(Icons.star,size: SizeConfig.blockSizeHorizontal*3,color: AppColors.white)
               
               
                                       ],))]),
                         );
                       }  else {
                         return TextWidget(
                             text: controller.restaurantsDetail.value.name ?? '',
                             maxLines: 1,
                             color: AppColors.blackText,
                             textAlign:  TextAlign.center,
                             overflow: TextOverflow.ellipsis,
                             fontFamily: FontFamily.fontBold,fontSize: SizeConfig.mediumFontSize);
                       }
                     },),
               
               
                     background: Container(
                         width: Get.width,
                         foregroundDecoration:  BoxDecoration(
                           gradient: LinearGradient(
                               colors: [AppColors.transparent, AppColors.black.withAlpha((0.74 * 255).round())],
                               begin: Alignment.topCenter,
                               end: Alignment.bottomCenter
                           ),
                         ),
                         child:  ClipRRect(
                             child: CachedNetworkImage(
                             height: SizeConfig.blockSizeHorizontal*70,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: controller.restaurantsDetail.value.bannerThumbnail ?? '',
                              placeholder: (context, url) => Image.asset(AppImages.loadingGif,
                              fit: BoxFit.cover,
                              height: SizeConfig.blockSizeHorizontal*70,
                              width: Get.width,),
                              errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent,
                          height:SizeConfig.blockSizeHorizontal*70,
                               width: Get.width,)))
               
                     )),
               ),


             // tab bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                     pinned: true,
                     primary: false,
                     elevation: 0.1,
                     title:Align(
                       alignment: AlignmentDirectional.center,
                       child: TabBar(
                         controller: controller.tabController,
                         indicatorColor: AppColors.colorPrimary,
                         dividerColor: AppColors.transparent,
                         labelStyle: TextStyle(
                         fontFamily: FontFamily.fontSemiBold,
                         fontSize: SizeConfig.mediumFontSize),
                         unselectedLabelStyle: TextStyle(fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.mediumFontSize),
                         labelColor: AppColors.colorPrimary,
                         unselectedLabelColor: AppColors.blackShades,
                         tabs: const [
                           Tab(text: AppStrings.restaurantTabDetails),
                           Tab( text: AppStrings.restaurantTabMenu),
                           Tab( text: AppStrings.restaurantTabReviews),
                         ]
                       ),
                     ),
              ),

             
           ];  },
           body: TabBarView(
            controller: controller.tabController,
             children: [
               Details(details: controller.restaurantsDetail.value),
               const RestaurantMenu(),
               Reviews(),
             ],),
         ))
            )));
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

