import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:get/get.dart';
import '../../../component/ColorLoader.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_strings.dart';
import '../../../utils/DateTimeUtils.dart';
import '../../../utils/SetUpOrdersData.dart';
import '../../../utils/size_config.dart';
import '../controller/orders_page_controller.dart';

class OrdersPageView extends GetView<OrdersPageController>{
  const OrdersPageView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: buildAppBar(title: AppStrings.ordersTitle),
        body: SafeArea(
          child: Obx(() =>
          PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _){
              if(didPop) {
                return ;
              } else {
                controller.getBack();
              }
            },
            child: RefreshIndicator(
                color: AppColors.colorPrimary,
                onRefresh: controller.pullRefresh,
            child: controller.initialLoad.value
            ? Center(child: ColorLoader())
            : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeHorizontal*0.75,
                  left: SizeConfig.blockSizeHorizontal*2.2,
                  right:  SizeConfig.blockSizeHorizontal*2.2),
                color: AppColors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Wrap(
                      spacing:  SizeConfig.blockSizeHorizontal*2.2,
                      children: controller.choicesStatus.map((choice) {
                        return Obx(() {
                          return Center(
                            child: ChoiceChip(
                              showCheckmark: false,
                              backgroundColor: AppColors.white,
                              padding: const EdgeInsets.all(0),
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(
                                color: AppColors.colorPrimary,
                                width: 1.5,
                              ),
                              label: Text(controller.getChipsTitle(choice),
                                style: TextStyle(
                                color: controller.colorChange.value == choice ?
                                    AppColors.white : AppColors.blackText
                              ),),
                              selectedColor: AppColors.colorPrimary,
                              labelStyle: TextStyle(color: AppColors.blackText,
                                  fontFamily: FontFamily.fontMedium,
                                  fontSize: SizeConfig.mediumFontSize),
                              selected: controller.selectedChoice.value == choice,
                              onSelected: (isSelected) {
                                if (isSelected) {
                                  controller.changeChipsClick(choice);
                                }
                              },
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                )),


                   Expanded(
                    child:
                    controller.orderList.isEmpty ?
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 6.25),
                        alignment: Alignment.center,
                        child: TextWidget(text: controller.showLoader.value  ||
                            controller.refreshLoad.value || controller.initialLoad.value
                            ? '' : AppStrings.ordersNoOrderFound,
                            color: AppColors.green,fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium),
                      ),
                    ) :

                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                              itemCount: controller.orderList.length,
                              scrollDirection: Axis.vertical,
                              controller: controller.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context , index) {
                              var order = controller.orderList[index];
                                return Card(
                                    elevation: 50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(onTap: () {
                                      controller.goToOrderDetails(index);
                                       },
                                        child: Container(
                                          padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2.75),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(15.0)
                                          ),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // order id
                                                  Expanded(flex:2,
                                                      child: TextWidget(
                                                    text: "#${order.orderId ?? 'N/A'}",
                                                    color: AppColors.blackShades,
                                                    fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                                    fontFamily: FontFamily.fontMedium,
                                                    fontWeight: FontWeight.bold,
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
                                                            text: "${DateTimeUtils.utils.extractDate(order.created ?? '')} at ${DateTimeUtils.utils.extractTime(order.created ?? '')}",
                                                            color: AppColors.blackShades,
                                                            fontSize: SizeConfig.blockSizeHorizontal*3.3,
                                                            fontFamily: FontFamily.fontMedium,
                                                          )
                                                      )
                                                    ],
                                                  ))],
                                              ),

                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*1),

                                              // delivery/pickup info
                                              RichText(
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child:  Icon(CupertinoIcons.location_solid, size: SizeConfig.blockSizeHorizontal*5, color: AppColors.colorPrimary,),
                                                        ),
                                                        TextSpan(
                                                            text: (order.deliveryType ?? '').trim() == "1"?
                                                            " ${order.deliveryAddress ?? ''}" : AppStrings.selfPickUp,
                                                            style: TextStyle(
                                                                color: AppColors.blackShades,
                                                                fontSize: SizeConfig.mediumFontSize,
                                                                fontFamily: FontFamily.fontMedium)
                                                        ),

                                                      ]
                                                  )),
                                               Divider(color: AppColors.grey.shade300),

                                              // payment status & total price
                                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // payment status
                                                  SizedBox(width : SizeConfig.blockSizeHorizontal*45,
                                                      child: Row(
                                                        children: [
                                                          Flexible(child:  TextWidget(text: AppStrings.ordersPayment,
                                                              fontSize: SizeConfig.mediumFontSize,color: AppColors.blackText,
                                                              fontFamily: FontFamily.fontMedium)),
                                                          (order.orderStatus ?? '').trim() == "5" ?
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
                                                          : (order.paymentType ?? '').trim() == "1" ?
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
                                                                  text:AppStrings.headingPaid,
                                                                  color: AppColors.green,
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
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Icon(Icons.currency_rupee,size: SizeConfig.mediumFontSize,color: AppColors.colorPrimary,),
                                                        Flexible(
                                                          child: TextWidget(text: controller.setItemsTotal(order.totalPrice, order.walletPrice),
                                                            fontSize: SizeConfig.mediumFontSize,color: AppColors.blackText,fontFamily: FontFamily.fontSemiBold,),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),

                                              SizedBox(height:  SizeConfig.blockSizeHorizontal*3),


                                              // order status
                                              Row(
                                                children: [
                                                TextWidget(text: AppStrings.ordersHeadingOrder,color: AppColors.blackText,
                                                    fontSize: SizeConfig.mediumFontSize,
                                                    fontFamily: FontFamily.fontMedium),
                                                SizedBox(height:  SizeConfig.blockSizeHorizontal*1),

                                                ShaderMask(
                                                    shaderCallback: (bounds) => SetUpOrdersData.stUP.setUpButtonColor(order.orderStatus ?? '').createShader(bounds),
                                                  child: TextWidget(text: SetUpOrdersData.stUP.setUpOrderStatus(order.orderStatus ?? ''),
                                                      color: AppColors.white,
                                                      fontSize: SizeConfig.mediumFontSize,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: FontFamily.fontMedium),
                                                ),
                                                 ],)

                                            ],
                                          ),
                                        )));
                              }),
                        ),

                        controller.showLoader.value ?
                        Center(child:
                        Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child:
                            TextWidget(text: AppStrings.headingLoading,
                              color: AppColors.loadingOrderColor, fontSize: SizeConfig.regularFontSize,
                            )),
                        ) : SizedBox()
                      ],
                    ),
                      ),

                // ),

              ],
            )
            ),
          ) ),
        ));

    widgetList.add(child);
    final modal = Obx(
          () => controller.refreshLoad.value
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