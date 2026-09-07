import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'package:get/get.dart';

import 'toppingsListController.dart';

class ToppingsListScreen extends GetView<ToppingsListController> {
  const ToppingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: TextWidget(text: toppingsTitle,
        color: Colors.black,
        fontSize: SizeConfig.appbarTitleSize,
        fontFamily: fontSemiBold,
        weight: FontWeight.w600,),
    ),


      body: SafeArea(
        child: Obx(()=>
        controller.initialLoad.value ?
        Center(child: ColorLoader())
        
        
            :   controller.toppingsList.isNotEmpty ?
        RefreshIndicator(
          color: colorPrimary,
          onRefresh: controller.pullToRefresh,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*5,
                bottom: SizeConfig.blockSizeHorizontal*3,
                right: SizeConfig.blockSizeHorizontal*1,
                top:  SizeConfig.blockSizeHorizontal*3),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.toppingsList.length,
                padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal*20),
                itemBuilder: (context,index){
                  return
                    Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
        
                            Expanded(
                              flex: 6,
                              child:  RichText(
                                //maxLines: 2,
                                //overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child:
                                  (controller.toppingsList[index].type ?? "").trim() == "1"
                                      || (controller.toppingsList[index].type ?? "").trim().toLowerCase() == "veg" ?
                                  ImageIcon(
                                        const AssetImage(vegType),
                                        size: SizeConfig.blockSizeHorizontal * 4.29,
                                        color: Colors.green,
                                      )
                                          : ImageIcon(
                                        const AssetImage(nonVegType),
                                        size: SizeConfig.blockSizeHorizontal * 4.29,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(text: "  ${controller.toppingsList[index].title}",
                                      style: TextStyle( overflow: TextOverflow.ellipsis,
                                          fontFamily: fontMedium,
                                          color: colorBlack,
                                          fontSize: SizeConfig.mediumFontSize
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                            Expanded(
                              flex: 2,
                              child: TextWidget(
                                text: "$currSymbolIn ${controller.toppingsList[index].price}",
                                fontFamily: fontSemiBold,
                                fontSize: SizeConfig.mediumFontSize,
                                color: colorBlack,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  controller.goToUpdateTopping(index);
                                },
                                icon: const Icon(Icons.more_vert))
                          ],
                        ),
        
                        Visibility(
                          visible: index != controller.toppingsList.length - 1,
                          child: Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*2),
                              child: Divider(color: Colors.grey[350],thickness:0.38)),
                        ),
                      ],
                    );
        
                }),
          ),
        )
        
        
            :
        Center(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5),
          child: TextWidget( text:  noToppings, color: colorPrimary,
            textAlign: TextAlign.center,
            fontFamily: fontMedium,fontSize: SizeConfig.mediumFontSize,),
        ))),
      ),




      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimary,
        onPressed: () {
          controller.goToAddTopping();
        },
        child: const Icon(Icons.add,color: colorWhite,),

      ));

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