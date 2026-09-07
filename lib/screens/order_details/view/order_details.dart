import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/screens/order_details/controller/order_details_controller.dart';
import 'package:food_merchant/utils/SetUpOrdersData.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/DottedLine.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';

class OrderDetails extends GetView<OrderDetailsController> {
  const OrderDetails({super.key});
  @override
  Widget build(BuildContext context) {
    showBottomSheet(){
      if(context.mounted){
        showCustomBottomSheet(
            context: context,
            title: orderBillDetails,
            childWidget: Column(
              children: [
                // items total
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                      vertical: SizeConfig.blockSizeHorizontal * 1.5),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: orderItemsTotal,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.regularFontSize,
                            color: normalTextColor),
                      ),
                      Expanded(
                        child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.itemsTotal ?? '0'}",
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            textAlign: TextAlign.end,
                            color: blackShades),
                      ),
                    ],
                  ),
                ),


                // delivery charges
                Visibility(
                  visible: (controller.orderDetails.value.deliveryType ?? '').trim() == "1" &&
                      (num.tryParse(controller.orderDetails.value.adminCharge ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderDeliveryCharges,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.adminCharge ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                // packaging charge
                Visibility(
                  visible: (num.tryParse(controller.orderDetails.value.packagingCharges ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderPackagingCharges,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.packagingCharges ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                // platform fee
                Visibility(
                  visible: (num.tryParse(controller.orderDetails.value.platformFee ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderPlatformFees,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.platformFee ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                // tip
                Visibility(
                  visible: (num.tryParse(controller.orderDetails.value.tipPrice ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderTipPrice,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.tipPrice ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                // gst
                Visibility(
                  visible: (num.tryParse(controller.orderDetails.value.gst ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderGstCharges,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.orderDetails.value.gst ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                // discount price
                Visibility(
                  visible: (num.tryParse(controller.orderDetails.value.discountPrice ?? '0') ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderDiscountPrice,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "- $currSymbolIn${controller.orderDetails.value.discountPrice ?? '0'}",
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                // round off
                Visibility(
                  visible: controller.roundOffAmountOrder(controller.orderDetails.value.roundOff).trim().isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: orderRoundOff,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: controller.roundOffAmountOrder(controller.orderDetails.value.roundOff),
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color:  blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical:SizeConfig.blockSizeHorizontal * 3 ),
                    child:  const MySeparator(dashWidth: 3, color: blackShades,)),


                // grand total
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                      vertical: SizeConfig.blockSizeHorizontal * 1.5),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: orderGrandTotal,
                            fontFamily: fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: Colors.black),
                      ),
                      Expanded(
                        child: TextWidget(text: "$currSymbolIn${controller.setItemsTotal()}",
                            fontFamily: fontSemiBold,
                            fontSize: SizeConfig.mediumFontSize,
                            textAlign: TextAlign.end,
                            color: colorPrimary),
                      ),
                    ],
                  ),
                )
              ]
            ));
      }

    }


    List<Widget> widgetList = [];
    var child =  PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
         } else {
          controller.getBack();
        }

      },
      child: Scaffold(
       resizeToAvoidBottomInset: false,
       backgroundColor: colorWhite,
       appBar: AppBar(
       elevation: 0.0,
       backgroundColor: colorWhite,
       centerTitle: true,
       title: TextWidget(text: order_details_title,
         color: Colors.black,
         fontSize: SizeConfig.appbarTitleSize,
         fontFamily: fontSemiBold,
         weight: FontWeight.w600,),
       ),
      body: SafeArea(
        child: Obx(()=>
        controller.orderDetails.value.totalPrice == null ? Container() :
        SizedBox(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
        child: Column(mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
              children: [
                // customer information
                Container(
                  color: colorGrey1,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.5),
                  child: TextWidget(
                    text:  customer_information,
                    color:  Colors.black,
                    fontSize:  SizeConfig.mediumFontSize,
                    weight: FontWeight.w600,),
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                  color: colorWhite,
                  child: Column(
                    children: [
                      // customer name & phone
                      Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Expanded(flex: 3,
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person, color: colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*0.75),
                              Flexible(child: TextWidget(
                                  text: controller.orderDetails.value.userName ?? '',
                                  color: blackShades,
                                  fontFamily: fontMedium,
                                  fontSize: SizeConfig.mediumFontSize),)
                            ]
                          )),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                          // phone
                          Expanded(flex: 2,
                              child: InkWell(
                                highlightColor: Colors.white,
                                onTap: () {
                                  controller.calling();
                                },
                                child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.phone, color: colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*0.75),
                                  Flexible(child: TextWidget(
                                      text:   controller.orderDetails.value.phone ?? '',
                                      color:   blackShades,
                                      fontFamily: fontMedium,
                                      fontSize:   SizeConfig.mediumFontSize),)
                                ]
                                                        ),
                              ))
                        ]
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal*3),

                      // delivery - pickup info
                      (controller.orderDetails.value.deliveryType ?? '').trim() == "1" ?
                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:  RichText(
                                text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.location_on, color: colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                                      ),
                                      TextSpan(
                                          text: ' ${controller.orderDetails.value.deliveryAddress ?? ''}',
                                          style: TextStyle(
                                              color: blackShades,
                                              fontSize: SizeConfig.mediumFontSize,
                                              fontFamily: fontMedium)
                                      ),
        
                                    ]
                                )),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*0.5),
                          Visibility(
                            visible: (controller.orderDetails.value.deliveryType ?? '').trim() == "1"
                                && (controller.orderDetails.value.orderStatus ?? '').trim() != "5"
                                && (controller.orderDetails.value.orderStatus ?? '').trim() != "3" ,
                            child: InkWell(
                              highlightColor: Colors.white,
                              onTap: () {
                                controller.openMap();
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5),
                                child: Icon(Icons.directions, color: colorPrimary,
                                    size: SizeConfig.blockSizeHorizontal*8),
                              ),
                            ),
                          )
                        ],
                      )
                      : Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                          Flexible(
                            child: TextWidget(text: selfPickUp,
                              fontFamily: fontMedium,color: blackShades,fontSize: SizeConfig.mediumFontSize,),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        
        
        
                // order information
                Container(
                  color: colorGrey1,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.5),
                  child: TextWidget(
                    text:  order_information,
                    color:  Colors.black,
                    fontSize:  SizeConfig.mediumFontSize,
                    weight: FontWeight.w600,),
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                  color: colorWhite,
                  child: Column(
                    children: [
                      //order id
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: TextWidget(
                                    text:   '#${controller.orderDetails.value.orderId ?? ''}',
                                    color:   blackShades,
                                    fontFamily: fontMedium,
                                    weight: FontWeight.bold,
                                    fontSize:   SizeConfig.mediumFontSize))
                          ]
                      ),
        
                      // order status and payment status
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // order status
                            Expanded(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => SetUpOrdersData.stUP.setUpButtonColor(controller.orderDetails.value.orderStatus!).createShader(bounds),
                                  child: Text(
                                      SetUpOrdersData.stUP.setUpOrderStatus(controller.orderDetails.value.orderStatus!),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: SizeConfig.mediumFontSize,
                                          fontFamily: fontMedium)
                                  ),
                                )),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*1),


                            // payment status
                            controller.orderDetails.value.orderStatus == "5" ?
                            Container(
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
                                    fontFamily: fontMedium
                                ),
                              ),
                            )
        
                                :  controller.orderDetails.value.paymentType == "1" ?
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
                                    fontFamily: fontMedium
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
                                    fontFamily: fontMedium
                                ),
                              ),
                            ),
                          ]
                      ),
                      const Divider(color: colorGrey1, thickness: 0.29,),
                      SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                      // items
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (controller.orderDetails.value.products ?? []).length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal*7,
                                      height: SizeConfig.blockSizeHorizontal*7,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: colorWhite,
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: Colors.black12,width: 0.75)
                                      ),
                                      child: TextWidget(text: controller.orderDetails.value.products?[index].productQuantity ?? '-',
                                          color:  blackShades, fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium),
                                    ),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                    TextWidget(text: "x", fontSize: SizeConfig.regularFontSize, color: blackShades,
                                        fontFamily: fontMedium),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*58,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          (controller.orderDetails.value.products?[index].customisationTitle ?? '').trim().isEmpty ?
                                          TextWidget(text:
                                          controller.orderDetails.value.products?[index].productName ?? 'N/A',
                                              color:  colorBlack,fontSize: SizeConfig.regularFontSize,
                                              fontFamily: fontMedium)
        
        
                                         : RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: controller.orderDetails.value.products?[index].productName ?? 'N/A',
                                                        style: TextStyle(
                                                            color:  colorBlack,fontSize: SizeConfig.regularFontSize,
                                                            fontWeight: FontWeight.normal,
                                                            fontFamily: fontMedium)
                                                    ),
                                                    TextSpan(
                                                        text: ' [ ${controller.orderDetails.value.products?[index].customisationTitle ?? 'N/A'} ]',
                                                        style: TextStyle(
                                                            color:  colorPrimary,fontSize: SizeConfig.regularFontSize,
                                                            fontFamily: fontSemiBold)
                                                    ),
        
                                                  ]
                                              )),
                                          Visibility(
                                            visible: (controller.orderDetails.value.products?[index].toppings ?? []).isNotEmpty,
                                            child: TextWidget(text: (controller.orderDetails.value.products?[index].toppings ?? []).map((topping) => topping.title).where((title) => title != null).join(', '),
                                                color:  blackShades,fontSize:  SizeConfig.regularFontSize,
                                                weight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*0.1),
                                    Expanded(
                                      child: TextWidget(text: "₹${controller.orderDetails.value.products?[index].productPrice ?? '0'}",
                                          textAlign: TextAlign.end,
                                          color:  blackShades, fontSize: SizeConfig.mediumFontSize,
                                          fontFamily: fontMedium),
                                    )
        
                                  ],
                                ),
                                Visibility(
                                  visible: index != (controller.orderDetails.value.products ?? []).length - 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.75,
                                        vertical: SizeConfig.blockSizeHorizontal *2.5),
                                    child:  const MySeparator(color: disabledBorderColor,dashWidth: 3,
                                        height: 0.7),
                                  ),
                                )
                              ],
                            );
                          }),
        
                      SizedBox(height: SizeConfig.blockSizeHorizontal*4),
                      const Divider(color: colorGrey1, thickness: 0.29,),
                      // grand total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextWidget(text: grand_total,
                                color: blackShades,
                                fontFamily: fontSemiBold,
                                fontSize:   SizeConfig.mediumFontSize),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1.5),
                          Expanded(
                            flex: 3,
                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.currency_rupee,size: SizeConfig.regularFontSize,color: colorPrimary,),
                                  Flexible(
                                    child: TextWidget(text: controller.setItemsTotal(),
                                      fontFamily: fontBold,color: colorPrimary,fontSize: SizeConfig.mediumFontSize,),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        showBottomSheet();
                                      },
                                      child: Container(
                                          padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,
                                              right: SizeConfig.blockSizeHorizontal*3,
                                              top: SizeConfig.blockSizeHorizontal*2.5,
                                              bottom: SizeConfig.blockSizeHorizontal*2.5),
                                          child: Icon(CupertinoIcons.info,size: SizeConfig.regularFontSize,color: Colors.blue,))),
                                ],
                              )
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                    ],
                  ),
                ),
        
              ],
              ),
            ),
            Visibility(
              visible: (controller.orderDetails.value.orderStatus ?? '').trim() != "5"
                  && (controller.orderDetails.value.orderStatus ?? '').trim() != "3" ,
              child: Container(
                height: SizeConfig.blockSizeHorizontal * 18,
                padding:  EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*3.75,
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255.0 * 0.2).round()),
                        offset: const Offset(0, -4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: controller.orderDetails.value.orderStatus == "1" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(padding:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1),
                      width: SizeConfig.blockSizeHorizontal*31,
                      child: ButtonWidget(text: decline_btn,
                          onPressed: (){
                            controller.cancelOrder();
                          },
                          roundedCorner: 6.5,
                          height: SizeConfig.blockSizeHorizontal*11,
                          fontSize: SizeConfig.regularFontSize,
                          backGroundColor: Colors.redAccent),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1),
                        child: ButtonWidget(
                            height: SizeConfig.blockSizeHorizontal*11,
                            text:  accept_order_btn,
                            roundedCorner: 6.5,
                            onPressed: (){
                              controller.acceptDeclineOrders("2");
                            },
                            fontSize: SizeConfig.blockSizeHorizontal*4,
                            backGroundColor: Colors.green
                        ),
                      ),
                    ),
                  ],
                )
        
        
                    :  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    controller.orderDetails.value.orderStatus == "2" ?
                    Expanded(
                      child: ButtonWidget(
                          height: SizeConfig.blockSizeHorizontal*11,
                          text:  mark_as_ready,
                          roundedCorner: 6.0,
                          onPressed: (){
                            controller.acceptDeclineOrders("7");
                          },
                          fontSize: SizeConfig.blockSizeHorizontal*4,
                          backGroundColor: colorYellowTheme),
                    )
        
                        : controller.orderDetails.value.orderStatus == "7" ?
                    Expanded(
                      child: ButtonWidget(
                          height: SizeConfig.blockSizeHorizontal*11,
                          text: controller.orderDetails.value.deliveryType == "1" ?
                          mark_as_out_for_delivery : mark_as_delivered,
                          roundedCorner: 6.0,
                          onPressed: (){
                            controller.orderDetails.value.deliveryType == "1" ?
                            controller.acceptDeclineOrders("4")
                                :  controller.deliverOrderClick();
                          },
                          fontSize: SizeConfig.blockSizeHorizontal*4,
                          backGroundColor: controller.orderDetails.value.deliveryType == "1" ?
                          colorYellowTheme : colorGreen),
                    )
        
                  :  Expanded(
                      child: ButtonWidget(
                          height: SizeConfig.blockSizeHorizontal*11,
                          text:  mark_as_delivered,
                          roundedCorner: 6.0,
                          onPressed: (){
                            controller.deliverOrderClick();
                          },
                          fontSize: SizeConfig.blockSizeHorizontal*4,
                          backGroundColor: colorYellowTheme),
                    )
        
        
        
                  ],
                ),
              ),
            ),




            Visibility(
              visible: (controller.orderDetails.value.orderStatus ?? '').trim() == "5",
                child: Container(
                  height: SizeConfig.blockSizeHorizontal * 18,
                  padding:  EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*3.75,
                      horizontal: SizeConfig.blockSizeHorizontal * 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((255.0 * 0.2).round()),
                          offset: const Offset(0, -4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ButtonWidget(
                            height: SizeConfig.blockSizeHorizontal*11,
                            text:  orderPrintBill,
                            roundedCorner: 6.0,
                            onPressed: (){
                              controller.printOrderBill();
                            },
                            fontSize: SizeConfig.blockSizeHorizontal*4,
                            backGroundColor: colorPrimary),
                      )
                    ],
                  )
                ))
          ],
        ) ,
        
        
        
        
        
        
        )),
      )),
    );

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










