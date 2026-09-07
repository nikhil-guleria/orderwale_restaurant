import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/component/BottomSheet.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/CustomRadioButton.dart';
import '../../component/TextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../constant/app_images.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'AddProductController.dart';

class AddProduct extends GetView<AddProductController> {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
            title: TextWidget(
              text: app_bar_title,
              color: Colors.black,
              fontSize: SizeConfig.appbarTitleSize,
              fontFamily: fontSemiBold,
              weight: FontWeight.w600,
            ),
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: colorWhite,
              statusBarIconBrightness: Brightness.dark,
            )),
        body: Container(
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
                    Stack(alignment: Alignment.bottomRight, children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9)),
                          height: SizeConfig.blockSizeHorizontal * 55,
                          width: Get.width,
                          child: Obx(() => controller.imageFile.value == ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.asset(
                                    errorImg,
                                    fit: BoxFit.cover,
                                  ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                      File(controller.imageFile.value),
                                      fit: BoxFit.cover),
                                ))),
                      Container(
                        margin: EdgeInsets.only(
                            right: SizeConfig.blockSizeHorizontal * 1.25,
                            bottom: SizeConfig.blockSizeHorizontal * 1.25),
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
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Get.dialog(AlertDialog(
                                  surfaceTintColor: colorWhite,
                                    backgroundColor: colorWhite,
                                    title: Text("Select Image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: SizeConfig.semiBoldFontSize,
                                          fontFamily: fontSemiBold,
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
                                                  fontFamily: fontMedium),
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
                                                fontFamily: fontMedium),
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
                                                  fontFamily: fontMedium)),
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
                                color: colorWhite,
                                size: SizeConfig.blockSizeHorizontal * 6.2,
                              )),
                        ),
                      )
                    ]),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 7),
                    TextWidget(
                      text: categories,
                      fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    Obx(() => Container(
                          width: Get.width,
                          height: SizeConfig.blockSizeHorizontal * 13.8,
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2.5),
                          decoration: BoxDecoration(
                              color: textFieldFillColor,
                              border: Border.all(
                                  color: disabledBorderColor, width: 1.3),
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
                                          return ListTile(
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
                                                    .categoryName,
                                                color: blackShades,
                                                fontSize:
                                                    SizeConfig.mediumFontSize,
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
                                    color: colorPrimary,
                                    size: SizeConfig.boldFontSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    TextWidget(
                      text: add_menu_name,
                      fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    Obx(() => Container(
                          width: Get.width,
                          height: SizeConfig.blockSizeHorizontal * 13.8,
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2.5),
                          decoration: BoxDecoration(
                              color: textFieldFillColor,
                              border: Border.all(
                                  color: disabledBorderColor, width: 1.3),
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
                                      backgroundColor: colorWhite,
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
                                                      fontFamily: fontMedium,
                                                      fontSize:
                                                          SizeConfig.mediumFontSize,
                                                      color: Colors.black,
                                                      weight: FontWeight.bold,
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
                                                                color: colorPrimary,
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
                                                                          colorPrimary,
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
                                                                      colorPrimary,
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
                                                                                .title,
                                                                            color:
                                                                                blackShades,
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
                                                                                colorPrimary,
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
                                                                                .title,
                                                                            color:
                                                                                blackShades,
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
                                                                                  colorPrimary,
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
                                                                                colorPrimary,
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
                                    } else if (value == "editMenu") {
                                      controller.editSubCategoryTap();
                                    }
                                  });
                                }
                              } else {
                                Get.snackbar(alert, "Please Select Category");
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
                                    color: colorPrimary,
                                    size: SizeConfig.boldFontSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    TextWidget(
                      text: add_product_name,
                      fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    TextFormWidget(
                      hintText: add_product_name_hint,
                      controller: controller.productNameController,
                      textCapitalization: TextCapitalization.words,
                      validator: Validations.validations.validateEmptyFields,
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    TextWidget(
                      text: item_descp,
                      fontFamily: fontMedium,
                      fontSize: SizeConfig.mediumFontSize,
                      color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    TextFormWidget(
                      hintText: item_descp_hint,
                      controller: controller.itemDescriptionController,
                      validator: Validations.validations.validateEmptyFields,
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: item_price,
                                fontFamily: fontMedium,
                                fontSize: SizeConfig.mediumFontSize,
                                color: normalTextColor,
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 2),
                              TextFormWidget(
                                onlyNumbers: true,
                                keyboardType: TextInputType.number,
                                hintText: item_price_hint,
                                controller: controller.itemPriceController,
                                validator: Validations.validations.validateEmptyFields,
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
                                fontFamily: fontMedium,
                                fontSize: SizeConfig.mediumFontSize,
                                color: normalTextColor,
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 2),
                              TextFormWidget(
                                allowDecimal: true,
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
                    TextWidget(
                      text: discount_type,
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
                                text: radio_btn_flat,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
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
                                text: radio_btn_percentage,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    TextWidget(
                      text: food_type,
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
                          Obx(
                            () => MyRadioListTile(
                              value: "1",
                              groupValue: controller.foodType.value,
                              onChanged: (value) {
                                controller.onChangeFoodType(value!);
                              },
                              title: TextWidget(
                                text: radio_btn_veg,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
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
                                text: radio_btn_nonVeg,
                                fontSize: SizeConfig.regularFontSize,
                                color: normalTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                    ButtonWidget(
                      text: add_item_btn,
                      onPressed: () {
                        controller.checkValidation();
                      },
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                  ],
                ),
              ),
            )));
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
