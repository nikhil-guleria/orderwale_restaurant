import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/CustomRadioButton.dart';
import 'package:food_merchant/component/DottedLine.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import 'addCustomisedProductController.dart';

class AddCustomisedProduct extends GetView<AddCustomisedProductController> {
  const AddCustomisedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          title:
          TextWidget(
            text: controller.args != null ?
            customisedUpdateProduct
           : customisedProductTitle,
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
          ),
          actions: [
            Visibility(
              visible: controller.args != null,
              child: Padding(
                padding:  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
                child: IconButton(
                  onPressed: () {
                    controller.deleteProduct();
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

      body:  SafeArea(
        child: Obx(()=> controller.initialLoad.value ?
            Center(
              child: ColorLoader()
            )
        
        
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // select item image
                  Stack(alignment: Alignment.bottomRight, children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9)),
                        height: SizeConfig.blockSizeHorizontal * 55,
                        width: Get.width,
                        child: Obx(() => controller.imageFile.value != ""
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.file(
                              File(controller.imageFile.value),
                              fit: BoxFit.cover))
        
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: CachedNetworkImage(
                              height: SizeConfig.blockSizeHorizontal * 55,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: controller.image.value ,
                              placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image.asset(AppImages.errorImg, fit: BoxFit.cover),
                            )
                        )
        
        
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 1.25,
                          bottom: SizeConfig.blockSizeHorizontal * 1.25),
                      decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          border: Border.all(color: AppColors.white, width: 2.5),
                          borderRadius: const BorderRadius.all(Radius.circular(
                            10.0,
                          ))),
                      height: SizeConfig.blockSizeHorizontal * 10,
                      width: SizeConfig.blockSizeHorizontal * 10,
                      child: Center(
                        child: InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.dialog(AlertDialog(
                                  surfaceTintColor: AppColors.white,
                                  backgroundColor: AppColors.white,
                                  title: Text("Select Image",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: SizeConfig.semiBoldFontSize,
                                        fontFamily: FontFamily.fontSemiBold,
                                      )),
                                  actionsPadding:
                                  const EdgeInsets.only(top: 0, bottom: 0),
                                  actions: [
                                    Center(
                                      child: MaterialButton(
                                          child: Text(
                                            "Take Photo",
                                            style: TextStyle(
                                                fontSize:
                                                SizeConfig.mediumFontSize,
                                                fontFamily: FontFamily.fontMedium),
                                          ),
                                          onPressed: () {
                                            Get.back(result: "Camera");
                                          }),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Get.back(result: "Gallery");
                                        },
                                        child: Text(
                                          "Choose From Library",
                                          style: TextStyle(
                                              fontSize:
                                              SizeConfig.mediumFontSize,
                                              fontFamily: FontFamily.fontMedium),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                fontSize:
                                                SizeConfig.mediumFontSize,
                                                fontFamily: FontFamily.fontMedium)),
                                      ),
                                    ),
                                  ])).then((value) {
                                if (value == "Camera") {
                                  controller.getFromCamera();
                                } else if (value == "Gallery") {
                                  controller.getFromGallery();
                                }
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: SizeConfig.blockSizeHorizontal * 6.2,
                            )),
                      ),
                    )
                  ]),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
        
                  // select item category
                  TextWidget(
                    text: customisedProductCategories,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Obx(() => Container(
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
                    child: InkWell(
                      onTap: () async {
                        if (controller.categoriesList.isEmpty) {
                          await controller.getCategories();
                        }
                        if (context.mounted) {
                          showCustomBottomSheet(
                              context: context,
                              title: select_category,
                              childWidget: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                      SizeConfig.blockSizeHorizontal *
                                          3),
                                  itemCount:
                                  controller.categoriesList.length,
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Material(
                                      color: AppColors.transparent,
                                      child: ListTile(
                                        onTap: () {
                                          if (controller.categoryId.value ==
                                              controller.categoriesList[index]
                                                  .categoryId!) {
                                            Get.back();
                                          } else {
                                            controller.category.value =
                                            controller
                                                .categoriesList[index]
                                                .categoryName!;
                                            controller.categoryId.value =
                                            controller
                                                .categoriesList[index]
                                                .categoryId!;
                                            controller.subCategoryList
                                                .clear();
                                            controller.subCategoryTitle
                                                .value = "Select Menu Title";
                                            controller.subcategoryId.value =
                                            "0";
                                            Get.back();
                                          }
                                        },
                                        title: Center(
                                          child: TextWidget(
                                            text: controller
                                                .categoriesList[index]
                                                .categoryName ?? '',
                                            color: AppColors.blackShades,
                                            fontSize:
                                            SizeConfig.mediumFontSize,
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: TextWidget(
                                  text: controller.category.value,
                                  color: controller.category.value ==
                                      "Select Category"
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 1),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorPrimary,
                              size: SizeConfig.boldFontSize,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  // select item sub category
                  TextWidget(
                    text: customisedProductMenu,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Obx(() => Container(
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
                    child: InkWell(
                      onTap: () async {
                        if (controller.categoryId.value != "0") {
                          if (controller.subCategoryList.isEmpty) {
                            await controller.getSubCategories();
                          }
                          if (context.mounted) {
                            showModalBottomSheet(
                                useSafeArea: true,
                                backgroundColor: AppColors.white,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                            height: SizeConfig
                                                .blockSizeHorizontal *
                                                3),
                                        Container(
                                          height: 3,
                                          width:
                                          SizeConfig.blockSizeHorizontal *
                                              15,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius
                                                  .circular(SizeConfig
                                                  .blockSizeHorizontal *
                                                  1)),
                                        ),
                                        SizedBox(
                                            height: SizeConfig
                                                .blockSizeHorizontal *
                                                4),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .blockSizeHorizontal *
                                                  4),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              TextWidget(
                                                text: select_menu,
                                                fontFamily: FontFamily.fontMedium,
                                                fontSize:
                                                SizeConfig.mediumFontSize,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Obx(() => Visibility(
                                                visible: controller
                                                    .subCategoryList
                                                    .isNotEmpty,
                                                child: InkWell(
                                                    onTap: () {
                                                      Get.back(
                                                          result:
                                                          "editMenu");
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: AppColors.colorPrimary,
                                                      size: SizeConfig
                                                          .semiBoldFontSize,
                                                    )),
                                              ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: SizeConfig
                                                .blockSizeHorizontal *
                                                2),
                                        Expanded(
                                            child: SingleChildScrollView(
                                              child:
                                              controller
                                                  .subCategoryList.isEmpty
                                                  ? InkWell(
                                                onTap: () {
                                                  Get.back(
                                                      result:
                                                      "createMenu");
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: Get.height /
                                                          5,
                                                      right: SizeConfig
                                                          .blockSizeHorizontal *
                                                          2.5,
                                                      left: SizeConfig
                                                          .blockSizeHorizontal *
                                                          2.5),
                                                  padding: EdgeInsets
                                                      .all(SizeConfig
                                                      .blockSizeHorizontal *
                                                      3.75),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                          AppColors.colorPrimary,
                                                          width: 1.5),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          5)),
                                                  child: Center(
                                                    child: TextWidget(
                                                      text:
                                                      "Create Menu",
                                                      color:
                                                      AppColors.colorPrimary,
                                                      fontSize: SizeConfig
                                                          .mediumFontSize,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : Container(
                                                margin: EdgeInsets.all(
                                                    SizeConfig
                                                        .blockSizeHorizontal *
                                                        1.75),
                                                decoration:
                                                const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        width: 1.5,
                                                        color: Colors
                                                            .grey, // Color of the top border
                                                      ),
                                                      right: BorderSide(
                                                        width: 1.5,
                                                        color: Colors
                                                            .grey, // Color of the left border
                                                      ),
                                                    )),
                                                child: GridView.builder(
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio:
                                                      3,
                                                    ),
                                                    itemCount: controller
                                                        .subCategoryList
                                                        .length
                                                        .isOdd
                                                        ? controller
                                                        .subCategoryList
                                                        .length +
                                                        1
                                                        : controller
                                                        .subCategoryList
                                                        .length +
                                                        2,
                                                    itemBuilder:
                                                        (BuildContext
                                                    context,
                                                        int index) {
                                                      if (controller
                                                          .subCategoryList
                                                          .length
                                                          .isOdd) {
                                                        if (index <
                                                            controller
                                                                .subCategoryList
                                                                .length) {
                                                          return InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .subCategoryTitle
                                                                  .value =
                                                              controller
                                                                  .subCategoryList[index]
                                                                  .title!;
                                                              controller
                                                                  .subcategoryId
                                                                  .value = "${controller.subCategoryList[index].subcategoryId}";
                                                              Get.back();
                                                            },
                                                            child:
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: SizeConfig.blockSizeHorizontal *
                                                                      1.75,
                                                                  vertical:
                                                                  SizeConfig.blockSizeHorizontal * 0.75),
                                                              decoration:
                                                              const BoxDecoration(
                                                                  border: Border(
                                                                    top:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the top border
                                                                    ),
                                                                    left:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the left border
                                                                    ),
                                                                  )),
                                                              child: Center(
                                                                  child: TextWidget(
                                                                    text: controller
                                                                        .subCategoryList[index]
                                                                        .title ?? '',
                                                                    color:
                                                                    AppColors.blackShades,
                                                                    fontSize:
                                                                    SizeConfig.mediumFontSize,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                    maxLines:
                                                                    2,
                                                                  )),
                                                            ),
                                                          );
                                                        } else {
                                                          return InkWell(
                                                            onTap: () {
                                                              Get.back(
                                                                  result:
                                                                  "createMenu");
                                                            },
                                                            child:
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: SizeConfig.blockSizeHorizontal *
                                                                      1.75,
                                                                  vertical:
                                                                  SizeConfig.blockSizeHorizontal * 0.75),
                                                              decoration:
                                                              const BoxDecoration(
                                                                  border: Border(
                                                                    top:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the top border
                                                                    ),
                                                                    left:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the left border
                                                                    ),
                                                                  )),
                                                              child: Center(
                                                                  child: TextWidget(
                                                                    text:
                                                                    "Add New",
                                                                    color:
                                                                    AppColors.colorPrimary,
                                                                    fontSize:
                                                                    SizeConfig.mediumFontSize,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                    maxLines:
                                                                    2,
                                                                  )),
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        if (index <
                                                            controller
                                                                .subCategoryList
                                                                .length) {
                                                          return InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .subCategoryTitle
                                                                  .value =
                                                              controller
                                                                  .subCategoryList[index]
                                                                  .title!;
                                                              controller
                                                                  .subcategoryId
                                                                  .value = "${controller.subCategoryList[index].subcategoryId}";
                                                              Get.back();
                                                            },
                                                            child:
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: SizeConfig.blockSizeHorizontal *
                                                                      1.75,
                                                                  vertical:
                                                                  SizeConfig.blockSizeHorizontal * 0.75),
                                                              decoration:
                                                              const BoxDecoration(
                                                                  border: Border(
                                                                    top:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the top border
                                                                    ),
                                                                    left:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the left border
                                                                    ),
                                                                  )),
                                                              child: Center(
                                                                  child: TextWidget(
                                                                    text: controller
                                                                        .subCategoryList[index]
                                                                        .title ?? '',
                                                                    color:
                                                                    AppColors.blackShades,
                                                                    fontSize:
                                                                    SizeConfig.mediumFontSize,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                    maxLines:
                                                                    2,
                                                                  )),
                                                            ),
                                                          );
                                                        } else {
                                                          if (index ==
                                                              controller
                                                                  .subCategoryList
                                                                  .length) {
                                                            return InkWell(
                                                              onTap:
                                                                  () {
                                                                Get.back(
                                                                    result:
                                                                    "createMenu");
                                                              },
                                                              child:
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: SizeConfig.blockSizeHorizontal *
                                                                        1.75,
                                                                    vertical:
                                                                    SizeConfig.blockSizeHorizontal * 0.75),
                                                                decoration:
                                                                const BoxDecoration(
                                                                    border: Border(
                                                                      top:
                                                                      BorderSide(
                                                                        width:
                                                                        1.5,
                                                                        color:
                                                                        Colors.grey, // Color of the top border
                                                                      ),
                                                                      left:
                                                                      BorderSide(
                                                                        width:
                                                                        1.5,
                                                                        color:
                                                                        Colors.grey, // Color of the left border
                                                                      ),
                                                                    )),
                                                                child: Center(
                                                                    child: TextWidget(
                                                                      text:
                                                                      "Add New",
                                                                      color:
                                                                      AppColors.colorPrimary,
                                                                      fontSize:
                                                                      SizeConfig.mediumFontSize,
                                                                      overflow:
                                                                      TextOverflow.ellipsis,
                                                                      maxLines:
                                                                      2,
                                                                    )),
                                                              ),
                                                            );
                                                          } else {
                                                            return Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: SizeConfig.blockSizeHorizontal *
                                                                      1.75,
                                                                  vertical:
                                                                  SizeConfig.blockSizeHorizontal * 0.75),
                                                              decoration:
                                                              const BoxDecoration(
                                                                  border: Border(
                                                                    top:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the top border
                                                                    ),
                                                                    left:
                                                                    BorderSide(
                                                                      width:
                                                                      1.5,
                                                                      color:
                                                                      Colors.grey, // Color of the left border
                                                                    ),
                                                                  )),
                                                              child: Center(
                                                                  child: TextWidget(
                                                                    text:
                                                                    "",
                                                                    color:
                                                                    AppColors.colorPrimary,
                                                                    fontSize:
                                                                    SizeConfig.mediumFontSize,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                    maxLines:
                                                                    2,
                                                                  )),
                                                            );
                                                          }
                                                        }
                                                      }
                                                    }),
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                }).then((value) {
                              if (value == "createMenu") {
                                controller.addMenuTap();
                              }
                              else if (value == "editMenu") {
                                controller.editSubCategoryTap();
                              }
                            });
                          }
                        } else {
                          Get.snackbar(AppStrings.alertTitle, "Please Select Category",duration: const Duration(seconds: 2));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: TextWidget(
                                  text: controller.subCategoryTitle.value,
                                  color:
                                  controller.subCategoryTitle.value ==
                                      "Select Menu Title"
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 1),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorPrimary,
                              size: SizeConfig.boldFontSize,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
        
                  //  item name
                  TextWidget(
                    text: customisedProductName,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  CustomFormField(
                    hintText: add_product_name_hint,
                    controller: controller.productNameController,
                    textCapitalization: TextCapitalization.words,
                    validator: Validations.validations.validateEmptyFields,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  //  item description
                  TextWidget(
                    text: customisedProductDescription,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  CustomFormField(
                    hintText: item_descp_hint,
                    controller: controller.itemDescriptionController,
                    validator: Validations.validations.validateEmptyFields,
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  // add customization
               Obx(() =>    Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: customisedProductCustomisation,
                          fontFamily: FontFamily.fontMedium,
                          fontSize: SizeConfig.mediumFontSize,
                          color: AppColors.normalTextColor,
                        ),
                      ),
        
                      Flexible(
                        child: InkWell(
                          splashColor: AppColors.white,
                          highlightColor: AppColors.white,
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if(controller.customisationItemsList.isNotEmpty){
                              controller.editCustomisationItems();
                            } else {
                              if (context.mounted) {
                                showCustomBottomSheet(
                                    context: context,
                                    title: selectCustomisationType,
                                    childWidget: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            SizeConfig.blockSizeHorizontal *
                                                3),
                                        itemCount:
                                        controller.customisationList.length + 1,
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if (index !=
                                              controller.customisationList
                                                  .length) {
                                            return
                                              Obx(() =>
                                                  Column(
                                                    children: [
                                                      RadioListTile(
                                                          dense: true,
                                                          contentPadding: EdgeInsets
                                                              .zero,
                                                          title: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              TextWidget(
                                                                  text: controller
                                                                      .customisationList[index]
                                                                      .title ?? '',
                                                                  fontSize: SizeConfig
                                                                      .mediumFontSize,
                                                                  color: AppColors.blackText),
                                                              TextWidget(
                                                                  text: controller
                                                                      .customisationList[index]
                                                                      .subTitle ?? '',
                                                                  fontSize: SizeConfig
                                                                      .regularFontSize,
                                                                  fontFamily: FontFamily.fontRegular,
                                                                  color: AppColors.blackText),
                                                            ],
                                                          ),
                                                          value: controller
                                                              .customisationList[index]
                                                              .title,
                                                          activeColor: AppColors.colorPrimary,
                                                          groupValue: controller.customisationType.value,
                                                          onChanged: (value) {
                                                            controller.changeCustomisationType(value.toString());
                                                          }),
                                                      SizedBox(height: SizeConfig
                                                          .blockSizeHorizontal *
                                                          2),
                                                      const MySeparator(
                                                          color: AppColors.disabledBorderColor,
                                                          dashWidth: 3,
                                                          height: 0.7),
                                                    ],
                                                  ));
                                          }
                                          else {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig
                                                      .blockSizeHorizontal * 3),
                                              child: ButtonWidget(
                                                  text: customisationContinue,
                                                  onPressed: () {
                                                    controller
                                                        .goToCustomisationScreen();
                                                  }),
                                            );
                                          }
                                        }));
                              }
                            }
        
        
                          },
                          child: controller.customisationItemsList.isNotEmpty ?
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                  Icons.edit,
                                  color: AppColors.colorPrimary),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                              TextWidget(text: "Edit",
                                  fontSize: SizeConfig.mediumFontSize,
                                  color: AppColors.colorPrimary),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                            ],
                          )
                        :  Row(mainAxisAlignment: MainAxisAlignment.end,
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
                      )
                    ],
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
        
                  Obx(()=> Visibility(
                    visible: controller.customisationItemsList.isNotEmpty,
                    child: Row(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: TextWidget(
                                    text: controller.customisationTitle.value,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*3),
                            IconButton(onPressed: (){
                              controller.clearCustomisationItemList();
                            },
                            icon: const Icon(
                                Icons.delete,
                                color: Colors.red))
        
                          ],
                        ),
                  )),
                  Obx(() =>
                      Visibility(
                        visible: controller.customisationItemsList.isNotEmpty,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.customisationItemsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical:  SizeConfig.blockSizeHorizontal * 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextWidget(text: "${controller.customisationItemsList[index].title}",
                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                            fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: FontFamily.fontMedium),
                                      ),
                                      Expanded(
                                        child: TextWidget(text: "${AppStrings.currSymbolIn}${controller.customisationItemsList[index].price}",
                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                            fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: FontFamily.fontMedium),
                                      ),
                                    ]
                                ),
                              );
                            }
                        ),
                      )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  // add toppings
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:2,
                        child: TextWidget(
                          text: customisedProductAddToppings,
                          fontFamily: FontFamily.fontMedium,
                          fontSize: SizeConfig.mediumFontSize,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                      Flexible(
                        flex: 3,
                        child:
                        InkWell(
                          splashColor: AppColors.white,
                          highlightColor: AppColors.white,
                          onTap: () async {
                            if (controller.toppingsList.isEmpty) {
                              controller.showLoader.value = true;
                              await controller.getToppingsList();
                            }
                            if (context.mounted) {
                              showModalBottomSheet(
                                  useSafeArea: true,
                                  context: context,
                                  backgroundColor: AppColors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
                                          Container(
                                            height:3,
                                            width: SizeConfig.blockSizeHorizontal*15,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1)
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4,
                                            vertical: SizeConfig.blockSizeHorizontal * 4),
                                            color: AppColors.colorGrey1,
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: TextWidget(text: selectTopping,
                                                    fontFamily: FontFamily.fontMedium,
                                                    fontSize: SizeConfig.mediumFontSize,
                                                    color: Colors.black, fontWeight: FontWeight.bold,),
                                                ),
                                                Flexible(
                                                  child: InkWell(
                                                    onTap : (){
                                                      controller.addNewTopping();
                                                    },
                                                    child: TextWidget(text: addNewTopping,
                                                      fontFamily: FontFamily.fontMedium,
                                                      fontSize: SizeConfig.mediumFontSize,
                                                      color: AppColors.colorPrimary, fontWeight: FontWeight.bold,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                                          Expanded(
                                              child:
                                              SingleChildScrollView(
                                                child:  controller.toppingsList.isEmpty ?
                                                Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5,
                                                        vertical: SizeConfig.blockSizeHorizontal*2),
                                                    child: TextWidget(text: AppStrings.toppingsEmptyMsg, fontSize: SizeConfig.mediumFontSize)
                                                )
                                              
                                                : ListView.builder(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        SizeConfig.blockSizeHorizontal *
                                                            3),
                                                    itemCount:
                                                    controller.toppingsList.length +1,
                                                    shrinkWrap: true,
                                                    physics:
                                                    const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index) {
                                                      if(index != controller.toppingsList.length){
                                                        return
                                                          Obx(() =>
                                                              CheckboxListTile(
                                                                  value: controller.toppingsList[index].selected,
                                                                  onChanged: (val){
                                                                    controller.toppingsList[index].selected = val;
                                                                    controller.toppingsList.refresh();
                                                                  },
                                                                  activeColor: AppColors.colorPrimary,
                                                                  contentPadding: EdgeInsets.zero,
                                                                  dense: true,
                                                                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex:3,
                                                                        child:  RichText(
                                                                          text: TextSpan(
                                                                            children: [
                                                                              WidgetSpan(
                                                                                child:
                                                                          (controller.toppingsList[index].type ?? "").trim() == "1"
                                                                              || (controller.toppingsList[index].type ?? "").trim().toLowerCase() == "veg" ?
                                                                                     ImageIcon(
                                                                                  const AssetImage(AppImages.vegType),
                                                                                  size: SizeConfig.blockSizeHorizontal * 4.29,
                                                                                  color: Colors.green,
                                                                                )
                                                                                    : ImageIcon(
                                                                                  const AssetImage(AppImages.nonVegType),
                                                                                  size: SizeConfig.blockSizeHorizontal * 4.29,
                                                                                  color: Colors.red,
                                                                                ),
                                                                              ),
                                                                              TextSpan(text: "  ${controller.toppingsList[index].title}",
                                                                                style: TextStyle( overflow: TextOverflow.ellipsis,
                                                                                    fontFamily: FontFamily.fontMedium,
                                                                                    color: AppColors.blackText,
                                                                                    fontSize: SizeConfig.mediumFontSize
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                                                                      Flexible(
                                                                        flex:1,
                                                                        child: TextWidget(
                                                                          text: "${AppStrings.currSymbolIn} ${controller.toppingsList[index].price}",
                                                                          fontFamily: FontFamily.fontSemiBold,
                                                                          fontSize: SizeConfig.mediumFontSize,
                                                                          textAlign: TextAlign.end,
                                                                          color: AppColors.blackText,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                          );}
                                                      else {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                  .blockSizeHorizontal * 3,
                                                          bottom: SizeConfig.blockSizeHorizontal * 2),
                                                          child: ButtonWidget(
                                                              text: customisationContinue,
                                                              onPressed: () {
                                                                controller.submitToppingClick();
                                                              }),
                                                        );
                                                      }
                                                    })
                                              
                                              ))
                                        ],
                                      ),
                                    );
                                  });
                            }
                          },
                          child:
                          controller.selectedToppingCount.value != 0 ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Visibility(
                                  visible: controller.selectedToppingCount.value != 0,
                                  child: TextWidget(text: "(${controller.selectedToppingCount.value} Added)",
                                      fontSize: SizeConfig.mediumFontSize,
                                      color: Colors.grey),
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                              const Icon(
                                  Icons.edit,
                                  color: AppColors.colorPrimary),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                              TextWidget(text: "Edit",
                                  fontSize: SizeConfig.mediumFontSize,
                                  color: AppColors.colorPrimary),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                            ],
                          )
                         : Row(mainAxisAlignment: MainAxisAlignment.end,
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
                        )
                      ),
                    ],
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  // item price and discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: item_price,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(
                                height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              onlyNumbers: true,
                              keyboardType: TextInputType.number,
                              hintText: item_price_hint,
                              controller: controller.itemPriceController,
                              validator: Validations.validations.validateEmptyCustomisationFields,
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
                              text: item_discount,
                              fontFamily: FontFamily.fontMedium,
                              fontSize: SizeConfig.mediumFontSize,
                              color: AppColors.normalTextColor,
                            ),
                            SizedBox(
                                height: SizeConfig.blockSizeHorizontal * 2),
                            CustomFormField(
                              onlyNumbers: true,
                              hintText: item_discount_hint,
                              keyboardType: TextInputType.number,
                              controller: controller.itemDiscountController,
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
                  // select discount type
                  TextWidget(
                    text: discount_type,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Container(
                    width: Get.width,
                    height: SizeConfig.blockSizeHorizontal * 15.8,
                    decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        border:
                        Border.all(color: AppColors.disabledBorderColor, width: 1.3),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                              () => MyRadioListTile(
                            value: "0",
                            groupValue: controller.discountType.value,
                            onChanged: (value) {
                              controller.onChangeDiscountType(value!);
                            },
                            title: TextWidget(
                              text: AppStrings.btnRadioFlat,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor,
                            ),
                          ),
                        ),
                        Obx(
                              () => MyRadioListTile(
                            value: "1",
                            groupValue: controller.discountType.value,
                            onChanged: (value) {
                              controller.onChangeDiscountType(value!);
                            },
                            title: TextWidget(
                              text: AppStrings.btnRadioPercentage,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor,
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
                      child: Text("Please select item discount type",
                          style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12,
                          )),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
        
                  // select food type
                  TextWidget(
                    text: food_type,
                    fontFamily: FontFamily.fontMedium,
                    fontSize: SizeConfig.mediumFontSize,
                    color: AppColors.normalTextColor,
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  Container(
                    width: Get.width,
                    height: SizeConfig.blockSizeHorizontal * 15.8,
                    decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        border:
                        Border.all(color: AppColors.disabledBorderColor, width: 1.3),
                        borderRadius: const BorderRadius.all(Radius.circular(
                          10.0,
                        ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                              () => MyRadioListTile(
                            value: "1",
                            groupValue: controller.foodType.value,
                            onChanged: (value) {
                              controller.onChangeFoodType(value!);
                            },
                            title: TextWidget(
                              text: AppStrings.btnRadioVeg,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor,
                            ),
                          ),
                        ),
                        Obx(
                              () => MyRadioListTile(
                            value: "2",
                            groupValue: controller.foodType.value,
                            onChanged: (value) {
                              controller.onChangeFoodType(value!);
                            },
                            title: TextWidget(
                              text: AppStrings.btnRadioNonVeg,
                              fontSize: SizeConfig.regularFontSize,
                              color: AppColors.normalTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(()=> Visibility(
                    visible: controller.showFoodError.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,
                          top: SizeConfig.blockSizeHorizontal*1),
                      child: Text("Please select item food type",
                          style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12,
                          )),
                    ),
                  )),
        
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
        
                  // submit button
                  ButtonWidget(
                    text: controller.args != null ?
                    update_item_btn : add_item_btn,
                    onPressed: () {
                      controller.addUpdateClick();
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
        
        
        
        
        
        
        
        
                ]
              )
            )
          )
        )
        
        ),
      ));



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