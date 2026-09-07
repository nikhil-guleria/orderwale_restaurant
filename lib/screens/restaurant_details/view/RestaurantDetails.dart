import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/screens/restaurant_details/menu/Menu.dart';
import 'package:food_merchant/screens/restaurant_details/reviews/Reviews.dart';
import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsController.dart';
import 'package:get/get.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/app_images.dart';
import '../../../utils/SizeConfig.dart';
import '../details/Details.dart';

class RestaurantDetails extends  GetView<RestaurantDetailsController>  {
  const RestaurantDetails({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        body: SafeArea(
          top: false,
            child: Obx(()=>
        controller.restaurantsDetail.value.email == null ? Container() :
        DefaultTabController(
          length: 3,
         child:
         NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
           {  return <Widget>[
             SliverAppBar (
               systemOverlayStyle: SystemUiOverlayStyle(
                 statusBarColor: Colors.transparent,
                 statusBarIconBrightness: innerBoxIsScrolled  ?   Brightness.dark : Brightness.light,
               ),
               elevation: 0.0,
              // leading:IconButton(icon: Icon(Icons.arrow_back,color: innerBoxIsScrolled   ? Colors.black : colorWhite ,)
             //onPressed: (){Get.back();},),
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
                                   text:'${controller.restaurantsDetail.value.name}',
                                   maxLines: 3,
                                   color: colorWhite,
                                   textAlign: TextAlign.start,
                                   fontFamily: fontBold,fontSize: SizeConfig.mediumFontSize),
                             ),
                               controller.restaurantsDetail.value.avgReview == "0.0" ? Container() :
                               Container(padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5,
                                   right:  SizeConfig.blockSizeHorizontal*0.75),
                                   margin:  EdgeInsets.only(right:  SizeConfig.blockSizeHorizontal*1.75),
                                   decoration: const BoxDecoration(
                                       color: Colors.green,
                                       borderRadius: BorderRadius.all(
                                           Radius.circular(5.0))),
                                   height: SizeConfig.blockSizeHorizontal*5,width: SizeConfig.blockSizeHorizontal*11,
                                   child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Expanded(
                                         child: TextWidget(
                                             text: '${controller.restaurantsDetail.value.avgReview}',
                                             maxLines: 1,
                                             color: colorWhite ,fontFamily: fontSemiBold,fontSize: SizeConfig.blockSizeHorizontal*3),
                                       ),
                                       Icon(Icons.star,size: SizeConfig.blockSizeHorizontal*3,color: colorWhite)


                                     ],))]),
                       );
                     }  else {
                       return TextWidget(
                           text:'${controller.restaurantsDetail.value.name}',
                           maxLines:   1,
                           color: colorBlack,
                           textAlign:  TextAlign.center,
                           overflow: TextOverflow.ellipsis,
                           fontFamily: fontBold,fontSize: SizeConfig.mediumFontSize);
                     }
                   /*  return
                       Padding(
                         padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
                         child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [  Expanded(
                               child: TextWidget(
                                   text:'${controller.restaurantsDetail.value.name}',
                                   maxLines:  constraints.maxHeight > SizeConfig.blockSizeVertical*10 ? 3: 1,
                                   color: constraints.maxHeight > SizeConfig.blockSizeVertical*10 ? colorWhite :Colors.black,
                                   textAlign:  constraints.maxHeight > SizeConfig.blockSizeVertical*10 ? TextAlign.start : TextAlign.center,
                                   fontFamily: fontBold,fontSize: SizeConfig.mediumFontSize),
                             ),
                               controller.restaurantsDetail.value.avgReview == "0.0" ? Container() :
                               Visibility(
                                 visible:  constraints.maxHeight > SizeConfig.blockSizeVertical*10,
                                 child: Container(padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5,
                                     right:  SizeConfig.blockSizeHorizontal*0.75),
                                     margin:  EdgeInsets.only(right:  SizeConfig.blockSizeHorizontal*1.75),
                                     decoration: const BoxDecoration(
                                         color: Colors.green,
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(5.0))),
                                     height: SizeConfig.blockSizeHorizontal*5,width: SizeConfig.blockSizeHorizontal*11,
                                     child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Expanded(
                                           child: TextWidget(
                                               text: '${controller.restaurantsDetail.value.avgReview}',
                                               maxLines: 1,
                                               color: colorWhite ,fontFamily: fontSemiBold,fontSize: SizeConfig.blockSizeHorizontal*3),
                                         ),
                                         Icon(Icons.star,size: SizeConfig.blockSizeHorizontal*3,color: colorWhite)


                                       ],)),
                               )]),
                       );*/
                   },),


                   background: Container(
                       width: Get.width,
                       foregroundDecoration:  BoxDecoration(
                         gradient: LinearGradient(
                             colors: [Colors.transparent, Colors.black.withAlpha((0.74 * 255).round())],
                             //stops: [0, 0.5, 1],
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter
                         ),
                       ),
                       child:  ClipRRect(
                           child: CachedNetworkImage(
                           height: SizeConfig.blockSizeHorizontal*70,
                            width: Get.width,
                            fit: BoxFit.cover,
                            imageUrl: controller.restaurantsDetail.value.bannerImage!,
                            placeholder: (context, url) => Image.asset(loadingGif,
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeHorizontal*70,
                            width: Get.width,),
                            errorWidget: (context, url, error) => Image.asset(appLogoTransparent,
                        height:SizeConfig.blockSizeHorizontal*70,
                             width: Get.width,)))

                   ))),

             SliverAppBar(
                 automaticallyImplyLeading: false,
                 pinned: true,
                 primary: false,
                 elevation: 0.1,
                 title:Align(
                   alignment: AlignmentDirectional.center,
                   child:
                   TabBar(
                     controller: controller.tabController,
                     indicatorColor: colorPrimary,
                     dividerColor: Colors.transparent,
                     labelStyle: TextStyle(fontFamily: fontSemiBold,fontSize: SizeConfig.mediumFontSize),
                     unselectedLabelStyle: TextStyle(fontFamily: fontSemiBold,fontSize: SizeConfig.mediumFontSize),
                     labelColor: colorPrimary,
                     unselectedLabelColor: blackShades,
                     tabs:   const [
                       Tab(  text: "Details"),
                       Tab( text: "Menu"),
                       Tab( text: "Reviews"),
                     ],
                   ),
                 )),
           ];  },
           body: TabBarView(
            controller: controller.tabController,
             children: [
               Details(details:  controller.restaurantsDetail.value,
                   isEdit: controller.isEdit.value == true ? true : false),
               const Menu(),
               Reviews(),
             ],),
         )) )));
    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack( alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: Colors.white),
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

