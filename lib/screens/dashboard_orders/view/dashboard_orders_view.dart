import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/DottedLine.dart';
import 'package:food_merchant/component/custom_switch.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/screens/dashboard_orders/model/dashboard_orders_model.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/DateTimeUtils.dart';
import '../../../utils/size_config.dart';
import 'custom_clipper.dart';
import '../controller/dashboard_orders_controller.dart';

class DashboardOrdersView extends GetView<DashboardOrdersController> {
  const DashboardOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    appBar(){
      return SizedBox(
        width: SizeConfig.screenWidth,
        height: kToolbarHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // restaurant availability
            Positioned(
              left: SizeConfig.blockSizeHorizontal*3,
              child:  Obx(()=>
              customSwitch(
              switchValue: controller.restaurantAvailability.value == 1,
                  onTap: (){
                controller.changeRestaurantAvailability(!(controller.restaurantAvailability.value == 1));
              })),
            ),

            // title & orders btn
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*15),
                        child: TextWidget(text: main_screen_title,
                          color: Colors.black,
                          fontSize: SizeConfig.appbarTitleSize,
                          textAlign: TextAlign.center,
                          fontFamily: FontFamily.fontSemiBold,
                          fontWeight: FontWeight.w600,),
                      )),

                  IconButton(onPressed: controller.goToOrdersList,
                      icon: SvgPicture.asset(AppImages.ordersActive))
                ],
              )
            ),
          ],
        ),
      );
    }

    List<Widget> widgetList = [];
    var child =  Scaffold(  backgroundColor: AppColors.white,
      body:  SafeArea(
        child: RefreshIndicator(
          color: AppColors.colorPrimary,
          onRefresh: controller.pullRefresh,
          child:  Column(
            children: [
              appBar(),
              Expanded(child:
              Obx(()=> controller.initialLoad.value ?
              Center(child: TextWidget(text: AppStrings.headingPleaseWait,
                  color: AppColors.colorPrimary,
                  fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium)) :
              SizedBox(
                  height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
                  child:
                  controller.receivedOrder.isEmpty && controller.acceptedOrder.isEmpty ?
                  Center(child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Image.asset(AppImages.orderComing)))
                      :
                  Column(mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child:
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                                // received orders
                                Visibility(
                                  visible: controller.receivedOrder.isNotEmpty,
                                  child: SizedBox(
                                      height: SizeConfig.blockSizeHorizontal*72,
                                      child:
                                      Swiper(
                                          indicatorLayout: PageIndicatorLayout.SCALE,
                                          controller: controller.swiperController1,
                                          outer: true,
                                          pagination: SwiperPagination(
                                            builder: FractionPaginationBuilder(
                                              color: Colors.black,
                                              activeColor: AppColors.colorPrimary,
                                              fontSize: SizeConfig.mediumFontSize,
                                              activeFontSize: SizeConfig.mediumFontSize,
                                            ),
                                          ),
                                          itemCount: controller.receivedOrder.length,
                                          itemBuilder: (context, index) {
                                            return Stack(alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      margin:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4.5,
                                                          right:SizeConfig.blockSizeHorizontal*4.5),
                                                      padding:  EdgeInsets.only(
                                                          left: SizeConfig.blockSizeHorizontal*2.75,
                                                          right: SizeConfig.blockSizeHorizontal*2.75,
                                                          top: SizeConfig.blockSizeHorizontal*13),
                                                      decoration:BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*4.5),
                                                          border: Border.all(color: AppColors.colorPrimary, width: 2)
                                                      ),
                                                      child: InkWell(onTap: () {
                                                        controller.goToOrderDetails(controller.receivedOrder[index].orderId);
                                                      },
                                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  // order id
                                                                  Expanded(flex:2,
                                                                      child: TextWidget(
                                                                        text: "#${controller.receivedOrder[index].orderId ?? 'N/A'}",
                                                                        color: AppColors.blackShades,
                                                                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                                                        fontFamily: FontFamily.fontMedium,
                                                                        fontWeight: FontWeight.bold,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      )),
                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal*1),

                                                                  // order date time
                                                                  Expanded(flex: 3,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Icon(CupertinoIcons.calendar_today, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                          SizedBox(width: SizeConfig.blockSizeHorizontal*0.5),
                                                                          Flexible(
                                                                              child: TextWidget(
                                                                                textAlign: TextAlign.center,
                                                                                text: "${DateTimeUtils.utils.extractDate(controller.receivedOrder[index].created ?? '')} at ${DateTimeUtils.utils.extractTime(controller.receivedOrder[index].created ?? '')}",
                                                                                color: AppColors.blackShades,
                                                                                fontSize: SizeConfig.blockSizeHorizontal*3.3,
                                                                                fontFamily: FontFamily.fontMedium,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                          )
                                                                        ],
                                                                      ))],
                                                              ),
                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*1.5),

                                                              // delivery/pickup info
                                                              Row(
                                                                  children: [
                                                                    Icon(CupertinoIcons.location_solid, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal*1.25),
                                                                    Expanded(
                                                                      child: TextWidget(
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: (controller.receivedOrder[index].deliveryType ?? '').trim() == "1"?
                                                                          controller.receivedOrder[index].address ?? '' : AppStrings.selfPickUp,
                                                                          color: Colors.black87,
                                                                          fontSize: SizeConfig.regularFontSize,
                                                                          fontFamily: FontFamily.fontRegular),
                                                                    ),
                                                                  ]),
                                                              Divider(color: Colors.grey.shade300,),


                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    // items details
                                                                    Expanded(flex: 4,
                                                                      child: (controller.receivedOrder[index].details ?? []).length == 1 ?
                                                                      RichText(
                                                                          maxLines: 1,
                                                                          text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                    text: ' ${controller.receivedOrder[index].details?[0].itemCount ?? '0'} ',
                                                                                    style: TextStyle(
                                                                                        color: AppColors.colorPrimary,
                                                                                        fontSize: SizeConfig.mediumFontSize,
                                                                                        fontFamily: FontFamily.fontBold)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: ' X  ${controller.receivedOrder[index].details?[0].itemName ?? ''}',

                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: (controller.receivedOrder[index].details?[0].customisationTitle ?? '').trim().isNotEmpty ?
                                                                                    ' [ ${controller.receivedOrder[index].details?[0].customisationTitle ?? ''} ]' : "",
                                                                                    style: TextStyle(
                                                                                        color:  AppColors.colorPrimary,fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontSemiBold)
                                                                                ),

                                                                              ]))
                                                                          : RichText(
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                    text: controller.receivedOrder[index].details?[0].itemName ?? '',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: ' and ${(controller.receivedOrder[index].details ?? []).length -1} more',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),
                                                                              ])),
                                                                    ),



                                                                    // show all order items
                                                                    Expanded(flex: 2,
                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          showAllItems(context,controller.receivedOrder[index].details ?? []);
                                                                        },
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Flexible(
                                                                              child: TextWidget(
                                                                                text: show_all_lbl,
                                                                                color: Colors.green,
                                                                                fontSize: SizeConfig.regularFontSize,
                                                                                fontFamily: FontFamily.fontMedium,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                            Icon(Icons.arrow_drop_down_circle_outlined, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                          ],
                                                                        ),
                                                                      ),),
                                                                  ]),


                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*2.2),
                                                              // total price and payment status
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(width : SizeConfig.blockSizeHorizontal*45,
                                                                      child: Row(
                                                                        children: [
                                                                          Flexible(child: TextWidget(
                                                                              text:"Total Price:  ",
                                                                              maxLines: 1,
                                                                              color: Colors.black87,
                                                                              fontSize: SizeConfig.regularFontSize,
                                                                              fontFamily: FontFamily.fontRegular)),
                                                                          (controller.receivedOrder[index].paymentType ?? '').trim() == "1" ?
                                                                          Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(width: 1, color: Colors.red.shade300)
                                                                            ),
                                                                            child: Center(
                                                                              child: TextWidget(
                                                                                  text: "UNPAID",
                                                                                  color: Colors.red.shade300,
                                                                                  fontSize: SizeConfig.blockSizeHorizontal*3,
                                                                                  fontFamily: FontFamily.fontMedium
                                                                              ),
                                                                            ),
                                                                          )
                                                                              : Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(width: 1, color: Colors.green)
                                                                            ),
                                                                            child: Center(
                                                                              child: TextWidget(
                                                                                  text:"PAID",
                                                                                  color: Colors.green,
                                                                                  fontSize: SizeConfig.blockSizeHorizontal*3,
                                                                                  fontFamily: FontFamily.fontMedium
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                  ),
                                                                  // total price
                                                                  Expanded(
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Icon(Icons.currency_rupee,size: SizeConfig.mediumFontSize,color: AppColors.colorPrimary,),
                                                                        Flexible(
                                                                          child: TextWidget(text: controller.setItemsTotal(controller.receivedOrder[index].totalPrice,controller.receivedOrder[index].walletPrice),
                                                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                            fontSize: SizeConfig.mediumFontSize,color: AppColors.blackText,fontFamily: FontFamily.fontSemiBold,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],),
                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*2.2),

                                                              // cancel & accept order
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  // cancel order
                                                                  Container(width: SizeConfig.blockSizeHorizontal*31,
                                                                    padding:   EdgeInsets.only(right:SizeConfig.blockSizeHorizontal*1,
                                                                        top: SizeConfig.blockSizeHorizontal*1,
                                                                        bottom: SizeConfig.blockSizeHorizontal*1),
                                                                    child: ButtonWidget(text: decline_btn,
                                                                        onPressed: (){
                                                                      controller.cancelOrder(index);
                                                                        },
                                                                        roundedCorner: 6.0,
                                                                        height: SizeConfig.blockSizeHorizontal*9,
                                                                        fontSize: SizeConfig.regularFontSize,
                                                                        backGroundColor: Colors.redAccent),
                                                                  ),

                                                                  // accept order
                                                                  Expanded(
                                                                    child: Padding(padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1,
                                                                        top: SizeConfig.blockSizeHorizontal*1,
                                                                        bottom: SizeConfig.blockSizeHorizontal*1),
                                                                      child: Stack(alignment: Alignment.centerRight,
                                                                        children: [
                                                                          ButtonWidget(
                                                                              height: SizeConfig.blockSizeHorizontal*9,
                                                                              text:  accept_order_btn,
                                                                              roundedCorner: 6.0,
                                                                              onPressed: (){
                                                                                //controller.timerController.start();
                                                                                controller.acceptDeclineOrders("2", controller.receivedOrder[index].orderId);
                                                                              },
                                                                              fontSize: SizeConfig.blockSizeHorizontal*4,
                                                                              backGroundColor: Colors.green
                                                                          ),


                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ))),

                                                  // new order label top left corner
                                                  Positioned(
                                                    top: SizeConfig.blockSizeHorizontal*10.4,
                                                    left:SizeConfig.blockSizeHorizontal*2.3,
                                                    child: Transform.rotate(
                                                        angle: pi/-2,
                                                        child: SizedBox(
                                                          height: SizeConfig.blockSizeHorizontal*2.2,
                                                          width: SizeConfig.blockSizeHorizontal*2.2,
                                                          child:  CustomPaint(
                                                            painter: TrianglePainter(color: AppColors.colorNewOrder.withAlpha((0.6 * 255).round())),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: SizeConfig.blockSizeHorizontal*3.5,
                                                    left:SizeConfig.blockSizeHorizontal*2.3,
                                                    child: ClipPath(
                                                      clipper: SkewCutUpward(),
                                                      child: Container(
                                                        height: SizeConfig.blockSizeHorizontal*7,
                                                        decoration: const BoxDecoration(
                                                            gradient:  LinearGradient(
                                                              colors: [
                                                                Colors.purple,
                                                                Colors.blue,
                                                              ],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              stops: [0, 1],
                                                            ),

                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(1.5),
                                                                topRight:Radius.circular(1.5),
                                                                bottomRight: Radius.circular(1.5))
                                                        ),


                                                        child: Container(
                                                          alignment:  Alignment.center,
                                                          margin:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.75),
                                                          child: TextWidget(text: "New Order", fontFamily: FontFamily.fontMedium,
                                                            textAlign: TextAlign.center,
                                                            fontSize: SizeConfig.mediumFontSize, color: Colors.white,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // delivery type top right corner
                                                  Container(
                                                      height: SizeConfig.blockSizeHorizontal*8.2,
                                                      width: SizeConfig.blockSizeHorizontal*25,
                                                      margin:EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*4.5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: (controller.receivedOrder[index].deliveryType ?? '').trim() == "1"?
                                                          AppColors.redBackground :AppColors.colorYellowTheme,
                                                          borderRadius: BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeHorizontal*4.5),
                                                              bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*3))
                                                      ),
                                                      child:  TextWidget(text: (controller.receivedOrder[index].deliveryType ?? '').trim() == "1"?
                                                      "Delivery" : "TakeAway", fontFamily: FontFamily.fontMedium,
                                                        textAlign: TextAlign.center,
                                                        fontSize: SizeConfig.mediumFontSize, color: Colors.white,)
                                                  )
                                                ],
                                              );
                                          }
                                      ) ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                                Visibility(
                                  visible: controller.receivedOrder.isNotEmpty  && controller.acceptedOrder.isNotEmpty,
                                  child: Container(color: AppColors.backgroundColor,
                                      height: SizeConfig.blockSizeHorizontal*5),
                                ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                                Visibility(
                                  visible: controller.acceptedOrder.isNotEmpty,
                                  child: SizedBox(height: SizeConfig.blockSizeHorizontal*72,
                                      child:
                                      Swiper(
                                          indicatorLayout: PageIndicatorLayout.SCALE,
                                          controller: controller.swiperController2,
                                          outer: true,
                                          pagination: SwiperPagination(
                                            builder: FractionPaginationBuilder(
                                              color: Colors.black,
                                              activeColor: AppColors.colorPrimary,
                                              fontSize: SizeConfig.mediumFontSize,
                                              activeFontSize: SizeConfig.mediumFontSize,
                                            ),
                                          ),
                                          itemCount:  controller.acceptedOrder.length,
                                          itemBuilder: (context, index) {
                                            return Stack(alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      margin:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4.5,
                                                          right:SizeConfig.blockSizeHorizontal*4.5),
                                                      padding:  EdgeInsets.only(
                                                          left: SizeConfig.blockSizeHorizontal*2.75,
                                                          right: SizeConfig.blockSizeHorizontal*2.75,
                                                          top: SizeConfig.blockSizeHorizontal*13),
                                                      decoration:BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*4.5),
                                                          border: Border.all(color: Colors.grey, width: 1.5)
                                                      ),
                                                      child: InkWell(onTap: () {
                                                        controller.goToOrderDetails(controller.acceptedOrder[index].orderId);
                                                      },
                                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [

                                                                  // order id
                                                                  Expanded(flex:2,
                                                                      child: TextWidget(
                                                                        text: "#${controller.acceptedOrder[index].orderId ?? 'N/A'}",
                                                                        color: AppColors.blackShades,
                                                                        fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                                                        fontFamily: FontFamily.fontMedium,
                                                                        fontWeight: FontWeight.bold,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      )),
                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal*1),

                                                                  // order date & time
                                                                  Expanded(flex: 3,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Icon(CupertinoIcons.calendar_today, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                          SizedBox(width: SizeConfig.blockSizeHorizontal*0.5),
                                                                          Flexible(
                                                                              child: TextWidget(
                                                                                textAlign: TextAlign.center,
                                                                                text: "${DateTimeUtils.utils.extractDate(controller.acceptedOrder[index].created ?? '')} at ${DateTimeUtils.utils.extractTime(controller.acceptedOrder[index].created ?? '')}",
                                                                                color: AppColors.blackShades,
                                                                                fontSize: SizeConfig.blockSizeHorizontal*3.3,
                                                                                fontFamily: FontFamily.fontMedium,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                          )
                                                                        ],
                                                                      ))],
                                                              ),
                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*1.5),

                                                              // delivery/pickup info
                                                              Row(
                                                                  children: [
                                                                    Icon(CupertinoIcons.location_solid, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal*1.25),
                                                                    Expanded(
                                                                      child: TextWidget(
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1"?
                                                                          controller.acceptedOrder[index].address ?? '' : AppStrings.selfPickUp,
                                                                          color: Colors.black87,
                                                                          fontSize: SizeConfig.regularFontSize,
                                                                          fontFamily: FontFamily.fontRegular),
                                                                    ),
                                                                  ]),
                                                              Divider(color: Colors.grey.shade300),
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [

                                                                    // item details
                                                                    Expanded(flex: 4,
                                                                      child: (controller.acceptedOrder[index].details ?? []).length == 1 ?
                                                                      RichText(
                                                                          maxLines: 1,
                                                                          text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                    text: ' ${controller.acceptedOrder[index].details?[0].itemCount ?? '0'} ',
                                                                                    style: TextStyle(
                                                                                        color: AppColors.colorPrimary,
                                                                                        fontSize: SizeConfig.mediumFontSize,
                                                                                        fontFamily: FontFamily.fontBold)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: ' X  ${controller.acceptedOrder[index].details?[0].itemName ?? ''}',

                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: (controller.acceptedOrder[index].details?[0].customisationTitle ?? '').trim().isNotEmpty ?
                                                                                    ' [ ${controller.acceptedOrder[index].details?[0].customisationTitle ?? ''} ]' : "",
                                                                                    style: TextStyle(
                                                                                        color:  AppColors.colorPrimary,fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontSemiBold)
                                                                                ),

                                                                              ]))
                                                                          : RichText(
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                    text: controller.acceptedOrder[index].details?[0].itemName ?? '',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),
                                                                                TextSpan(
                                                                                    text: ' and ${(controller.acceptedOrder[index].details ?? []).length -1} more',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: SizeConfig.regularFontSize,
                                                                                        fontFamily: FontFamily.fontMedium)
                                                                                ),

                                                                              ])),
                                                                    ),


                                                                    // show all order items
                                                                    Expanded(flex: 2,
                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          showAllItems(context,controller.acceptedOrder[index].details ?? []);
                                                                        },
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Flexible(
                                                                              child: TextWidget(
                                                                                text: show_all_lbl,
                                                                                color: Colors.green,
                                                                                fontSize: SizeConfig.regularFontSize,
                                                                                fontFamily: FontFamily.fontMedium,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                            Icon(Icons.arrow_drop_down_circle_outlined, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                                          ],
                                                                        ),
                                                                      ),),
                                                                  ]),

                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*2.2),

                                                              // total price and payment status
                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(width : SizeConfig.blockSizeHorizontal*45,
                                                                      child:  Row(
                                                                        children: [
                                                                          Flexible(child: TextWidget(
                                                                              text:"Total Price:  ",
                                                                              maxLines: 1,
                                                                              color: Colors.black87,
                                                                              fontSize: SizeConfig.regularFontSize,
                                                                              fontFamily: FontFamily.fontRegular)),
                                                                          (controller.acceptedOrder[index].paymentType ?? '').trim() == "1" ?
                                                                          Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(width: 1, color: Colors.red.shade300)
                                                                            ),
                                                                            child: Center(
                                                                              child: TextWidget(
                                                                                  text: "UNPAID",
                                                                                  color: Colors.red.shade300,
                                                                                  fontSize: SizeConfig.blockSizeHorizontal*3,
                                                                                  fontFamily: FontFamily.fontMedium
                                                                              ),
                                                                            ),
                                                                          )
                                                                              : Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(width: 1, color: Colors.green)
                                                                            ),
                                                                            child: Center(
                                                                              child: TextWidget(
                                                                                  text:"PAID",
                                                                                  color: Colors.green,
                                                                                  fontSize: SizeConfig.blockSizeHorizontal*3,
                                                                                  fontFamily: FontFamily.fontMedium
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                  ),


                                                                  // total price
                                                                  Expanded(
                                                                    child:Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Icon(Icons.currency_rupee,size: SizeConfig.mediumFontSize,color: AppColors.colorPrimary,),
                                                                        Flexible(
                                                                          child: TextWidget(text: controller.setItemsTotal(controller.acceptedOrder[index].totalPrice, controller.acceptedOrder[index].walletPrice),
                                                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                            fontSize: SizeConfig.mediumFontSize,color: AppColors.blackText,fontFamily: FontFamily.fontSemiBold,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],),
                                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*2.2),

                                                              // order status buttons
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2" ?
                                                                  Expanded(
                                                                    child: Padding(padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1,
                                                                        top:  SizeConfig.blockSizeHorizontal*1,
                                                                        bottom:  SizeConfig.blockSizeHorizontal*1),
                                                                      child: ButtonWidget(
                                                                          height: SizeConfig.blockSizeHorizontal*9,
                                                                          text:  mark_as_ready,
                                                                          roundedCorner: 6.0,
                                                                          onPressed: (){
                                                                            controller.acceptDeclineOrders("7", controller.acceptedOrder[index].orderId);
                                                                          },
                                                                          fontSize: SizeConfig.blockSizeHorizontal*4,
                                                                          backGroundColor: AppColors.colorYellowTheme),
                                                                    ),
                                                                  )

                                                                      :  ( controller.acceptedOrder[index].orderStatus ?? '').trim() == "4" ?
                                                                  Expanded(
                                                                    child: Padding(padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1,
                                                                        top: SizeConfig.blockSizeHorizontal*1,
                                                                        bottom: SizeConfig.blockSizeHorizontal*1),
                                                                      child: ButtonWidget(
                                                                          height: SizeConfig.blockSizeHorizontal*9,
                                                                          text:  mark_as_delivered,
                                                                          roundedCorner: 6.0,
                                                                          onPressed: (){
                                                                            controller.deliverOrderClick(controller.acceptedOrder[index].orderId);
                                                                          },
                                                                          fontSize: SizeConfig.blockSizeHorizontal*4,
                                                                          backGroundColor: AppColors.colorYellowTheme),
                                                                    ),
                                                                  )


                                                                      :    Expanded(
                                                                    child: Padding(padding:  EdgeInsets.only(
                                                                        left: SizeConfig.blockSizeHorizontal*1, top: SizeConfig.blockSizeHorizontal*1,
                                                                        bottom: SizeConfig.blockSizeHorizontal*1),
                                                                      child: ButtonWidget(
                                                                          height: SizeConfig.blockSizeHorizontal*9,
                                                                          text: (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1" ?
                                                                          mark_as_out_for_delivery : mark_as_delivered,
                                                                          roundedCorner: 6.0,
                                                                          onPressed: (){
                                                                            (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1" ?
                                                                            controller.acceptDeclineOrders("4", controller.acceptedOrder[index].orderId)
                                                                                :  controller.deliverOrderClick(controller.acceptedOrder[index].orderId);
                                                                          },
                                                                          fontSize: SizeConfig.blockSizeHorizontal*4,
                                                                          backGroundColor: (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1" ?
                                                                          AppColors.colorYellowTheme : AppColors.colorGreen),
                                                                    ),
                                                                  ),





                                                                  // timer
                                                                  Visibility(
                                                                    visible: controller.timeLeft(controller.acceptedOrder[index].created) < 1500 && (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2",
                                                                    child: Container(width: SizeConfig.blockSizeHorizontal*27,
                                                                      padding:   EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1,
                                                                          top: SizeConfig.blockSizeHorizontal*1,
                                                                          bottom: SizeConfig.blockSizeHorizontal*1),
                                                                      child:
                                                                      Align(alignment: Alignment.centerRight,
                                                                        child: CircularCountDownTimer(
                                                                          controller: controller.countdownController,
                                                                          autoStart: true,
                                                                          width: SizeConfig.blockSizeHorizontal*11,
                                                                          height: SizeConfig.blockSizeHorizontal*11,
                                                                          duration:  controller.duration(controller.acceptedOrder[index].created),
                                                                          fillColor:  Colors.grey.shade100,
                                                                          ringColor:  Colors.green,
                                                                          isReverse:  true,
                                                                          strokeWidth: 4,
                                                                          textStyle: TextStyle(color: Colors.black, fontSize: SizeConfig.blockSizeHorizontal*3,
                                                                              fontFamily: FontFamily.fontMedium),
                                                                          onComplete: (){
                                                                            controller.fetchOrdersList();
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ))),
                                                  // order status label top left corner
                                                  Positioned(
                                                    top: SizeConfig.blockSizeHorizontal*10.4,
                                                    left:SizeConfig.blockSizeHorizontal*2.3,
                                                    child: Transform.rotate(
                                                      angle: pi/-2,
                                                      child: SizedBox(
                                                        height: SizeConfig.blockSizeHorizontal*2.2,
                                                        width: SizeConfig.blockSizeHorizontal*2.2,
                                                        child:  CustomPaint(
                                                          painter: TrianglePainter(color: (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2" ?
                                                          AppColors.colorPrimaryShadow :AppColors.colorYellowShadow),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: SizeConfig.blockSizeHorizontal*3.5,
                                                    left:SizeConfig.blockSizeHorizontal*2.3,
                                                    child: ClipPath(
                                                      clipper: SkewCutUpward(),
                                                      child: Container(
                                                        height: SizeConfig.blockSizeHorizontal*7,
                                                        decoration:  BoxDecoration(
                                                            color:  (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2" ?
                                                            AppColors.colorPrimaryPreparing : AppColors.colorYellowTheme,
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(1.5),
                                                                topRight:Radius.circular(1.5),
                                                                bottomRight: Radius.circular(1.5))
                                                        ),
                                                        child: Container(margin:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.75),
                                                          child: TextWidget(text:
                                                          (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2" ?
                                                          "Preparing" : "Ready",
                                                            fontFamily: FontFamily.fontMedium,
                                                            textAlign: TextAlign.center,
                                                            fontSize: SizeConfig.mediumFontSize, color: Colors.white,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                                  // delayed
                                                  Visibility(
                                                    visible: controller.timeLeft(controller.acceptedOrder[index].created) > 1500 && (controller.acceptedOrder[index].orderStatus ?? '').trim() == "2",
                                                    child: Positioned(
                                                      top: SizeConfig.blockSizeHorizontal*3.5,
                                                      right: SizeConfig.blockSizeHorizontal*7.5,
                                                      child: TextWidget(text: "Delayed",
                                                        fontSize: SizeConfig.semiBoldFontSize,
                                                        fontWeight: FontWeight.w800,
                                                        fontFamily: FontFamily.fontBold,
                                                        color: Colors.red,),
                                                    ),
                                                  ),

                                                  // order delivery/pickup info
                                                  Visibility(
                                                    visible:  (controller.acceptedOrder[index].orderStatus ?? '').trim() != "2",
                                                    child: Container(
                                                        height: SizeConfig.blockSizeHorizontal*8.2,
                                                        width: SizeConfig.blockSizeHorizontal*25,
                                                        margin:EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*4.5),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1"?
                                                            AppColors.redBackground : AppColors.colorYellowTheme,
                                                            borderRadius: BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeHorizontal*4.5),
                                                                bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*3))
                                                        ),
                                                        child:  TextWidget(text: (controller.acceptedOrder[index].deliveryType ?? '').trim() == "1"?
                                                        "Delivery" : "TakeAway", fontFamily: FontFamily.fontMedium,
                                                          textAlign: TextAlign.center,
                                                          fontSize: SizeConfig.mediumFontSize, color: Colors.white,)
                                                    ),
                                                  )
                                                ],
                                              );
                                          }
                                      ) ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                              ],
                            )
                        ),
                      ),
                    ],
                  )


              ))),
            ],
          )
        ),
      ) );


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


  void showAllItems(BuildContext context, List<DashboardOrderItemDetails> list){
    if(context.mounted){
        showModalBottomSheet(
            useSafeArea: true,
            context: context,
            scrollControlDisabledMaxHeightRatio: list.length == 1 ?
            4 / 16  :  list.length == 2 ? 6/16
               : list.length == 3 ?  8/16  : 10/16,
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                    Container(
                      height: 3,
                      width: SizeConfig.blockSizeHorizontal*15,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1)
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                        child:TextWidget(text: "Items",
                          fontFamily: FontFamily.fontMedium,
                          fontSize: SizeConfig.mediumFontSize,
                          color: Colors.black, fontWeight: FontWeight.bold,),),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                
                    Expanded(
                      child:  ListView.builder(
                          padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (context , index) {
                            return Padding(padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.75),
                              child: Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                
                                      Container(
                                        width: SizeConfig.blockSizeHorizontal*7,
                                        height: SizeConfig.blockSizeHorizontal*7,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: AppColors.white,
                                            borderRadius: BorderRadius.circular(6.0),
                                            border: Border.all(color: Colors.black12,width: 0.75)
                                        ),
                                        child: TextWidget(text: list[index].itemCount ?? '0',
                                            color:  AppColors.blackShades, fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium),
                                      ),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                      TextWidget(text: "x", fontSize: SizeConfig.regularFontSize, color: AppColors.blackShades,
                                          fontFamily: FontFamily.fontMedium),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal*58,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            (list[index].customisationTitle ?? '').trim().isEmpty ?
                                            TextWidget(text:
                                            list[index].itemName ?? '',
                                                color:  AppColors.blackText,fontSize: SizeConfig.regularFontSize,
                                                fontFamily: FontFamily.fontMedium)
                
                
                                                : RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: list[index].itemName ?? '',
                                                          style: TextStyle(
                                                              color:  AppColors.blackText,fontSize: SizeConfig.regularFontSize,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily: FontFamily.fontMedium)
                                                      ),
                                                      TextSpan(
                                                          text: ' [ ${list[index].customisationTitle ?? ''} ]',
                                                          style: TextStyle(
                                                              color:  AppColors.colorPrimary,fontSize: SizeConfig.regularFontSize,
                                                              fontFamily: FontFamily.fontSemiBold)
                                                      ),
                
                                                    ]
                                                )),
                                            Visibility(
                                              visible: (list[index].toppings ?? []).isNotEmpty,
                                              child: TextWidget(text: (list[index].toppings ?? []).map((topping) => topping.title).where((title) => title != null).join(', '),
                                                  color:  AppColors.blackShades,fontSize:  SizeConfig.regularFontSize,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal*0.1),
                                      Expanded(
                                        child: TextWidget(text: "₹${list[index].price}",
                                            textAlign: TextAlign.end,
                                            color:  AppColors.blackShades, fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: FontFamily.fontMedium),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: index != list.length - 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.75,
                                          vertical: SizeConfig.blockSizeHorizontal *2.5),
                                      child:  const MySeparator(color: AppColors.colorGrey1,dashWidth: 3,
                                          height: 0.7),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            });
    }

  }

}


/* Visibility(
                        visible: false, /// extra
                        child: Container(
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*1),
                            alignment: Alignment.center,
                            child:
                            controller.receivedOrder.isNotEmpty ?
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextWidget(text: "You have ( ${controller.receivedOrder.length} ) new orders",
                                  fontFamily: FontFamily.fontSemiBold,
                                  fontSize: SizeConfig.semiBoldFontSize,
                                  color: Colors.white,),
                                Icon(CupertinoIcons.arrow_up_right_circle_fill, color: Colors.white,size: SizeConfig.blockSizeHorizontal*11,)
                              ],
                            )
                                : TextWidget(text: waiting,color: Colors.white, fontSize: SizeConfig.semiBoldFontSize
                                ,fontFamily: FontFamily.fontSemiBold)

                        ),
                      )
*/