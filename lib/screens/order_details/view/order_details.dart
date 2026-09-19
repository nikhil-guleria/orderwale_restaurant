import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/screens/order_details/controller/order_details_controller.dart';
import 'package:food_merchant/screens/order_details/models/order_details_model.dart';
import 'package:food_merchant/utils/SetUpOrdersData.dart';
import 'package:get/get.dart';
import '../../../component/button_widget.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/DottedLine.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';

class OrderDetails extends GetView<OrderDetailsController> {
  const OrderDetails({super.key});
  @override
  Widget build(BuildContext context) {
    showBottomSheet(){
      if(context.mounted){
        showCustomBottomSheet(
            context: context,
            title: AppStrings.orderDetailsBillDetails,
            childWidget: Column(
              children: [
                // items total
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                      vertical: SizeConfig.blockSizeHorizontal * 1.5),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: AppStrings.orderDetailsItemsTotal,
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.regularFontSize,
                            color: AppColors.normalTextColor),
                      ),
                      Expanded(
                        child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.orderDetails.value.itemsTotal ?? '0'}",
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            textAlign: TextAlign.end,
                            color: AppColors.blackShades),
                      ),
                    ],
                  ),
                ),


                // delivery charges
                Visibility(
                  visible: ((num.tryParse(controller.orderDetails.value.adminCharge ?? '0') ?? 0) > 0
                      || (num.tryParse(controller.orderDetails.value.deliveryCharge ?? "0") ?? 0) > 0) &&
                      (controller.orderDetails.value.deliveryType ?? '').trim() == "1" ,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                        vertical: SizeConfig.blockSizeHorizontal * 1.5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(text: AppStrings.orderDetailsDeliveryCharges,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${
                              (num.tryParse(controller.orderDetails.value.adminCharge ?? '0') ?? 0) > 0 ?
                              controller.orderDetails.value.adminCharge ?? "0"
                                  : controller.orderDetails.value.deliveryCharge ?? "0"}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.blackShades),
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
                          child: TextWidget(text: AppStrings.orderDetailsPackagingCharges,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.orderDetails.value.packagingCharges ?? '0'}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.blackShades),
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
                          child: TextWidget(text: AppStrings.orderDetailsPlatformFees,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.orderDetails.value.platformFee ?? '0'}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.blackShades),
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
                          child: TextWidget(text: AppStrings.orderDetailsTipPrice,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.orderDetails.value.tipPrice ?? '0'}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.blackShades),
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
                          child: TextWidget(text: (controller.orderDetails.value.appliedTaxes ?? '').trim().isEmpty ?
                          AppStrings.orderDetailsGstCharges : (controller.orderDetails.value.appliedTaxes ?? ''),
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.orderDetails.value.gst ?? '0'}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.blackShades),
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
                          child: TextWidget(text: AppStrings.orderDetailsDiscountPrice,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: "- ${AppStrings.currSymbolIn}${controller.orderDetails.value.discountPrice ?? '0'}",
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color: AppColors.grey),
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
                          child: TextWidget(text: AppStrings.orderDetailsRoundOff,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor),
                        ),
                        Expanded(
                          child: TextWidget(text: controller.roundOffAmountOrder(controller.orderDetails.value.roundOff),
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              textAlign: TextAlign.end,
                              color:  AppColors.blackShades),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical:SizeConfig.blockSizeHorizontal * 3 ),
                    child:  const MySeparator(dashWidth: 3, color: AppColors.blackShades,)),


                // grand total
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4 ,
                      vertical: SizeConfig.blockSizeHorizontal * 1.5),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(text: AppStrings.orderDetailsGrandTotal,
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: AppColors.blackText),
                      ),
                      Expanded(
                        child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.setItemsTotal()}",
                            fontFamily: FontFamily.fontSemiBold,
                            fontSize: SizeConfig.mediumFontSize,
                            textAlign: TextAlign.end,
                            color: AppColors.colorPrimary),
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
       backgroundColor: AppColors.white,
       appBar: buildAppBar(title: AppStrings.orderDetailsTitle),
      body: SafeArea(
        child: Obx(()=>
        controller.orderDetails.value.totalPrice == null ? Container() :
        SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
        child: Column(mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
              children: [
                // customer information
                Container(
                  color: AppColors.colorGrey1,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.5),
                  child: TextWidget(
                    text:  AppStrings.orderDetailsCustomerInfo,
                    color:  AppColors.blackText,
                    fontSize:  SizeConfig.mediumFontSize,
                    fontWeight: FontWeight.w600,),
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                  color: AppColors.white,
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
                              Icon(Icons.person, color: AppColors.colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*0.75),
                              Flexible(child: TextWidget(
                                  text: controller.orderDetails.value.userName ?? '',
                                  color: AppColors.blackShades,
                                  fontFamily: FontFamily.fontMedium,
                                  fontSize: SizeConfig.mediumFontSize),)
                            ]
                          )),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                          // phone
                          Expanded(flex: 2,
                              child: InkWell(
                                highlightColor: AppColors.white,
                                onTap: () {
                                  controller.calling();
                                },
                                child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.phone, color: AppColors.colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*0.75),
                                  Flexible(child: TextWidget(
                                      text:   controller.orderDetails.value.phone ?? '',
                                      color:   AppColors.blackShades,
                                      fontFamily: FontFamily.fontMedium,
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
                                        child: Icon(Icons.location_on, color: AppColors.colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                                      ),
                                      TextSpan(
                                          text: ' ${controller.orderDetails.value.deliveryAddress ?? ''}',
                                          style: TextStyle(
                                              color: AppColors.blackShades,
                                              fontSize: SizeConfig.mediumFontSize,
                                              fontFamily: FontFamily.fontMedium)
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
                              highlightColor: AppColors.white,
                              onTap: () {
                                controller.openMap();
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5),
                                child: Icon(Icons.directions, color: AppColors.colorPrimary,
                                    size: SizeConfig.blockSizeHorizontal*8),
                              ),
                            ),
                          )
                        ],
                      )
                      : Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: AppColors.colorPrimary,size: SizeConfig.blockSizeHorizontal*5),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                          Flexible(
                            child: TextWidget(text: AppStrings.selfPickUp,
                              fontFamily: FontFamily.fontMedium,color: AppColors.blackShades,fontSize: SizeConfig.mediumFontSize,),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        
        
        
                // order information
                Container(
                  color: AppColors.colorGrey1,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.5),
                  child: TextWidget(
                    text:  AppStrings.orderDetailsOrderInfo,
                    color:  AppColors.black,
                    fontSize:  SizeConfig.mediumFontSize,
                    fontWeight: FontWeight.w600,),
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.75),
                  color: AppColors.white,
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
                                    color:   AppColors.blackShades,
                                    fontFamily: FontFamily.fontMedium,
                                    fontWeight: FontWeight.bold,
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
                                  shaderCallback: (bounds) => SetUpOrdersData.stUP.setUpButtonColor(controller.orderDetails.value.orderStatus ?? '').createShader(bounds),
                                  child: Text(
                                      SetUpOrdersData.stUP.setUpOrderStatus(controller.orderDetails.value.orderStatus ?? ''),
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: SizeConfig.mediumFontSize,
                                          fontFamily: FontFamily.fontMedium)
                                  ),
                                )),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*1),


                            // payment status
                            controller.orderDetails.value.orderStatus == "5" ?
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(width: 1, color: AppColors.green)
                              ),
                              child: Center(
                                child: TextWidget(
                                    text: AppStrings.headingPaid,
                                    color: AppColors.green,
                                    fontSize: SizeConfig.blockSizeHorizontal*3,
                                    fontFamily: FontFamily.fontMedium
                                ),
                              ),
                            )
        
                                :  controller.orderDetails.value.paymentType == "1" ?
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(width: 1, color: AppColors.red.shade300)
                              ),
                              child: Center(
                                child: TextWidget(
                                    text: AppStrings.headingUnpaid,
                                    color: AppColors.red.shade300,
                                    fontSize: SizeConfig.blockSizeHorizontal*3,
                                    fontFamily: FontFamily.fontMedium
                                ),
                              ),
                            )
                                : Container(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*0.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(width: 1, color: AppColors.green)
                              ),
                              child: Center(
                                child: TextWidget(
                                    text: AppStrings.headingPaid,
                                    color: AppColors.green,
                                    fontSize: SizeConfig.blockSizeHorizontal*3,
                                    fontFamily: FontFamily.fontMedium
                                ),
                              ),
                            ),
                          ]
                      ),
                      const Divider(color: AppColors.colorGrey1, thickness: 0.29,),
                      SizedBox(height: SizeConfig.blockSizeHorizontal*3),
                      // items
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.expandedKot().length,
                          itemBuilder: (context, index) {
                            RestaurantOrderItemsData item = controller.expandedKot()[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal*7,
                                      height: SizeConfig.blockSizeHorizontal*7,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: AppColors.white,
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: AppColors.black12,width: 0.75)
                                      ),
                                      child: TextWidget(text: "${item.itemCount ?? '-'}",
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
                                          (item.customisationTitle ?? '').trim().isEmpty ?
                                          TextWidget(text:
                                          item.itemName ?? 'N/A',
                                              color:  AppColors.blackText,fontSize: SizeConfig.regularFontSize,
                                              fontFamily: FontFamily.fontMedium)
        
        
                                         : RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: item.itemName ?? 'N/A',
                                                        style: TextStyle(
                                                            color:  AppColors.blackText,fontSize: SizeConfig.regularFontSize,
                                                            fontWeight: FontWeight.normal,
                                                            fontFamily: FontFamily.fontMedium)
                                                    ),
                                                    TextSpan(
                                                        text: ' [ ${item.customisationTitle ?? 'N/A'} ]',
                                                        style: TextStyle(
                                                            color:  AppColors.colorPrimary,fontSize: SizeConfig.regularFontSize,
                                                            fontFamily: FontFamily.fontSemiBold)
                                                    ),
        
                                                  ]
                                              )),
                                          Visibility(
                                            visible: (item.toppings ?? []).isNotEmpty,
                                            child: TextWidget(text: (item.toppings ?? []).map((topping) => topping.title).where((title) => title != null).join(', '),
                                                color:  AppColors.blackShades,fontSize:  SizeConfig.regularFontSize,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal*0.1),
                                    Expanded(
                                      child: TextWidget(text: "${AppStrings.currSymbolIn}${item.price ?? '0'}",
                                          textAlign: TextAlign.end,
                                          color:  AppColors.blackShades, fontSize: SizeConfig.mediumFontSize,
                                          fontFamily: FontFamily.fontMedium),
                                    )
        
                                  ],
                                ),
                                Visibility(
                                  visible: index != controller.expandedKot().length - 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3.75,
                                        vertical: SizeConfig.blockSizeHorizontal *2.5),
                                    child:  const MySeparator(color: AppColors.disabledBorderColor,dashWidth: 3,
                                        height: 0.7),
                                  ),
                                )
                              ],
                            );
                          }),
        
                      SizedBox(height: SizeConfig.blockSizeHorizontal*4),
                      const Divider(color: AppColors.colorGrey1, thickness: 0.29,),
                      // grand total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextWidget(text: AppStrings.orderDetailsGrandTotal,
                                color: AppColors.blackShades,
                                fontFamily: FontFamily.fontSemiBold,
                                fontSize:   SizeConfig.mediumFontSize),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*1.5),
                          Expanded(
                            flex: 3,
                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.currency_rupee,size: SizeConfig.regularFontSize,color: AppColors.colorPrimary,),
                                  Flexible(
                                    child: TextWidget(text: controller.setItemsTotal(),
                                      fontFamily: FontFamily.fontBold,color: AppColors.colorPrimary,fontSize: SizeConfig.mediumFontSize,),
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
                                          child: Icon(CupertinoIcons.info,size: SizeConfig.regularFontSize,color: AppColors.colorPrimary))),
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
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withAlpha((255.0 * 0.2).round()),
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
                          backGroundColor: AppColors.redAccent),
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
                            backGroundColor: AppColors.green
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
                          backGroundColor: AppColors.colorYellowTheme),
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
                          AppColors.colorYellowTheme : AppColors.colorGreen),
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
                          backGroundColor: AppColors.colorYellowTheme),
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
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withAlpha((255.0 * 0.2).round()),
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
                            text:  AppStrings.orderDetailsPrintBill,
                            roundedCorner: 6.0,
                            onPressed: (){
                              controller.printOrderBill();
                            },
                            fontSize: SizeConfig.blockSizeHorizontal*4,
                            backGroundColor: AppColors.colorPrimary),
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










