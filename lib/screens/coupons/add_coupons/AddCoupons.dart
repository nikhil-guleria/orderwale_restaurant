import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/TextFormFieldWidget.dart';
import 'package:food_merchant/component/TextWidget.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import 'add_coupons_controller.dart';


class AddCoupons extends GetView<AddCouponsController> {
  const AddCoupons({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: TextWidget(text:
          controller.couponsData != null  ?
          updateCouponTitle : addCouponTitle,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,),
          actions: [
            Visibility(
              visible: controller.couponsData != null,
              child: Padding(
                padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                child: IconButton(
                  onPressed: () {
                    controller.deleteCouponClick();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ]
      ),

      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeHorizontal * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image
                  Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9)
                        ),
                        height: SizeConfig.blockSizeHorizontal * 55,
                        width: Get.width,
                        child: Obx(()=>
                        controller.imageFile.value != null ?
                        ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.file(controller.imageFile.value!,
                                fit: BoxFit.cover))
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: CachedNetworkImage(
                              height: SizeConfig.blockSizeHorizontal * 55,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: controller.couponsData?.image ?? '' ,
                              placeholder: (context, url) => Image.asset(loadingGif, fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image.asset(appLogoTransparent),
                            )
                        )
                        )
                    ),


                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.25,
                          bottom: SizeConfig.blockSizeHorizontal*1.25),
                      decoration: BoxDecoration(
                          color: colorPrimary,
                          border: Border.all(color: colorWhite, width: 2.5),
                          borderRadius: const BorderRadius.all(Radius.circular(
                            10.0,
                          ))),
                      height: SizeConfig.blockSizeHorizontal * 10,
                      width: SizeConfig.blockSizeHorizontal * 10,
                      child: Center(
                        child: InkWell(
                            onTap: (){
                              controller.pickImage();
                             /* FocusManager.instance.primaryFocus?.unfocus();
                              Get.dialog(AlertDialog(
                                  backgroundColor: colorWhite,
                                  surfaceTintColor: colorWhite,
                                  title:  Text(
                                      "Select Image",textAlign: TextAlign.center,style: TextStyle(
                                    fontSize: SizeConfig.semiBoldFontSize,
                                    fontFamily: fontSemiBold,
                                  )),
                                  actionsPadding: const EdgeInsets.only(top: 0,bottom: 0),
                                  actions: [
                                    Center(
                                      child: MaterialButton(
                                          child:  Text(
                                            "Take Photo", style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                              fontFamily: fontMedium),),
                                          onPressed: (){
                                            Get.back(result: "Camera");
                                          }),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: ()  {
                                          Get.back(result: "Gallery");
                                        },
                                        child:  Text(
                                          "Choose From Library",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: fontMedium),),
                                      ),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: (){
                                          Get.back();},
                                        child:  Text(
                                            "Cancel",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: fontMedium)),
                                      ),
                                    ),
                                  ])).then((value) {
                                if(value == "Camera"){
                                  controller.getFromCamera();
                                } else if(value == "Gallery"){
                                  controller.getFromGallery();
                                }
                              });*/
                            },
                            child: Icon(
                              controller.couponsData  != null ?
                              Icons.edit : Icons.add,
                              color: colorWhite,
                              size: SizeConfig.blockSizeHorizontal * 6.2,
                            )),
                      ),
                    )]),
                  Obx(()=> Visibility(
                    visible: controller.showImageError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text("Please select image",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                          )),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 7),

                  // coupon code
                  TextWidget(
                    text: couponCode,
                    fontFamily: fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  TextFormWidget(
                    controller: controller.couponCodeController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [UpperCaseTextFormatter()],
                    validator: Validations.validations.validateCouponCode,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // description
                  TextWidget(
                    text: couponDescription,
                    fontFamily: fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  TextFormWidget(
                    controller: controller.descriptionController,
                    validator: Validations.validations.validateCouponDescription,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [CapitalizeEachWordFormatter()],
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // start & end date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // start date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: startDate,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              controller: controller.startDateController,
                              readOnly: true,
                              suffixIcon: Icon(Icons.date_range),
                              validator: Validations.validations.fieldCantEmpty,
                              onTap: () async {
                                await controller.startDatePicker(context);
                              },
                            ),
                            /*Container(
                                height: SizeConfig.blockSizeHorizontal * 13.8,
                                padding:
                                EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                                decoration: BoxDecoration(
                                    color: textFieldFillColor,
                                    border: Border.all(
                                        color: disabledBorderColor, width: 1.3),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(
                                      10.0,
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: TextWidget(
                                          text: controller.startDate.value,
                                        ),
                                      ),
                                    )),
                                    InkWell(
                                        onTap: () async {
                                          await controller.startDatePicker(context);
                                        },
                                        child: Icon(Icons.calendar_month,
                                            size: SizeConfig.semiBoldFontSize,
                                            color: colorPrimary)),
                                  ],
                                )),*/
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                      // end date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: endDate,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              controller: controller.endDateController,
                              readOnly: true,
                              validator: Validations.validations.fieldCantEmpty,
                              onTap: () async {
                                await controller.endDatePicker(context);
                              },
                              suffixIcon: Icon(Icons.date_range),
                            ),
                            /*Container(
                                height: SizeConfig.blockSizeHorizontal * 13.8,
                                padding:
                                EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                                decoration: BoxDecoration(
                                    color: textFieldFillColor,
                                    border: Border.all(
                                        color: disabledBorderColor, width: 1.3),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(
                                      10.0,
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: TextWidget(
                                          text: controller.endDate.value,
                                        ),
                                      ),
                                    )),
                                    InkWell(
                                        onTap: () async {
                                          await controller.endDatePicker(context);
                                        },
                                        child: Icon(Icons.calendar_month,
                                            size: SizeConfig.semiBoldFontSize,
                                            color: colorPrimary)),
                                  ],
                                )),*/
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // usage time & discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // usage time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: couponUsage,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              validator: Validations.validations.validateCoupon,
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              controller: controller.usageController,
                              inputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                      // discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: discountCoupon,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              validator: Validations.validations.fieldCantEmpty,
                              keyboardType:  TextInputType.number,
                              onlyNumbers: true,
                              controller: controller.discountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),


                  // discount type
                  TextWidget(
                    text: discountCouponType,
                    fontFamily: fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Obx(()=>  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: disabledBorderColor,
                            width: 1.0
                        )
                    ),
                    padding: const EdgeInsets.all(1),
                    child: RadioGroup(
                      groupValue: controller.discountType.value,
                      onChanged: (value) {
                        if(value != null){
                        controller.onChangeDiscountType(value);}
                      },
                      child: Row(
                        children: [
                          Flexible(
                            child: RadioListTile(
                                dense: true,
                                radioScaleFactor: 0.9,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                value: "0",
                                activeColor: colorPrimary,
                                title: TextWidget(text: radio_btn_flat, color: normalTextColor,)
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                                value: "1",
                                dense: true,
                                radioScaleFactor: 0.9,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                activeColor: colorPrimary,
                                title: TextWidget(text: radio_btn_percentage, color: normalTextColor,)
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  Obx(()=> Visibility(
                    visible: controller.showDiscountError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text("Please select discount type",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                          )),
                    ),
                  )),

                  /*Container(
                    width: Get.width,
                    height: SizeConfig.blockSizeHorizontal * 15.8,
                    decoration: BoxDecoration(
                        color: textFieldFillColor,
                        border:
                        Border.all(color: disabledBorderColor, width: 1.3),
                        borderRadius: const BorderRadius.all(Radius.circular(
                          10.0,
                        ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() =>
                            MyRadioListTile(
                              value: "0",
                              groupValue: controller.discountType.value,
                              onChanged: (value) {
                                controller.onChangeDiscountType(value!);
                              },
                              title: TextWidget(
                                text: radio_btn_flat,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
                              ),
                            ),
                        ),
                        Obx(() =>
                            MyRadioListTile(
                              value: "1",
                              groupValue: controller.discountType.value,
                              onChanged: (value) {
                                controller.onChangeDiscountType(value!);
                              },
                              title: TextWidget(
                                text: radio_btn_percentage,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Obx(()=> Visibility(
                    visible: controller.showDiscountError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text("Please select discount type",
                          style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12,
                          )),
                    ),
                  )),*/

                  SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),

                  // max & min discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // max discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: maxDiscount,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              validator: (value){
                                if(controller.discountType.trim() == "0" ||
                                    controller.discountType.trim().isEmpty ||
                                    (value ?? '').trim().isNotEmpty){
                                  return null;
                                }
                                return "Field can't be empty";
                              },
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              controller: controller.maxDiscountController,
                              inputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),

                      // min discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: minDiscount,
                              fontFamily: fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: normalTextColor,
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                            TextFormWidget(
                              validator: (value){
                                if(controller.discountType.trim() == "1" ||
                                    controller.discountType.trim().isEmpty ||
                                    (value ?? '').trim().isNotEmpty){
                                  return null;
                                }
                                return "Field can't be empty";
                              },
                              keyboardType:  TextInputType.number,
                              onlyNumbers: true,
                              controller: controller.minDiscountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),


                  SizedBox(height: SizeConfig.blockSizeHorizontal * 11),
                  ButtonWidget(
                    text:
                    controller.couponsData != null  ?
                    updateCoupon : addCoupon,
                    onPressed: controller.couponsData != null ?
                    controller.updateCouponClick : controller.addCouponClick
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),






                ],
              ),
            ),
          ),
        ),
      ),


    );
     /*Obx(() =>
   controller.initialLoad.value ?
       Container(
         color: Colors.white,
         child: Center(
           child: ColorLoader(),
         ),
       )

    : Scaffold(
       appBar:
       AppBar(
         elevation: 0.0,
       centerTitle: true,
       title:

       TextWidget(text:
       controller.updateCoupon.value ?  updateCouponTitle
              : addCouponTitle,
             color: Colors.black,
             fontSize: SizeConfig.appbarTitleSize,
             fontFamily: fontSemiBold,
             weight: FontWeight.w600,),
           actions: [
             Visibility(
               visible: controller.updateCoupon.value,
               child: Padding(
                 padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                 child: IconButton(
                   onPressed: () {
                    controller.deleteCouponValidations();
                   },
                   icon: const Icon(
                     Icons.delete,
                     color: Colors.red,
                   ),
                 ),
               ),
             )
           ]
       ),

   body: SafeArea(
     child: Container(
       height: SizeConfig.screenHeight,
       width: SizeConfig.screenWidth,
       padding: EdgeInsets.only(
           top: SizeConfig.blockSizeHorizontal * 2,
           bottom: SizeConfig.blockSizeHorizontal * 2,
           left: SizeConfig.blockSizeHorizontal * 4,
           right: SizeConfig.blockSizeHorizontal * 4),
       child: SingleChildScrollView(
         child: Form(key: controller.formKey,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Stack(alignment: Alignment.bottomRight, children: [
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(9)
                   ),
                     height: SizeConfig.blockSizeHorizontal * 55,
                     width: Get.width,
                     child: Obx(()=>
                     controller.imageFile.value != "" ?
                     ClipRRect(
                         borderRadius: BorderRadius.circular(9),
                         child: Image.file(File(controller.imageFile.value), fit: BoxFit.cover))
                         :

                     ClipRRect(
                         borderRadius: BorderRadius.circular(9),
                         child: CachedNetworkImage(
                           height: SizeConfig.blockSizeHorizontal * 55,
                           width: Get.width,
                           fit: BoxFit.cover,
                           imageUrl: controller.image.value ,
                           placeholder: (context, url) => Image.asset(loadingGif, fit: BoxFit.cover),
                           errorWidget: (context, url, error) => Image.asset(appLogoTransparent),
                         )
                     )
                     )
                 ),
                 Container(
                   margin:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.25,
                       bottom: SizeConfig.blockSizeHorizontal*1.25),
                   decoration: BoxDecoration(
                       color: colorPrimary,
                       border: Border.all(color: colorWhite, width: 2.5),
                       borderRadius: const BorderRadius.all(Radius.circular(
                         10.0,
                       ))),
                   height: SizeConfig.blockSizeHorizontal * 10,
                   width: SizeConfig.blockSizeHorizontal * 10,
                   child: Center(
                     child: InkWell(
                         onTap: (){
                           FocusManager.instance.primaryFocus?.unfocus();
                           Get.dialog(AlertDialog(
                             backgroundColor: colorWhite,
                               surfaceTintColor: colorWhite,
                               title:  Text(
                                   "Select Image",textAlign: TextAlign.center,style: TextStyle(
                                 fontSize: SizeConfig.semiBoldFontSize,
                                 fontFamily: fontSemiBold,
                               )),
                               actionsPadding: const EdgeInsets.only(top: 0,bottom: 0),
                               actions: [
                                 Center(
                                   child: MaterialButton(
                                       child:  Text(
                                         "Take Photo", style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                           fontFamily: fontMedium),),
                                       onPressed: (){
                                         Get.back(result: "Camera");
                                       }),
                                 ),
                                 Center(
                                   child: MaterialButton(
                                     onPressed: ()  {
                                       Get.back(result: "Gallery");
                                     },
                                     child:  Text(
                                       "Choose From Library",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                         fontFamily: fontMedium),),
                                   ),
                                 ),
                                 Center(
                                   child: MaterialButton(
                                     onPressed: (){
                                       Get.back();},
                                     child:  Text(
                                         "Cancel",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                         fontFamily: fontMedium)),
                                   ),
                                 ),
                               ])).then((value) {
                             if(value == "Camera"){
                               controller.getFromCamera();
                             } else if(value == "Gallery"){
                               controller.getFromGallery();
                             }
                           });
                         },


                        */
    /* onTap: () {
                           Get.dialog(AlertDialog(
                               title: TextWidget(
                                 text: select_image,
                                 fontFamily: fontMedium,
                                 fontSize: SizeConfig.mediumFontSize,
                                 color: colorPrimary,
                               ),
                               actions: [
                                 MaterialButton(
                                     child: TextWidget(
                                       text: from_gallery,
                                       fontFamily: fontRegular,
                                       fontSize:
                                       SizeConfig.regularFontSize,
                                       color: colorBlack,
                                     ),
                                     onPressed: () {
                                       controller.getFromGallery();
                                       Get.back();
                                     }),
                                 MaterialButton(
                                     child: TextWidget(
                                       text: from_camera,
                                       fontFamily: fontRegular,
                                       fontSize:
                                       SizeConfig.regularFontSize,
                                       color: colorBlack,
                                     ),
                                     onPressed: () {
                                       controller.getFromCamera();
                                       Get.back();
                                     })
                               ]));
                         },*/
    /*
                         child: Icon(
                           controller.image.value != "" ? Icons.edit
                          : Icons.add,
                           color: colorWhite,
                           size: SizeConfig.blockSizeHorizontal * 6.2,
                         )),
                   ),
                 )]),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
               ///  only selected restaurant coupons is added
               */
    /* Obx(() =>
               Container(
                 width: Get.width,
                 height: SizeConfig.blockSizeHorizontal * 15.8,
                 padding: const EdgeInsets.only(left: 10),
                 decoration: BoxDecoration(
                     color: textFieldFillColor,
                     border: Border.all(
                         color: disabledBorderColor, width: 2),
                     borderRadius:
                     const BorderRadius.all(Radius.circular(
                       10.0,
                     ))),
                 child: InkWell(
                   onTap: () async {
                     if (controller.restaurantList.isEmpty){
                       await controller.getRestaurantList();
                     }
                     if (context.mounted) {
                       showModalBottomSheet(
                           context: context,
                           shape: const RoundedRectangleBorder(
                             borderRadius: BorderRadius.vertical(
                               top: Radius.circular(25.0),
                             ),
                           ),
                           builder: (context) {
                             return Column(
                                 mainAxisAlignment:
                                 MainAxisAlignment.center,
                                 mainAxisSize: MainAxisSize.max,
                                 children: [
                                   Container(
                                       margin: const EdgeInsets.only(right: 20, left: 20), height: SizeConfig.blockSizeHorizontal * 11,
                                       child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             SizedBox(width: SizeConfig.semiBoldFontSize),
                                             TextWidget(text: selectRestaurantCoupons,
                                                 fontFamily:
                                                 fontMedium,
                                                 fontSize: SizeConfig
                                                     .mediumFontSize,
                                                 color:
                                                 normalTextColor),
                                             InkWell(
                                                 onTap: () {
                                                   Get.back();
                                                 },
                                                 child: Icon(
                                                   Icons
                                                       .close_rounded,
                                                   color:
                                                   colorPrimary,
                                                   size: SizeConfig
                                                       .boldFontSize,
                                                 )),
                                           ])),
                                   Expanded(
                                     child: ListView.builder(
                                         padding:
                                         const EdgeInsets
                                             .only(
                                             left: 12,
                                             right: 12),
                                         itemCount: controller.restaurantList.length,
                                         shrinkWrap: true,
                                         itemBuilder:
                                             (context, index) {
                                           return ListTile(
                                             onTap: () {
                                               controller.restaurantName.value = controller.restaurantList[index].name;
                                               controller.restaurantId.value = controller.restaurantList[index].id;
                                               Get.back();
                                             },
                                             title: Center(
                                               child: TextWidget(
                                                 text: controller.restaurantList[index].name,
                                               ),
                                             ),
                                           );
                                         }),
                                   )
                                 ]);
                           });
                     }
                   },
                   child: Row(
                     mainAxisAlignment:
                     MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         child: SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: TextWidget(
                             text: controller.restaurantName.value,
                           ),
                         ),
                       ),
                       Icon(
                         Icons.arrow_drop_down_outlined,
                         color: colorPrimary,
                         size: SizeConfig.boldFontSize,
                       )
                     ],
                   ),
                 ),
               ) ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),*/
    /*
               TextWidget(
                 text: couponCode,
                 fontFamily: fontMedium,
                 fontSize: SizeConfig.mediumFontSize,
                 color: normalTextColor,
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
               TextFormWidget(
                 controller: controller.couponCodeController,
                 textCapitalization: TextCapitalization.characters,
                 validator: Validations.validations.validateCouponCode,
                 inputAction: TextInputAction.next,
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),
               TextWidget(
                 text: couponDescription,
                 fontFamily: fontMedium,
                 fontSize: SizeConfig.mediumFontSize,
                 color: normalTextColor,
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
               TextFormWidget(
                 controller: controller.descriptionController,
                 validator: Validations.validations.validateCouponDescription,
                 textCapitalization: TextCapitalization.words,
                 inputAction: TextInputAction.next,
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         TextWidget(
                           text: startDate,
                           fontFamily: fontMedium,
                           fontSize: SizeConfig.mediumFontSize,
                           color: normalTextColor,
                         ),
                         SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                         Container(
                             height: SizeConfig.blockSizeHorizontal * 13.8,
                             padding:
                              EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                             decoration: BoxDecoration(
                                 color: textFieldFillColor,
                                 border: Border.all(
                                     color: disabledBorderColor, width: 1.3),
                                 borderRadius:
                                 const BorderRadius.all(Radius.circular(
                                   10.0,
                                 ))),
                             child: Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Obx(() => Expanded(
                                   child: SingleChildScrollView(
                                     scrollDirection: Axis.horizontal,
                                     child: TextWidget(
                                       text: controller.startDate.value,
                                     ),
                                   ),
                                 )),
                                 InkWell(
                                     onTap: () async {
                                       await controller.startDatePicker(context);
                                     },
                                     child: Icon(Icons.calendar_month,
                                         size: SizeConfig.semiBoldFontSize,
                                         color: colorPrimary)),
                               ],
                             )),
                       ],
                     ),
                   ),
                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         TextWidget(
                           text: endDate,
                           fontFamily: fontMedium,
                           fontSize: SizeConfig.mediumFontSize,
                           color: normalTextColor,
                         ),
                         SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                         Container(
                             height: SizeConfig.blockSizeHorizontal * 13.8,
                             padding:
                              EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                             decoration: BoxDecoration(
                                 color: textFieldFillColor,
                                 border: Border.all(
                                     color: disabledBorderColor, width: 1.3),
                                 borderRadius:
                                 const BorderRadius.all(Radius.circular(
                                   10.0,
                                 ))),
                             child: Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Obx(() => Expanded(
                                   child: SingleChildScrollView(
                                     scrollDirection: Axis.horizontal,
                                     child: TextWidget(
                                       text: controller.endDate.value,
                                     ),
                                   ),
                                 )),
                                 InkWell(
                                     onTap: () async {
                                       await controller.endDatePicker(context);
                                     },
                                     child: Icon(Icons.calendar_month,
                                         size: SizeConfig.semiBoldFontSize,
                                         color: colorPrimary)),
                               ],
                             )),
                       ],
                     ),
                   )
                 ],
               ),

               SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         TextWidget(
                           text: couponUsage,
                           fontFamily: fontMedium,
                           fontSize: SizeConfig.mediumFontSize,
                           color: normalTextColor,
                         ),
                         SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                         TextFormWidget(
                           validator: Validations.validations.validateCoupon,
                           onlyNumbers: true,
                           keyboardType: TextInputType.number,
                           controller: controller.usageController,
                           inputAction: TextInputAction.next,
                         ),
                       ],
                     ),
                   ),
                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         TextWidget(
                           text: discountCoupon,
                           fontFamily: fontMedium,
                           fontSize: SizeConfig.mediumFontSize,
                           color: normalTextColor,
                         ),
                         SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                         TextFormWidget(
                           validator: Validations.validations.validateEmptyFields,
                           keyboardType:  TextInputType.number,
                           onlyNumbers: true,
                           controller: controller.discountController,
                           inputAction: TextInputAction.done,
                         ),
                       ],
                     ),
                   )
                 ],
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 4.5),
               TextWidget(
                 text: discountCouponType,
                 fontFamily: fontMedium,
                 fontSize: SizeConfig.mediumFontSize,
                 color: normalTextColor,
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
               Container(
                 width: Get.width,
                 height: SizeConfig.blockSizeHorizontal * 15.8,
                 decoration: BoxDecoration(
                     color: textFieldFillColor,
                     border:
                     Border.all(color: disabledBorderColor, width: 1.3),
                     borderRadius: const BorderRadius.all(Radius.circular(
                       10.0,
                     ))),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Obx(() =>
                         MyRadioListTile(
                           value: "0",
                           groupValue: controller.discountType.value,
                           onChanged: (value) {
                             controller.onChangeDiscountType(value!);
                           },
                           title: TextWidget(
                             text: radio_btn_flat,
                             fontSize: SizeConfig.regularFontSize,
                             color: normalTextColor,
                           ),
                         ),
                     ),
                     Obx(() =>
                         MyRadioListTile(
                           value: "1",
                           groupValue: controller.discountType.value,
                           onChanged: (value) {
                             controller.onChangeDiscountType(value!);
                           },
                           title: TextWidget(
                             text: radio_btn_percentage,
                             fontSize: SizeConfig.regularFontSize,
                             color: normalTextColor,
                           ),
                         ),
                     ),
                   ],
                 ),
               ),
               Obx(()=> Visibility(
                 visible: controller.showDiscountError.value,
                 child: Padding(
                   padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                       top: SizeConfig.blockSizeHorizontal*1),
                   child: Text("Please select discount type",
                       style: TextStyle(
                         color: Colors.red.shade900, fontSize: 12,
                       )),
                 ),
               )),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 11),
                ButtonWidget(
                 text:
                 controller.updateCoupon.value ?  updateCoupon
               :  addCoupon,
                 onPressed: () {
                   controller.addUpdateClick();
                 },
               ),
               SizedBox(height: SizeConfig.blockSizeHorizontal * 5),






             ],
           ),
         ),
       ),
     ),
   ),


   )
     );*/


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