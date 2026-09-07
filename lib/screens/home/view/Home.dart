import 'package:flutter/material.dart';
import 'package:food_merchant/screens/home/controller/HomeController.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../component/ColorLoader.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/app_images.dart';
import '../../../utils/SizeConfig.dart';

class Home extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title:  TextWidget(text: 'My Restaurant',
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: fontSemiBold,
          weight: FontWeight.w600,),
        elevation: 0.0,
        centerTitle: true,
      ),
      body:
      Obx(()=> controller.restaurantsList.isEmpty  ?
    ListView.builder(padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
          itemCount: 2,
          itemBuilder: (_, __) =>
          Card(
        elevation: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
            width: Get.width,
            height: SizeConfig.blockSizeHorizontal*76,
            child:
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child:
            Column(
              children: [
                Stack(alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: Get.width, height: SizeConfig.blockSizeHorizontal*60,
                      ),
                    Container(padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ Container(decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))),
                            height: SizeConfig.boldFontSize,width:SizeConfig.blockSizeHorizontal*60,),
                            Container(padding: const EdgeInsets.only(left: 6,right: 3),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0))),
                              height: SizeConfig.blockSizeHorizontal*7,width: SizeConfig.blockSizeHorizontal*12,
                                )]))
                  ]),
                Container(width: Get.width,height: SizeConfig.blockSizeHorizontal*16,padding: const EdgeInsets.only(left: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [ Container(decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0))),
                          height: 25,width: 25,),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                          Container(decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))),
                            height: SizeConfig.blockSizeHorizontal*5,width: SizeConfig.blockSizeHorizontal*70,),
                           ],
                      ),
                    ],
                  ),
                ),
              ],
            )))))










         :
      RefreshIndicator(color: colorPrimary,
          onRefresh: controller.pullRefresh, child:
   ListView.builder(padding: const EdgeInsets.only(left: 10,right: 10),

       itemCount: controller.restaurantsList.length,
       physics: const AlwaysScrollableScrollPhysics(),
       scrollDirection: Axis.vertical,
       itemBuilder: (context , index) {
       return  Card(
         elevation: 50,
         color:Colors.white,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15.0),
         ),
         child: InkWell(onTap: (){
           controller.onTap(controller.restaurantsList[index].id!);
         },
           child: SizedBox(
               width: Get.width,
               height: SizeConfig.blockSizeHorizontal*76,
               child:
               Column(
                 children: [   Stack(
                     children: [Container(
                         width: Get.width, height: SizeConfig.blockSizeHorizontal*60,
                         foregroundDecoration: const BoxDecoration(
                           gradient: LinearGradient(
                             colors: [
                               Colors.black,
                               Colors.transparent,
                             ],
                             begin: Alignment.bottomCenter,
                             end: Alignment.topCenter,
                             stops: [0, 0.42],
                           ),
                         ),


                         child: ClipRRect(
                             borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                             child: controller.restaurantsList[index].image != "" ?
                             Image.network( controller.restaurantsList[index].image,fit: BoxFit.cover)
                                 : Image.asset(errorImg,fit: BoxFit.cover,)


                         )),
                       Positioned(
                         left: SizeConfig.blockSizeHorizontal*3,
                         bottom: SizeConfig.blockSizeHorizontal*3,
                         child: Container(
                           alignment: Alignment.bottomLeft,
                           height: SizeConfig.blockSizeHorizontal*20,
                           width: SizeConfig.blockSizeHorizontal*68,
                           child: TextWidget(
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                             text:'${controller.restaurantsList[index].name}',color: colorWhite,
                             fontFamily: fontBold,fontSize: SizeConfig.boldFontSize,),
                         ),
                       ),
                       controller.restaurantsList[index].review == "0.0" ? Container() :
                       Positioned(
                         right: SizeConfig.blockSizeHorizontal*3,
                         bottom: SizeConfig.blockSizeHorizontal*3.5,
                         child: Container(padding: const EdgeInsets.only(left: 6,right: 3),
                             decoration: const BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.all(
                                     Radius.circular(5.0))),
                             height: SizeConfig.blockSizeHorizontal*7,width: SizeConfig.blockSizeHorizontal*13,
                             child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 TextWidget(
                                     text: '${controller.restaurantsList[index].review}',
                                     color: colorWhite ,fontFamily: fontSemiBold,fontSize: SizeConfig.regularFontSize),
                                 Icon(Icons.star,size: SizeConfig.regularFontSize,color: colorWhite)


                               ],)),
                       )
                     ]),
                   Container(
                     width: Get.width,
                     height: SizeConfig.blockSizeHorizontal*16,
                     padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*2, left: SizeConfig.blockSizeHorizontal*2),
                     child: Row(
                       children: [
                         Icon(Icons.location_on,color: colorPrimary,size: SizeConfig.blockSizeHorizontal*6,),
                         SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                         SizedBox(
                           width: SizeConfig.blockSizeHorizontal*80,
                           child: TextWidget(
                             overflow: TextOverflow.ellipsis,
                             maxLines: 2,
                             text: '${controller.restaurantsList[index].address!}',fontFamily: fontMedium,fontSize: SizeConfig.regularFontSize,),
                         )
                       ],
                     ),
                   ),
                 ],
               )),
         ),
       );
       })

    )

          )); widgetList.add(child);
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
          : SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);


  }

}