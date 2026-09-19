import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';

import 'customisationTypeController.dart';

class CustomisationTypeScreen extends GetView<CustomisationTypeController>{
  const CustomisationTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          controller.goBack();
        }

      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
            title: TextWidget(
              text: customisationTypeTitle,
              color: Colors.black,
              fontSize: SizeConfig.appbarTitleSize,
              fontFamily: FontFamily.fontSemiBold,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColors.white,
              statusBarIconBrightness: Brightness.dark,
            )),

        body:  SafeArea(
          child: Obx(()=> controller.initialLoad.value ?
          Center(
              child:  ColorLoader())
          
                 : Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeHorizontal * 2,
                bottom: SizeConfig.blockSizeHorizontal * 2,
                left: SizeConfig.blockSizeHorizontal * 4,
                right: SizeConfig.blockSizeHorizontal * 4),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // select customisation type
                    TextWidget(
                      text: customisationTypeTitle,
                      fontFamily: FontFamily.fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: AppColors.normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                   Container(
                      width: Get.width,
                      height: SizeConfig.blockSizeHorizontal * 13.8,
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2.5),
                      decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          border: Border.all(
                              color: AppColors.disabledBorderColor, width: 1.3),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(
                            10.0,
                          ))),
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: controller.customisationTitle.value,
                        maxLines: 1,
                        fontSize: SizeConfig.mediumFontSize,
                      ),
          
          
                      /*DropdownButtonFormField(
                           iconSize: 0.0,
                           isExpanded: true,
                           decoration: const InputDecoration(
                            hintText: "Select One",
                            isDense: true,
                            border: InputBorder.none,
                            focusedBorder:  InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                           */
                      /* suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorPrimary,
                            ),*/
                      /*
                          ),
                          value: controller.customisationType.value,
                          items: controller.customisationList.map<DropdownMenuItem>((e) {
                            return DropdownMenuItem(
                              value: e.title,
                              child: TextWidget(
                               text: "${e.title}",
                                maxLines: 3,
                              ),
                            );
                          }).toList(),
                          onChanged: null)*/
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
          
                    // customisation details
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: customisationDetails,
                            fontFamily: FontFamily.fontMedium,
                            fontSize: SizeConfig.mediumFontSize,
                            color: AppColors.normalTextColor,
                          ),
                        ),
          
                        Visibility(
                          visible: controller.customisationItemsList.length !=
                          controller.addRemainingList.length,
                          child: Flexible(
                            child: InkWell(
                              splashColor: AppColors.white,
                              highlightColor: AppColors.white,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.addRemainingItemsClick();
                              },
                              child:
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                      Icons.add,
                                      color: AppColors.colorPrimary),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                  TextWidget(text: "Add",
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: AppColors.colorPrimary),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                     ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.customisationItemsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical:  SizeConfig.blockSizeHorizontal * 3.8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container( width: Get.width,
                                    height: SizeConfig.blockSizeHorizontal * 13.8,
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal * 2.5),
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.blockSizeHorizontal * 2),
                                    decoration: BoxDecoration(
                                        color: AppColors.textFieldFillColor,
                                        border: Border.all(
                                            color: AppColors.disabledBorderColor, width: 1.3),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(
                                          10.0,
                                        ))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextWidget(text: "${controller.customisationItemsList[index].title}",
                                        maxLines: 1,overflow: TextOverflow.ellipsis,
                                        fontSize: SizeConfig.mediumFontSize,
                                        fontFamily: FontFamily.fontMedium),
                                      ),
                                      const VerticalDivider(),
                                      Flexible(
                                        child: CustomFormField(
                                          hintText: "₹ Price",
                                          controller: TextEditingController(text: "${controller.customisationItemsList[index].price}"),
                                          onChanged: (value){
                                            controller.customisationItemsList[index].price = value;
                                          },
                                          keyboardType: TextInputType.number,
                                          onlyNumbers: true,
                                          validator: Validations.validations.validateEmptyCustomisationFields,
                                          inputAction: TextInputAction.done,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          ),
                                      ),
          
          
                                    ]
                                  )),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.deleteCustomisationItem(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
          
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 11),
          
                  ButtonWidget(
                      text: customisationContinue,
                      onPressed: (){
                        controller.goBackToCustomisedProductScreen();
                      })
          
          
          
          
          
                  ]
                )
              )
            )
          )
          ),
        )),
    );



    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack(
        alignment: Alignment.center,
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