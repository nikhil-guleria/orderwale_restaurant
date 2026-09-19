import 'package:flutter/material.dart';
import 'package:food_merchant/screens/profile/ProfileController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../component/ColorLoader.dart';
import '../../component/custom_text_widget.dart';
import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';
import '../../constant/app_images.dart';
import '../../constant/app_strings.dart';
import '../../utils/size_config.dart';

class Profile extends GetView<ProfileController>{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];
    var child =  Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: TextWidget(text: AppStrings.profileTitle,
          color: Colors.black,
          fontSize: SizeConfig.appbarTitleSize,
          fontFamily: FontFamily.fontSemiBold,
          fontWeight: FontWeight.w600,),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
               controller.goToUpdateProfileScreen();
              },
              icon: const Icon(
                Icons.edit,
                color: AppColors.colorPrimary,
              ),
            ),
          )
        ],),
      body: Obx(()=>
      controller.profileDetails.value.phone == null ? const SizedBox() :
      Container(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
    padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal*5,
    bottom:  SizeConfig.blockSizeHorizontal*2,
    left: SizeConfig.blockSizeHorizontal*3,
    right: SizeConfig.blockSizeHorizontal*3),
    child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeHorizontal*3),
          SizedBox(width: Get.width,
              height: SizeConfig.blockSizeHorizontal*25,
              child:   Row(
                children: [
                  Container(height: SizeConfig.blockSizeHorizontal*25,
                    width: SizeConfig.blockSizeHorizontal*25,
                    decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary, width: 2),
                        borderRadius:  BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal*12.5))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*12.5),
                        child: controller.profileDetails.value.profileImage == "" ?
                        Image.asset(AppImages.errorImg,
                          fit: BoxFit.cover,
                        ) :
                            Image.network("${controller.profileDetails.value.profileImage}",fit: BoxFit.cover,)
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                  Container(height: SizeConfig.blockSizeHorizontal*25,
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*1.5),
                    width:  SizeConfig.blockSizeHorizontal*67,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width:  SizeConfig.blockSizeHorizontal*67,
                          child: Row(
                            children: [
                              Icon(Icons.person,
                                size: SizeConfig.semiBoldFontSize,
                                color: AppColors.colorPrimary,
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*1.5),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*60,
                                child: TextWidget(overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: "${controller.profileDetails.value.name}",
                                    fontFamily: FontFamily.fontMedium,
                                    fontSize: SizeConfig.mediumFontSize),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width:  SizeConfig.blockSizeHorizontal*67,
                          child: Row(
                            children: [
                              Icon(Icons.email,
                                size: SizeConfig.semiBoldFontSize,
                                color: AppColors.colorPrimary,
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*1.5,),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*60,
                                child: TextWidget(overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: "${controller.profileDetails.value.email}",
                                    fontFamily: FontFamily.fontMedium,
                                    fontSize: SizeConfig.mediumFontSize),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width:  SizeConfig.blockSizeHorizontal*67,
                          child: Row(
                            children: [
                              Icon(Icons.phone,
                                size: SizeConfig.semiBoldFontSize,
                                color: AppColors.colorPrimary,
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*1.5,),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*60,
                                child: TextWidget(overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: "${controller.profileDetails.value.phone}",
                                    fontFamily: FontFamily.fontMedium,
                                    fontSize: SizeConfig.mediumFontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],


              )),
          SizedBox(height: SizeConfig.blockSizeHorizontal*11),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 44,
                height: SizeConfig.blockSizeHorizontal * 22,
                decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    border: Border.all(
                        color: AppColors.disabledBorderColor, width: 2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(
                      10.0,
                    ))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child:  Icon(Icons.currency_rupee,size: SizeConfig.mediumFontSize,color: AppColors.colorPrimary,),
                          ),
                          TextSpan(text: NumberFormat('0.00').format(controller.stringToDouble(controller.profileDetails.value.totalEarnings!)),
                            style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                color: AppColors.blackText,
                                fontFamily: FontFamily.fontMedium),
                          ),
                        ],

                      ),
                    ),),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 36,
                        child: TextWidget(text: "Total Earning",textAlign: TextAlign.center,maxLines: 1,
                        overflow: TextOverflow.ellipsis,))
                  ],
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 44,
                height: SizeConfig.blockSizeHorizontal * 22,
                decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    border: Border.all(
                        color: AppColors.disabledBorderColor, width: 2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(
                      10.0,
                    ))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child:  Icon(Icons.currency_rupee,size: SizeConfig.mediumFontSize,color: AppColors.colorPrimary,),
                          ),
                          TextSpan(text:  NumberFormat('0.00').format(controller.stringToDouble(controller.profileDetails.value.currentMonthEarnings!)),
                            style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                color: AppColors.blackText,
                                fontFamily: FontFamily.fontMedium),
                          ),
                        ],

                      ),
                    ),),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 44,
                        child: TextWidget(text: "This Month",textAlign: TextAlign.center,maxLines: 1,
                        overflow: TextOverflow.ellipsis,))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal*11),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 44,
                height: SizeConfig.blockSizeHorizontal * 22,
                decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    border: Border.all(
                        color: AppColors.disabledBorderColor, width: 2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(
                      10.0,
                    ))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(text: "${controller.profileDetails.value.totalOrders}",
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.blackText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 44,
                        child: TextWidget(text: "Total Orders",textAlign: TextAlign.center,maxLines: 1,
                        overflow: TextOverflow.ellipsis,))
                  ],
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 44,
                height: SizeConfig.blockSizeHorizontal * 22,
                decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    border: Border.all(
                        color: AppColors.disabledBorderColor, width: 2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(
                      10.0,
                    ))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(text: "${controller.profileDetails.value.newOrders}",
                        fontFamily: FontFamily.fontMedium,
                        fontSize: SizeConfig.mediumFontSize,
                        color: AppColors.blackText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 44,
                        child: TextWidget(text: "New Orders",textAlign: TextAlign.center,maxLines: 1,
                        overflow: TextOverflow.ellipsis,))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal*11),
          Container(
            width: SizeConfig.blockSizeHorizontal * 44,
            height: SizeConfig.blockSizeHorizontal * 22,
            decoration: BoxDecoration(
                color: AppColors.textFieldFillColor,
                border: Border.all(
                    color: AppColors.disabledBorderColor, width: 2),
                borderRadius:
                const BorderRadius.all(Radius.circular(
                  10.0,
                ))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(text: "${controller.profileDetails.value.todaysOrders}",
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.blackText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 36,
                    child: TextWidget(text: "Today Order",textAlign: TextAlign.center,maxLines: 1,
                      overflow: TextOverflow.ellipsis,))
              ],
            ),
          ),
              ],
            ),
          )








      )));
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