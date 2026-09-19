import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/restaurant_details/menu/MenuController.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../utils/size_config.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantMenuController controller = Get.put(RestaurantMenuController());
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.colorPrimary,
        onRefresh: controller.pullRefresh,
        child: Obx(() => controller.initialLoad.value
            ? Center(
                child: TextWidget(
                    text: "Loading your products ...",
                    color: AppColors.colorPrimary,
                    fontSize: SizeConfig.mediumFontSize,
                    fontFamily: FontFamily.fontMedium))
            : controller.productDetails.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: TextWidget(
                        text: "Nothing to show please add some items.",
                        color: AppColors.colorPrimary,
                        fontSize: SizeConfig.mediumFontSize,
                        fontFamily: FontFamily.fontMedium),
                  ))
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.productDetails.length,
                                itemBuilder: (context, sub) {
                                  return (controller.productDetails[sub].items ?? []).isEmpty
                                      ? const SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig
                                                      .blockSizeHorizontal *
                                                  2.5,
                                              right: SizeConfig
                                                      .blockSizeHorizontal *
                                                  2.5,
                                              bottom: SizeConfig
                                                      .blockSizeHorizontal *
                                                  2.5),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text:
                                                      "${controller.productDetails[sub].title}",
                                                  fontSize:
                                                      SizeConfig.mediumFontSize,
                                                  color: AppColors.blackText,
                                                  fontFamily: FontFamily.fontMedium,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                Card(
                                                    elevation: 0,
                                                    color: AppColors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: ListView.builder(
                                                        padding: EdgeInsets.only(
                                                            top: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                1.25),
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: controller.productDetails[sub].items?.length,
                                                        itemBuilder:
                                                            (context, item) {
                                                          num maxPrice = 0;
                                                          if((controller.productDetails[sub].items?[item].customisations ?? []).isNotEmpty){
                                                            maxPrice = (controller.productDetails[sub].items?[item].customisations ?? [])
                                                                .map((item) => num.parse(item.price ?? "0"))
                                                                .reduce((a, b) => (a > b ? a : b));
                                                          }


                                                          return Container(
                                                            width: Get.width,
                                                            margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 4.75),
                                                            child: InkWell(
                                                              highlightColor: AppColors.white,
                                                              splashColor: AppColors.white,
                                                              onTap: () {
                                                                controller.updateProduct(sub: sub, item: item);
                                                              },
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      ClipRRect(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                          child: CachedNetworkImage(
                                                                            height: SizeConfig.blockSizeHorizontal * 24,
                                                                            width: SizeConfig.blockSizeHorizontal * 24,
                                                                            fit: BoxFit.contain,
                                                                            memCacheHeight: (SizeConfig.blockSizeHorizontal * 24).toInt(),
                                                                            memCacheWidth: (SizeConfig.blockSizeHorizontal * 24).toInt(),
                                                                            imageUrl: controller.productDetails[sub].items?[item].image ?? "",
                                                                            placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                                                            errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                                                          )),
                                                                      Visibility(
                                                                        visible: (controller.productDetails[sub].items?[item].customisations ?? []).isNotEmpty
                                                                        || (controller.productDetails[sub].items?[item].toppings ?? []).isNotEmpty,
                                                                        child: Padding(
                                                                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*0.38),
                                                                        child: TextWidget(text: "Customised",
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey.shade700,
                                                                        fontSize: SizeConfig.blockSizeHorizontal*3,)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      width: SizeConfig.blockSizeHorizontal * 1),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal * 1),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          RichText(
                                                                          //  maxLines: 2,
                                                                          //  overflow: TextOverflow.ellipsis,
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                WidgetSpan(
                                                                                  child: controller.productDetails[sub].items?[item].type == 1
                                                                                      ? ImageIcon(
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
                                                                                TextSpan(
                                                                                  text: " ${controller.productDetails[sub].items?[item].name}",
                                                                                  style: TextStyle(overflow: TextOverflow.ellipsis, fontFamily: FontFamily.fontMedium, color: Colors.black87, fontSize: SizeConfig.mediumFontSize),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: SizeConfig.blockSizeHorizontal * 0.65),
                                                                          TextWidget(
                                                                            overflow: TextOverflow.ellipsis,
                                                                            text: "${controller.productDetails[sub].items?[item].description}",
                                                                            color: AppColors.normalTextColor,
                                                                            maxLines: 2,
                                                                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                                                                            fontFamily: FontFamily.fontRegular,
                                                                          ),
                                                                          SizedBox(
                                                                              height: SizeConfig.blockSizeHorizontal * 0.65),
                                                                          SizedBox(
                                                                            child:
                                                                                 (controller.productDetails[sub].items?[item].customisations ?? []).isNotEmpty ?
                                                                                 Row(
                                                                                   children: [
                                                                                     Flexible(
                                                                                       child: Visibility(
                                                                                         visible: double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") != 0,
                                                                                         child: TextWidget(text: '${AppStrings.currSymbolIn}${"$maxPrice"}',
                                                                                           color: Colors.red.shade600,
                                                                                           fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.w600,
                                                                                           decoration: TextDecoration.lineThrough,
                                                                                           decorationColor: Colors.red.shade700,
                                                                                           decorationThickness: 1.5,
                                                                                         ),
                                                                                       ),
                                                                                     ),
                                                                                     SizedBox(
                                                                                       width: SizeConfig.blockSizeHorizontal * 1.25,
                                                                                     ),
                                                                                     controller.productDetails[sub].items?[item].discountType == 1
                                                                                         ? Flexible(
                                                                                       child: TextWidget(text: int.parse((double.parse("$maxPrice") - (double.parse("$maxPrice") * double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(0)) > 0 ?
                                                                                       '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                           (double.parse("$maxPrice") - (double.parse("$maxPrice") * double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(2)))}'
                                                                                           : "${AppStrings.currSymbolIn}0", color: AppColors.blackText,
                                                                                           fontSize: SizeConfig.regularFontSize
                                                                                       ),
                                                                                     )
                                                                                         : Flexible(
                                                                                       child: TextWidget(text: int.parse((double.parse("$maxPrice") - double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}")).toStringAsFixed(0)) > 0 ?
                                                                                       '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                           (double.parse("$maxPrice") - double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}")).toStringAsFixed(2)))}'
                                                                                           : "${AppStrings.currSymbolIn}0", color: AppColors.blackText, fontSize: SizeConfig.regularFontSize,
                                                                                       ),
                                                                                     ),
                                                                                   ],
                                                                                 )

                                                                                : Row(
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Visibility(
                                                                                    visible: double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") != 0,
                                                                                    child: TextWidget(text: '${AppStrings.currSymbolIn}${"${controller.productDetails[sub].items?[item].price ?? 0}"}',
                                                                                      color: Colors.red.shade600,
                                                                                      fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.w600,
                                                                                        decoration: TextDecoration.lineThrough,
                                                                                        decorationColor: Colors.red.shade700,
                                                                                        decorationThickness: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: SizeConfig.blockSizeHorizontal * 1.25,
                                                                                ),
                                                                                controller.productDetails[sub].items?[item].discountType == 1
                                                                                    ? Flexible(
                                                                                        child: TextWidget(text: int.parse((double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") - (double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") * double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(0)) > 0 ?
                                                                                        '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                            (double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") - (double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") * double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(2)))}'
                                                                                            : "${AppStrings.currSymbolIn}0", color: AppColors.blackText,
                                                                                            fontSize: SizeConfig.regularFontSize
                                                                                        ),
                                                                                      )
                                                                                    : Flexible(
                                                                                        child: TextWidget(text: int.parse((double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") - double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}")).toStringAsFixed(0)) > 0 ?
                                                                                        '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                            (double.parse("${controller.productDetails[sub].items?[item].price ?? 0}") - double.parse("${controller.productDetails[sub].items?[item].discount ?? 0}")).toStringAsFixed(2)))}'
                                                                                            : "${AppStrings.currSymbolIn}0", color: AppColors.blackText, fontSize: SizeConfig.regularFontSize,
                                                                                        ),
                                                                                      ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      height: SizeConfig.blockSizeHorizontal * 24,
                                                                      width: SizeConfig.blockSizeHorizontal * 17,
                                                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal * 0.5),
                                                                      child:
                                                                          Column(
                                                                            children: [
                                                                              Transform.scale(
                                                                                  scale: 0.777,
                                                                                  child: Obx(() => CupertinoSwitch(
                                                                                        value: controller.productDetails[sub].items?[item].status == 1,
                                                                                        onChanged: (bool value) {
                                                                                          controller.changeProductAvailability(value, sub, item);
                                                                                        },
                                                                                        activeColor: CupertinoColors.activeGreen,
                                                                                        thumbColor: CupertinoColors.white,
                                                                                        trackColor: Colors.red,
                                                                                      ))),
                                                                              Obx(() => TextWidget(
                                                                                    text: controller.productDetails[sub].items?[item].status == 1 ? 'Available' : 'Out of Stock',
                                                                                    fontFamily: FontFamily.fontMedium,
                                                                                    fontSize: controller.productDetails[sub].items?[item].status == 1 ? SizeConfig.blockSizeHorizontal * 2.5 : SizeConfig.blockSizeHorizontal * 2.3,
                                                                                  ))
                                                                            ],
                                                                          )),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }))
                                              ]),
                                        );
                                }),

                      SizedBox(height: SizeConfig.blockSizeHorizontal * 15)
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addNewProduct();
        },
        backgroundColor: AppColors.colorPrimary,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
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
