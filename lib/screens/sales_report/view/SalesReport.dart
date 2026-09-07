import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/utils/DateTimeUtils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/DottedLine.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/app_images.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';
import '../controller/sales_report_controller.dart';

class SalesReport extends GetView<SalesReportController>{
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
            title: TextWidget(text: salesReportTitle,
              color: Colors.black,
              fontSize: SizeConfig.appbarTitleSize,
              fontFamily: fontSemiBold,
              weight: FontWeight.w600,),

            centerTitle: true,
            elevation: 0.0),
    body: SafeArea(
      child: Obx(() =>
      controller.initialLoad.value ?
      Center(child: TextWidget(text: "Please wait...",color: colorPrimary,
          fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium))
         : Container(
          height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
              bottom:  SizeConfig.blockSizeHorizontal*2,
              top: SizeConfig.blockSizeHorizontal*2,
              left: SizeConfig.blockSizeHorizontal*3,
              right: SizeConfig.blockSizeHorizontal*3),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedContainer(
                padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 3),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(controller.xOffset.value,
                    controller.yOffset.value, -1.0)..scale(controller.pageScale.value),
                child: double.parse(controller.salesReport.value.balance!) > 0 ?
                Visibility(
                    visible: controller.requestedBalance(controller.salesReport.value.balance ?? '0')
                        != "0" && controller.salesReport.value.withdrawalStatus != 1,
                    child: Material(
                      elevation: 2.2,
                      color: colorWhite,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5,
                                vertical: SizeConfig.blockSizeHorizontal * 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Image.asset(paymentSettlement,
                                    height: SizeConfig.blockSizeHorizontal*6.5,
                                    width: SizeConfig.blockSizeHorizontal*6.5),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                Expanded(
                                  child: RichText(text: TextSpan(
                                      text: salesReportReminder,
                                      style: TextStyle(
                                        fontFamily: fontMedium,
                                          color: redBackground,
                                          fontSize: SizeConfig.mediumFontSize,
                                        fontWeight: FontWeight.bold
                                      ),
                                      children: [
                                        TextSpan(
                                            text: salesReportRequest1,
                                            style: TextStyle(
                                                color: blackShades,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: fontMedium,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),
                                        TextSpan(
                                            text: " $currSymbolIn${controller.salesReport.value.balance ?? "0"}",
                                            style: TextStyle(
                                                color: colorPrimary,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: fontMedium,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        TextSpan(
                                            text: salesReportRequest2,
                                            style: TextStyle(
                                                color: blackShades,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: fontMedium,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),

                                      ])),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            highlightColor: colorWhite,
                            splashColor: colorWhite,
                            onTap: (){
                              controller.requestApiClick();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: colorPrimary
                              ),
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,
                                  vertical: SizeConfig.blockSizeHorizontal*1),
                              margin: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 2.5,
                                  bottom: SizeConfig.blockSizeHorizontal * 3.5),
                              child: TextWidget(text: salesReportRequestNow,
                                  fontSize: SizeConfig.regularFontSize,
                                  color: colorWhite,
                                  weight: FontWeight.bold),
                            ),
                          ),
                        ]
                      )
                    ))
              :  Visibility(
                  visible: controller.previousBalance(controller.salesReport.value.balance!)
                  != "0",
                  child: Material(
                    elevation: 2.2,
                    color: colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5,
                          vertical: SizeConfig.blockSizeHorizontal * 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Image.asset(paymentSettlement,
                              height: SizeConfig.blockSizeHorizontal*6.5,
                              width: SizeConfig.blockSizeHorizontal*6.5),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                              Expanded(
                                child: RichText(text: TextSpan(
                                    text: salesReportReminder,
                                    style: TextStyle(
                                        fontFamily: fontMedium,
                                        color: redBackground,
                                        fontSize: SizeConfig.mediumFontSize,
                                        fontWeight: FontWeight.bold
                                    ),

                                children: [
                                  TextSpan(
                                    text: salesReportClearYour,
                                      style: TextStyle(
                                          fontFamily: fontMedium,
                                          color: blackShades,
                                          fontSize: SizeConfig.regularFontSize,
                                          fontWeight: FontWeight.normal
                                      ),
                                  ),
                                  TextSpan(
                                      text: "$currSymbolIn${controller.previousBalance(controller.salesReport.value.balance!)}",
                                      style: TextStyle(
                                          fontFamily: fontMedium,
                                          color: colorPrimary,
                                          fontSize: SizeConfig.regularFontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                  ),


                                ])),
                              ),
                            ],
                          ),
                        ),
                        Obx(() =>   Visibility(
                            visible: controller.isCashFree.value ,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 5,
                                ),
                                RadioListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: TextWidget(text: salesReportUpi,
                                                fontSize: SizeConfig.regularFontSize)),
                                        Image.asset(cashFreeUpi,
                                          width: SizeConfig.blockSizeHorizontal*6,
                                          height:  SizeConfig.blockSizeHorizontal*6,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                    value: 1,
                                    activeColor: colorPrimary,
                                    groupValue: controller.paymentOptionValue.value,
                                    onChanged: (value) {
                                      controller.paymentOptionValue.value = value!;
                                    }),
                                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                const MySeparator(color: disabledBorderColor,dashWidth: 3, height: 0.7),
                                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                RadioListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: TextWidget(text: salesReportCard,
                                                fontSize: SizeConfig.regularFontSize)),
                                        Image.asset(cashFreeCard,
                                          width: SizeConfig.blockSizeHorizontal*6,
                                          height:  SizeConfig.blockSizeHorizontal*6,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                    value: 2,
                                    activeColor: colorPrimary,
                                    groupValue: controller.paymentOptionValue.value,
                                    onChanged: (value) {
                                      controller.paymentOptionValue.value = value!;
                                    }),
                                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                const MySeparator(color: disabledBorderColor,dashWidth: 3, height: 0.7),
                                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                RadioListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: TextWidget(text: salesReportNetBanking,
                                                fontSize: SizeConfig.regularFontSize)),
                                        Image.asset(cashFreeNetBanking,
                                          width: SizeConfig.blockSizeHorizontal*6,
                                          height: SizeConfig.blockSizeHorizontal*6,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                    value: 3,
                                    activeColor: colorPrimary,
                                    groupValue: controller.paymentOptionValue.value,
                                    onChanged: (value) {
                                      controller.paymentOptionValue.value = value!;
                                    }),
                                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                              ],
                            ))),
                        InkWell(
                          highlightColor: colorWhite,
                          splashColor: colorWhite,
                          onTap: (){
                            controller.checkForCashFree();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: colorPrimary
                            ),
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,
                            vertical: SizeConfig.blockSizeHorizontal*1),
                            margin: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 2.5,
                                bottom: SizeConfig.blockSizeHorizontal * 3.5),
                            child: TextWidget(text: salesReportPayNow,
                            fontSize: SizeConfig.regularFontSize,
                            color: colorWhite,
                            weight: FontWeight.bold),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.deepPurple
                ),
                child: Column(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                      width: Get.width,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(text: salesReportAccountBalance,
                          fontSize: SizeConfig.regularFontSize,fontFamily: fontMedium,
                          color: Colors.white,),

                          TextWidget(text:"$currSymbolIn${controller.salesReport.value.balance ?? '0'}",
                              letterSpacing: 0.5,
                              fontSize: SizeConfig.semiBoldFontSize,
                              color: double.parse(controller.salesReport.value.balance ?? "0") >= 0 ?
                              Colors.lightGreenAccent : redColorAmount,
                              fontFamily: fontSemiBold),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white60,height: 0.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal*4,
                                top:SizeConfig.blockSizeHorizontal*3,
                            bottom: SizeConfig.blockSizeHorizontal*4),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(text: salesReportThisMonth,
                                  fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                                  color: Colors.white,),
                                RichText(
                                  text: TextSpan(
                                    text: "$salesReportSales:  ",
                                      style: TextStyle(
                                          fontSize: SizeConfig.regularFontSize,
                                          color: Colors.white,
                                          fontFamily: fontMedium),
                                    children: [
                                      TextSpan(
                                          text: currSymbolIn,
                                          style: TextStyle(
                                              fontSize: SizeConfig.mediumFontSize,
                                              color: Colors.white,
                                              fontFamily: fontMedium) ),
                                      TextSpan(text:
                                      controller.salesReport.value.thisMonthSales == "" ? controller.formatAmount(double.parse("0"))
                                    :  controller.formatAmount(double.parse(controller.salesReport.value.thisMonthSales ?? "0")),
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: SizeConfig.mediumFontSize,
                                            color: Colors.white,
                                            fontFamily: fontSemiBold),
                                      ),
                                    ],

                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                                RichText(
                                  text: TextSpan(
                                    text: "$salesReportOrders:  ",
                                    style: TextStyle(
                                        fontSize: SizeConfig.regularFontSize,
                                        color: Colors.white,
                                        fontFamily: fontMedium),
                                    children: [
                                      TextSpan(text: controller.formatOrders(double.parse(controller.salesReport.value.thisMonthOrders ?? "0")),
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: SizeConfig.regularFontSize,
                                            color: Colors.white,
                                            fontFamily: fontSemiBold),
                                      ),
                                    ],

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                         SizedBox(
                           height: SizeConfig.blockSizeHorizontal * 29,
                           child: const VerticalDivider(
                            color:Colors.white60),
                         ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal*4,
                                top:SizeConfig.blockSizeHorizontal*3,
                                bottom: SizeConfig.blockSizeHorizontal*4),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(text: salesReportAllTime,
                                  fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                                  color: Colors.white,),
                                RichText(
                                  text: TextSpan(
                                    text: "$salesReportSales:  ",
                                    style: TextStyle(
                                        fontSize: SizeConfig.regularFontSize,
                                        color: Colors.white,
                                        fontFamily: fontMedium),
                                    children: [
                                      TextSpan(
                                          text: currSymbolIn,
                                          style: TextStyle(
                                              fontSize: SizeConfig.mediumFontSize,
                                              color: Colors.white,
                                              fontFamily: fontMedium) ),
                                      TextSpan(text:
                                      controller.salesReport.value.totalSales == "" ? controller.formatAmount(double.parse("0"))
                                      : controller.formatAmount(double.parse(controller.salesReport.value.totalSales ?? "0")),
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: SizeConfig.mediumFontSize,
                                            color: Colors.white,
                                            fontFamily: fontSemiBold),
                                      ),
                                    ],

                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                                RichText(
                                  text: TextSpan(
                                    text: "$salesReportOrders:  ",
                                    style: TextStyle(
                                        fontSize: SizeConfig.regularFontSize,
                                        color: Colors.white,
                                        fontFamily: fontMedium),
                                    children: [
                                      TextSpan(text: controller.formatOrders(double.parse(controller.salesReport.value.totalOrders ?? "0")),
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: SizeConfig.mediumFontSize,
                                            color: Colors.white,
                                            fontFamily: fontSemiBold),
                                      ),
                                    ],

                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )

                  ],
                ),

              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal*4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:  Icon(Icons.arrow_left,  size: SizeConfig.blockSizeHorizontal*8),
                    onPressed: () => controller.changeDate(-1),
                  ),

                  Flexible(
                    child: InkWell(
                      onTap: ()async{
                        await controller.datePicker(context);
                      },
                      child: TextWidget(
                        text: controller.showDate(controller.selectDate.value),
                        fontFamily: fontSemiBold,
                        fontSize: SizeConfig.mediumFontSize,
                      ),
                    ),
                  ),
                  IconButton(
                    icon:  Icon(Icons.arrow_right, size:  SizeConfig.blockSizeHorizontal*8),
                    onPressed: controller.selectDate.value.isBefore(controller.currentDate)
                    && !DateTimeUtils.utils.isCurrentDay(DateFormat('dd MMM, yyyy').format(controller.selectDate.value))
                        ? () => controller.changeDate(1)
                        : null,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal*3),
              Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                  width: Get.width,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(text: salesReportTodayOverview,
                      fontSize: SizeConfig.mediumFontSize,fontFamily: fontSemiBold,
                      color: Colors.black,),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                    const Divider(),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(text: salesReportSales,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                              color: blackShades)),
                        Expanded(
                          child: TextWidget(text: "$currSymbolIn${controller.salesReport.value.earning ?? '0'}",
                            fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                            textAlign: TextAlign.end,
                            color: Colors.black,),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*4),
                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(text: salesReportOrders,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                              color: blackShades),
                        ),
                        Expanded(
                          child: TextWidget(text: controller.formatAmountWithComma(double.parse(controller.salesReport.value.dateOrders ?? "0")),
                            fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium,
                            textAlign: TextAlign.end,
                            color: Colors.black,),
                        )
                      ],
                    ),





                  ],
                ),
              )


            ]
          ),
        ),





      )),
    ));




    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value || controller.paymentLoader.value
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