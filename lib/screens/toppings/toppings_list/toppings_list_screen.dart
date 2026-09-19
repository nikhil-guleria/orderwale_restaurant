import 'package:flutter/material.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:get/get.dart';
import 'toppings_list_controller.dart';

class ToppingsListScreen extends GetView<ToppingsListController> {
  const ToppingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =  Scaffold(
        backgroundColor: AppColors.white,
        appBar: buildAppBar(title: AppStrings.toppingsTitle),
      body: SafeArea(
        child: Obx(()=>
        controller.initialLoad.value ?
        Center(child: ColorLoader())
        
        
            :   controller.toppingsList.isNotEmpty ?
        RefreshIndicator(
          color: AppColors.colorPrimary,
          onRefresh: controller.pullToRefresh,
          child: Container(
            color: AppColors.white,
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
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child:
                                  (controller.toppingsList[index].type ?? "").trim() == "1"
                                      || (controller.toppingsList[index].type ?? "").trim().toLowerCase() == "veg" ?
                                  ImageIcon(
                                        const AssetImage(AppImages.vegType),
                                        size: SizeConfig.blockSizeHorizontal * 4.29,
                                        color: AppColors.green,
                                      )
                                          : ImageIcon(
                                        const AssetImage(AppImages.nonVegType),
                                        size: SizeConfig.blockSizeHorizontal * 4.29,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    TextSpan(text: "  ${controller.toppingsList[index].title}",
                                      style: TextStyle( overflow: TextOverflow.ellipsis,
                                          fontFamily: FontFamily.fontMedium,
                                          color: AppColors.blackText,
                                          fontSize: SizeConfig.mediumFontSize
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*2),

                            // price
                            Expanded(
                              flex: 2,
                              child: TextWidget(
                                text: "${AppStrings.currSymbolIn} ${controller.toppingsList[index].price ?? '0'}",
                                fontFamily: FontFamily.fontSemiBold,
                                fontSize: SizeConfig.mediumFontSize,
                                color: AppColors.blackText,
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
                              child: Divider(color: AppColors.grey[350],thickness:0.38)),
                        ),
                      ],
                    );
        
                }),
          ),
        )
        
        
            :
        Center(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5),
          child: TextWidget( text:  AppStrings.toppingsEmptyMsg, color: AppColors.colorPrimary,
            textAlign: TextAlign.center,
            fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.mediumFontSize,),
        ))),
      ),




      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorPrimary,
        onPressed: () {
          controller.goToAddTopping();
        },
        child: const Icon(Icons.add,color: AppColors.white,),

      ));

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