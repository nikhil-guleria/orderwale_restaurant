
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:get/get.dart';

import '../../component/ColorLoader.dart';
import '../../component/custom_text_widget.dart';
import '../../constant/font_family.dart';
import '../../constant/app_images.dart';
import '../../utils/size_config.dart';
import 'NotificationsController.dart';

class Notifications extends GetView<NotificationsController>{
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: TextWidget(text:  'Notifications',
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: FontFamily.fontSemiBold,
          fontWeight: FontWeight.w600,),
        elevation: 0.0,
        centerTitle: true,
      ),
      body:
          Obx(() =>
      controller.notificationsList.isEmpty  ? Center(child: TextWidget(text: 'No Data Found',
        fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.regularFontSize,color: AppColors.normalTextColor,)):
      RefreshIndicator(
        color: AppColors.colorPrimary,
        onRefresh: controller.pullRefresh,
        child: ListView.builder(padding: const EdgeInsets.only(left: 10,right: 10),

    itemCount: controller.notificationsList.length,
            physics: const AlwaysScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context , index) {
          return ListTile( onTap: (){},
              contentPadding: const EdgeInsets.only(left: 5),
              leading:  Container(height: SizeConfig.blockSizeHorizontal*10,
                width: SizeConfig.blockSizeHorizontal*10,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all( Radius.circular(6)),
                    child:
                    controller.notificationsList[index].image == "" ?
                    Image.asset(AppImages.errorImg, fit: BoxFit.cover,) :
                    Image.network(controller.notificationsList[index].image,
                      fit: BoxFit.cover,
                    )
                ),
              ),
              trailing: TextWidget(
                text: "#${controller.notificationsList[index].typeId}",
                  fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.mediumFontSize),
              title:TextWidget(
                  text: "${controller.notificationsList[index].title}",
                  fontFamily: FontFamily.fontMedium,
                  fontSize: SizeConfig.mediumFontSize),
              subtitle:TextWidget(
            text: "${controller.notificationsList[index].description}",
            color: AppColors.normalTextColor,
            fontSize: SizeConfig.regularFontSize,fontFamily: FontFamily.fontRegular,));
    }),
      )
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