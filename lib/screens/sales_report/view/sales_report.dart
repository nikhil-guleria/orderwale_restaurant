import 'package:flutter/material.dart';
import 'package:food_merchant/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../component/color_loader.dart';
import '../../../component/dotted_line_separator.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_images.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/size_config.dart';
import '../controller/sales_report_controller.dart';

class SalesReport extends GetView<SalesReportController>{
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: AppColors.white,
        appBar: buildAppBar(title: AppStrings.salesReportTitle),
    body: SafeArea(
      child: Obx(() =>
      controller.initialLoad.value ?
      Center(child: TextWidget(text: AppStrings.headingPleaseWait,
          color: AppColors.colorPrimary,
          fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium))
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
                    controller.yOffset.value, -1.0)..scaleByDouble(controller.pageScale.value, controller.pageScale.value, controller.pageScale.value, 1.0),
                child: (double.tryParse(controller.salesReport.value.balance ?? '0') ?? 0) > 0 ?
                Visibility(
                    visible: controller.requestedBalance(controller.salesReport.value.balance ?? '0')
                        != "0" && controller.salesReport.value.withdrawalStatus != 1,
                    child: Material(
                      elevation: 2.2,
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
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
                                Image.asset(AppImages.paymentSettlement,
                                    height: SizeConfig.blockSizeHorizontal*6.5,
                                    width: SizeConfig.blockSizeHorizontal*6.5),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                Expanded(
                                  child: RichText(text: TextSpan(
                                      text: AppStrings.salesReportReminder,
                                      style: TextStyle(
                                        fontFamily: FontFamily.fontMedium,
                                          color: AppColors.redBackground,
                                          fontSize: SizeConfig.mediumFontSize,
                                        fontWeight: FontWeight.bold
                                      ),
                                      children: [
                                        TextSpan(
                                            text: AppStrings.salesReportRequest1,
                                            style: TextStyle(
                                                color: AppColors.blackShades,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: FontFamily.fontMedium,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),
                                        TextSpan(
                                            text: " ${AppStrings.currSymbolIn}${controller.salesReport.value.balance ?? "0"}",
                                            style: TextStyle(
                                                color: AppColors.colorPrimary,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: FontFamily.fontMedium,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        TextSpan(
                                            text: AppStrings.salesReportRequest2,
                                            style: TextStyle(
                                                color: AppColors.blackShades,
                                                fontSize: SizeConfig.regularFontSize,
                                                fontFamily: FontFamily.fontMedium,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),

                                      ])),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            highlightColor: AppColors.white,
                            splashColor: AppColors.white,
                            onTap: (){
                              controller.requestApiClick();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.colorPrimary
                              ),
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,
                                  vertical: SizeConfig.blockSizeHorizontal*1),
                              margin: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 2.5,
                                  bottom: SizeConfig.blockSizeHorizontal * 3.5),
                              child: TextWidget(text: AppStrings.salesReportRequestNow,
                                  fontSize: SizeConfig.regularFontSize,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
                      )
                    ))
              :  Visibility(
                  visible: controller.previousBalance(controller.salesReport.value.balance)
                  != "0",
                  child: Material(
                    elevation: 2.2,
                    color: AppColors.white,
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
                              Image.asset(AppImages.paymentSettlement,
                              height: SizeConfig.blockSizeHorizontal*6.5,
                              width: SizeConfig.blockSizeHorizontal*6.5),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                              Expanded(
                                child: RichText(text: TextSpan(
                                    text: AppStrings.salesReportReminder,
                                    style: TextStyle(
                                        fontFamily: FontFamily.fontMedium,
                                        color: AppColors.redBackground,
                                        fontSize: SizeConfig.mediumFontSize,
                                        fontWeight: FontWeight.bold
                                    ),

                                children: [
                                  TextSpan(
                                    text: AppStrings.salesReportClearYour,
                                      style: TextStyle(
                                          fontFamily: FontFamily.fontMedium,
                                          color: AppColors.blackShades,
                                          fontSize: SizeConfig.regularFontSize,
                                          fontWeight: FontWeight.normal
                                      ),
                                  ),
                                  TextSpan(
                                      text: "${AppStrings.currSymbolIn}${controller.previousBalance(controller.salesReport.value.balance)}",
                                      style: TextStyle(
                                          fontFamily: FontFamily.fontMedium,
                                          color: AppColors.colorPrimary,
                                          fontSize: SizeConfig.regularFontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                  ),


                                ])),
                              ),
                            ],
                          ),
                        ),

                        // cash free payment methods
                        Obx(() =>   Visibility(
                            visible: controller.isCashFree.value ,
                            child: RadioGroup(
                              groupValue: controller.paymentOptionValue.value,
                              onChanged: (value) {
                                if(value != null){
                                controller.paymentOptionValue.value = value;}
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),

                                  // upi - cash free
                                  RadioListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: TextWidget(text: AppStrings.salesReportUpi,
                                                  fontSize: SizeConfig.regularFontSize)),
                                          Image.asset(AppImages.cashFreeUpi,
                                            width: SizeConfig.blockSizeHorizontal*6,
                                            height:  SizeConfig.blockSizeHorizontal*6,
                                            fit: BoxFit.cover,
                                          )
                                        ],
                                      ),
                                      value: 1,
                                      activeColor: AppColors.colorPrimary,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.blockSizeHorizontal * 2),
                                    child: const DottedLineSeparator(color: AppColors.disabledBorderColor,dashWidth: 3, height: 0.7),
                                  ),


                                  // card - cash free
                                  RadioListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: TextWidget(text: AppStrings.salesReportCard,
                                                  fontSize: SizeConfig.regularFontSize)),
                                          Image.asset(AppImages.cashFreeCard,
                                            width: SizeConfig.blockSizeHorizontal*6,
                                            height:  SizeConfig.blockSizeHorizontal*6,
                                            fit: BoxFit.cover,
                                          )
                                        ],
                                      ),
                                      value: 2,
                                      activeColor: AppColors.colorPrimary,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.blockSizeHorizontal * 2),
                                    child: const DottedLineSeparator(color: AppColors.disabledBorderColor,dashWidth: 3, height: 0.7),
                                  ),


                                 // net banking - cash free
                                  RadioListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: TextWidget(text: AppStrings.salesReportNetBanking,
                                                  fontSize: SizeConfig.regularFontSize)),
                                          Image.asset(AppImages.cashFreeNetBanking,
                                            width: SizeConfig.blockSizeHorizontal*6,
                                            height: SizeConfig.blockSizeHorizontal*6,
                                            fit: BoxFit.cover,
                                          )
                                        ],
                                      ),
                                      value: 3,
                                      activeColor: AppColors.colorPrimary),
                                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                ],
                              ),
                            ))),


                        // pay now button
                        InkWell(
                          highlightColor: AppColors.white,
                          splashColor: AppColors.white,
                          onTap: (){
                            controller.payNowBtnClick();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.colorPrimary
                            ),
                            padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal*2,
                            vertical: SizeConfig.blockSizeHorizontal*1),
                            margin: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 2.5,
                                bottom: SizeConfig.blockSizeHorizontal * 3.5),
                            child: TextWidget(text: AppStrings.salesReportPayNow,
                            fontSize: SizeConfig.regularFontSize,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),


              // balance, monthly, total sales & orders
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.deepPurple
                ),
                child: Column(
                  children: [
                    // account balance
                    Container(
                      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                      width: Get.width,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(text: AppStrings.salesReportAccountBalance,
                          fontSize: SizeConfig.regularFontSize,fontFamily: FontFamily.fontMedium,
                          color: AppColors.white),

                          TextWidget(text:"${AppStrings.currSymbolIn}${controller.salesReport.value.balance ?? '0'}",
                              letterSpacing: 0.5,
                              fontSize: SizeConfig.semiBoldFontSize,
                              color: (double.tryParse(controller.salesReport.value.balance ?? "0") ?? 0) >= 0 ?
                              AppColors.lightGreenAccent : AppColors.redColorAmount,
                              fontFamily: FontFamily.fontSemiBold),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.white60,height: 0.0,
                    ),

                    // monthly and total sales & orders
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // this month
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal*4,
                                  top:SizeConfig.blockSizeHorizontal*3,
                              bottom: SizeConfig.blockSizeHorizontal*4),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(text: AppStrings.salesReportThisMonth,
                                    fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                                    color: AppColors.white,),
                                  // sales
                                  RichText(
                                    text: TextSpan(
                                      text: "${AppStrings.salesReportSales}:  ",
                                        style: TextStyle(
                                            fontSize: SizeConfig.regularFontSize,
                                            color: AppColors.white,
                                            fontFamily: FontFamily.fontMedium),
                                      children: [
                                        TextSpan(
                                            text: AppStrings.currSymbolIn,
                                            style: TextStyle(
                                                fontSize: SizeConfig.mediumFontSize,
                                                color: AppColors.white,
                                                fontFamily: FontFamily.fontMedium) ),
                                        TextSpan(text:
                                         controller.formatAmount(double.tryParse(controller.salesReport.value.thisMonthSales ?? "0") ?? 0),
                                          style: TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: SizeConfig.mediumFontSize,
                                              color: AppColors.white,
                                              fontFamily: FontFamily.fontSemiBold),
                                        ),
                                      ],
                      
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeHorizontal*1),

                                  // orders
                                  RichText(
                                    text: TextSpan(
                                      text: "${AppStrings.salesReportOrders}:  ",
                                      style: TextStyle(
                                          fontSize: SizeConfig.regularFontSize,
                                          color: AppColors.white,
                                          fontFamily: FontFamily.fontMedium),
                                      children: [
                                        TextSpan(text: controller.formatOrders(double.tryParse(controller.salesReport.value.thisMonthOrders ?? "0") ?? 0),
                                          style: TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: SizeConfig.regularFontSize,
                                              color: AppColors.white,
                                              fontFamily: FontFamily.fontSemiBold),
                                        ),
                                      ],
                      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                           const VerticalDivider(
                            color:AppColors.white60),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal*4,
                                  top:SizeConfig.blockSizeHorizontal*3,
                                  bottom: SizeConfig.blockSizeHorizontal*4),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(text: AppStrings.salesReportAllTime,
                                    fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                                    color: AppColors.white,),

                                  // sales
                                  RichText(
                                    text: TextSpan(
                                      text: "${AppStrings.salesReportSales}:  ",
                                      style: TextStyle(
                                          fontSize: SizeConfig.regularFontSize,
                                          color: AppColors.white,
                                          fontFamily: FontFamily.fontMedium),
                                      children: [
                                        TextSpan(
                                            text: AppStrings.currSymbolIn,
                                            style: TextStyle(
                                                fontSize: SizeConfig.mediumFontSize,
                                                color: AppColors.white,
                                                fontFamily: FontFamily.fontMedium) ),
                                        TextSpan(text:
                                       controller.formatAmount(double.tryParse(controller.salesReport.value.totalSales ?? "0") ?? 0),
                                          style: TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: SizeConfig.mediumFontSize,
                                              color: AppColors.white,
                                              fontFamily: FontFamily.fontSemiBold),
                                        ),
                                      ],
                      
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeHorizontal*1),

                                  // orders
                                  RichText(
                                    text: TextSpan(
                                      text: "${AppStrings.salesReportOrders}:  ",
                                      style: TextStyle(
                                          fontSize: SizeConfig.regularFontSize,
                                          color: AppColors.white,
                                          fontFamily: FontFamily.fontMedium),
                                      children: [
                                        TextSpan(text: controller.formatOrders(double.tryParse(controller.salesReport.value.totalOrders ?? "0") ?? 0),
                                          style: TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: SizeConfig.mediumFontSize,
                                              color: AppColors.white,
                                              fontFamily: FontFamily.fontSemiBold),
                                        ),
                                      ],
                      
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),

              ),
              SizedBox(height: SizeConfig.blockSizeHorizontal*4),


              // select date
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
                        fontFamily: FontFamily.fontSemiBold,
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


              // selected date sales & orders
              Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                  width: Get.width,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(text: AppStrings.salesReportTodayOverview,
                      fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontSemiBold,
                      color: AppColors.black,),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                    const Divider(),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*2),

                    // date sales
                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(text: AppStrings.salesReportSales,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                              color: AppColors.blackShades)),
                        Expanded(
                          child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.salesReport.value.earning ?? '0'}",
                            fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                            textAlign: TextAlign.end,
                            color: AppColors.black,),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal*4),

                    // date orders
                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(text: AppStrings.salesReportOrders,
                              fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                              color: AppColors.blackShades),
                        ),
                        Expanded(
                          child: TextWidget(text: controller.formatOrders(double.tryParse(controller.salesReport.value.dateOrders ?? "0") ?? 0),
                            fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium,
                            textAlign: TextAlign.end,
                            color: AppColors.black,),
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