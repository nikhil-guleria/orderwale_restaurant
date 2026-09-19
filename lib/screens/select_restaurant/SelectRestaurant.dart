import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../constant/app_images.dart';
import '../../../utils/size_config.dart';
import '../no_restaurant/NoRestaurant.dart';
import 'SelectRestaurantController.dart';

class SelectRestaurant extends GetView<SelectRestaurantController> {
  const SelectRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    CommonUtils.utils.statusBarColored();
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextWidget(
            text: "Select Restaurant",
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: FontFamily.fontSemiBold,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            Obx(() => Visibility(
                  visible: controller.restaurantsList.isEmpty,
                  child: IconButton(
                      onPressed: () {
                        controller.logOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.colorPrimary,
                        size: SizeConfig.blockSizeHorizontal * 5,
                      )),
                ))
          ],
        ),
        body: SafeArea(child:

        Obx(() => controller.initialLoad.value
            ? ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                itemCount: 2,
                itemBuilder: (context, index) => Card(
                    elevation: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                        width: Get.width,
                        height: SizeConfig.blockSizeHorizontal * 76,
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Column(
                              children: [
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      SizedBox(
                                        width: Get.width,
                                        height:
                                            SizeConfig.blockSizeHorizontal * 60,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, bottom: 15),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                  height:
                                                      SizeConfig.boldFontSize,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      60,
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6, right: 3),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                  height: SizeConfig
                                                          .blockSizeHorizontal *
                                                      7,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      12,
                                                )
                                              ]))
                                    ]),
                                Container(
                                  width: Get.width,
                                  height: SizeConfig.blockSizeHorizontal * 16,
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    2,
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            height:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    70,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )))))
            : controller.restaurantsList.isEmpty
                ? const NoRestaurant()
                : SizedBox(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 2.5),
                              itemCount: controller.restaurantsList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 50,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                          color:
                                              controller.currentIndex.value ==
                                                      index
                                                  ? AppColors.colorPrimary
                                                  : Colors.transparent,
                                          width: 4.3)),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectRestaurant(index);

                                      ///controller.onTap(controller.restaurantsList[index].id!);
                                    },
                                    child: SizedBox(
                                        width: Get.width,
                                        height:
                                            SizeConfig.blockSizeHorizontal * 76,
                                        child: Column(
                                          children: [
                                            Stack(children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(15),
                                                      topLeft: Radius.circular(15)),
                                                  color: AppColors.white,
                                                ),
                                                foregroundDecoration:  BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Colors.transparent, Colors.black.withAlpha((0.74 * 255).round())],
                                                    //stops: [0, 0.5, 1],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(15),
                                                        topLeft: Radius.circular(15)),
                                                    child: CachedNetworkImage(
                                                      width: Get.width,
                                                      height: SizeConfig.blockSizeHorizontal * 60,
                                                      fit: BoxFit.cover,
                                                      imageUrl: controller.restaurantsList[index].image,
                                                      placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                                      errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                                    )
                                                ),
                                              ),

                                              Positioned(
                                                left: SizeConfig.blockSizeHorizontal * 3,
                                                bottom: SizeConfig.blockSizeHorizontal * 3,
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      68,
                                                  child: TextWidget(
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text:
                                                        '${controller.restaurantsList[index].name}',
                                                    color: AppColors.white,
                                                    fontFamily: FontFamily.fontBold,
                                                    fontSize:
                                                        SizeConfig.boldFontSize,
                                                  ),
                                                ),
                                              ),
                                              controller.restaurantsList[index]
                                                          .review ==
                                                      "0.0"
                                                  ? Container()
                                                  : Positioned(
                                                      right: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3,
                                                      bottom: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.5,
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              right: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  0.75),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          5.0))),
                                                          height: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              7,
                                                          width: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              13,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: TextWidget(
                                                                    text:
                                                                        '${controller.restaurantsList[index].review}',
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    color:
                                                                        AppColors.white,
                                                                    fontFamily:
                                                                        FontFamily.fontSemiBold,
                                                                    fontSize:
                                                                        SizeConfig
                                                                            .regularFontSize),
                                                              ),
                                                              Icon(Icons.star,
                                                                  size: SizeConfig
                                                                      .regularFontSize,
                                                                  color:
                                                                      AppColors.white)
                                                            ],
                                                          )),
                                                    )
                                            ]),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),
                                                    bottomRight: Radius.circular(15.0)),
                                              ),

                                              width: Get.width,
                                              height: SizeConfig
                                                      .blockSizeHorizontal *
                                                  16,
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2,
                                                  left: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: AppColors.colorPrimary,
                                                    size: SizeConfig
                                                            .blockSizeHorizontal *
                                                        6,
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        2,
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        80,
                                                    child: TextWidget(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      text:
                                                          '${controller.restaurantsList[index].address!}',
                                                      fontFamily: FontFamily.fontMedium,
                                                      fontSize: SizeConfig
                                                          .regularFontSize,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              }),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 3.75,
                                vertical: SizeConfig.blockSizeHorizontal * 2.5),
                            child: ButtonWidget(
                                text: "SUBMIT",
                                onPressed: () {
                                  controller.submitButton();
                                }))
                      ],
                    ),
                  ))));
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
