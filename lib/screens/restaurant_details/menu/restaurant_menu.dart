import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/restaurant_details/menu/restaurant_menu_controller.dart';
import 'package:get/get.dart';
import '../../../component/color_loader.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/font_family.dart';
import '../../../utils/size_config.dart';

class RestaurantMenu extends GetView<RestaurantMenuController> {
  const RestaurantMenu({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.colorPrimary,
        onRefresh: controller.pullRefresh,
        child: Obx(() => controller.initialLoad.value
        // loading menu
            ? Center(
                child: TextWidget(
                    text: AppStrings.menuLoading,
                    color: AppColors.grey,
                    fontSize: SizeConfig.mediumFontSize,
                    fontFamily: FontFamily.fontMedium))

        // empty product list
            : controller.itemsList.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: TextWidget(
                        text: AppStrings.menuEmptyList,
                        color: AppColors.colorPrimary,
                        fontSize: SizeConfig.mediumFontSize,
                        fontFamily: FontFamily.fontMedium),
                  ))
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: controller.itemsList.length,
                                itemBuilder: (context, sub) {
                                  return (controller.itemsList[sub].items ?? []).isEmpty
                                      ? const SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig.blockSizeHorizontal * 2.5,
                                              right: SizeConfig.blockSizeHorizontal * 2.5,
                                              bottom: SizeConfig.blockSizeHorizontal * 2.5),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // subcategories title
                                                TextWidget(
                                                  text: controller.itemsList[sub].title ?? '',
                                                  fontSize: SizeConfig.mediumFontSize,
                                                  color: AppColors.blackText,
                                                  fontFamily: FontFamily.fontMedium,
                                                  fontWeight: FontWeight.w700,
                                                ),

                                                // items
                                                Card(
                                                    elevation: 0,
                                                    color: AppColors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15.0)),
                                                    child: ListView.builder(
                                                        padding: EdgeInsets.only(
                                                            top: SizeConfig.blockSizeHorizontal * 1.25),
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: controller.itemsList[sub].items?.length,
                                                        itemBuilder:
                                                            (context, item) {
                                                          num maxPrice = 0;
                                                          if((controller.itemsList[sub].items?[item].customisations ?? []).isNotEmpty){
                                                            maxPrice = (controller.itemsList[sub].items?[item].customisations ?? [])
                                                                .map((item) => (num.tryParse(item.price ?? "0") ?? 0))
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
                                                                  // img & customisation
                                                                  Column(
                                                                    children: [
                                                                      ClipRRect(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                          child: CachedNetworkImage(
                                                                            height: SizeConfig.blockSizeHorizontal * 24,
                                                                            width: SizeConfig.blockSizeHorizontal * 24,
                                                                            fit: BoxFit.cover,
                                                                            imageUrl: (controller.itemsList[sub].items?[item].thumbnail ?? '').trim().isNotEmpty
                                                                                ? (controller.itemsList[sub].items?[item].thumbnail ?? '')
                                                                                : (controller.itemsList[sub].items?[item].image ?? ''),
                                                                            placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                                                            errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                                                          )),

                                                                      Visibility(
                                                                        visible: (controller.itemsList[sub].items?[item].customisations ?? []).isNotEmpty
                                                                        || (controller.itemsList[sub].items?[item].toppings ?? []).isNotEmpty,
                                                                        child: Padding(
                                                                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal*0.38),
                                                                        child: TextWidget(text: AppStrings.menuItemCustomised,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: AppColors.grey.shade700,
                                                                        fontSize: SizeConfig.blockSizeHorizontal*3)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 1),


                                                                  // other item details
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal * 1),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          // type & item name
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                WidgetSpan(
                                                                                  child: controller.itemsList[sub].items?[item].type == 1
                                                                                      ? ImageIcon(
                                                                                          const AssetImage(AppImages.vegType),
                                                                                          size: SizeConfig.blockSizeHorizontal * 4.29,
                                                                                          color: AppColors.green,
                                                                                        )
                                                                                      : ImageIcon(
                                                                                          const AssetImage(AppImages.nonVegType),
                                                                                          size: SizeConfig.blockSizeHorizontal * 4.29,
                                                                                          color: AppColors.red,
                                                                                        ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: " ${controller.itemsList[sub].items?[item].name ?? ''}",
                                                                                  style: TextStyle(overflow: TextOverflow.ellipsis, fontFamily: FontFamily.fontMedium, color: AppColors.black87, fontSize: SizeConfig.mediumFontSize),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: SizeConfig.blockSizeHorizontal * 0.65),

                                                                          // item description
                                                                          TextWidget(
                                                                            overflow: TextOverflow.ellipsis,
                                                                            text: controller.itemsList[sub].items?[item].description ?? '',
                                                                            color: AppColors.normalTextColor,
                                                                            maxLines: 2,
                                                                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                                                                            fontFamily: FontFamily.fontRegular,
                                                                          ),
                                                                          SizedBox(
                                                                              height: SizeConfig.blockSizeHorizontal * 0.65),

                                                                          // item price
                                                                          SizedBox(
                                                                            child:
                                                                                 (controller.itemsList[sub].items?[item].customisations ?? []).isNotEmpty ?
                                                                                 Row(
                                                                                   children: [
                                                                                     // discount available or not
                                                                                     Flexible(
                                                                                       child: Visibility(
                                                                                         visible: (num.tryParse("${controller.itemsList[sub].items?[item].discount ?? 0}") ?? 0) > 0,
                                                                                         child: TextWidget(text: '${AppStrings.currSymbolIn}${"$maxPrice"}',
                                                                                           color: AppColors.red.shade600,
                                                                                           fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.w600,
                                                                                           decoration: TextDecoration.lineThrough,
                                                                                           decorationColor: AppColors.red.shade700,
                                                                                           decorationThickness: 1.5,
                                                                                         ),
                                                                                       ),
                                                                                     ),
                                                                                     SizedBox(
                                                                                       width: SizeConfig.blockSizeHorizontal * 1.25,
                                                                                     ),

                                                                                     // price after discount
                                                                                     Flexible(
                                                                                       child: TextWidget(
                                                                                           text: controller.getDiscountedPriceText(
                                                                                               discountType: controller.itemsList[sub].items?[item].discountType,
                                                                                               discount: controller.itemsList[sub].items?[item].discount,
                                                                                               basePrice: maxPrice
                                                                                           ),
                                                                                           color: AppColors.blackText,
                                                                                           fontSize: SizeConfig.regularFontSize
                                                                                       ),
                                                                                     )
                                                                                     /*controller.itemsList[sub].items?[item].discountType == 1
                                                                                         ? Flexible(
                                                                                       child: TextWidget(text: int.parse((double.parse("$maxPrice") - (double.parse("$maxPrice") * double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(0)) > 0 ?
                                                                                       '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                           (double.parse("$maxPrice") - (double.parse("$maxPrice") * double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(2)))}'
                                                                                           : "${AppStrings.currSymbolIn}0", color: AppColors.blackText,
                                                                                           fontSize: SizeConfig.regularFontSize
                                                                                       ),
                                                                                     )
                                                                                         : Flexible(
                                                                                       child: TextWidget(text: int.parse((double.parse("$maxPrice") - double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}")).toStringAsFixed(0)) > 0 ?
                                                                                       '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                           (double.parse("$maxPrice") - double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}")).toStringAsFixed(2)))}'
                                                                                           : "${AppStrings.currSymbolIn}0", color: AppColors.blackText, fontSize: SizeConfig.regularFontSize,
                                                                                       ),
                                                                                     ),*/
                                                                                   ],
                                                                                 )

                                                                                : Row(
                                                                              children: [
                                                                                // discount available or not
                                                                                Flexible(
                                                                                  child: Visibility(
                                                                                    visible: (num.tryParse("${controller.itemsList[sub].items?[item].discount ?? 0}") ?? 0) > 0,
                                                                                    child: TextWidget(text: '${AppStrings.currSymbolIn}${"${controller.itemsList[sub].items?[item].price ?? 0}"}',
                                                                                      color: AppColors.red.shade600,
                                                                                      fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.w600,
                                                                                        decoration: TextDecoration.lineThrough,
                                                                                        decorationColor: AppColors.red.shade700,
                                                                                        decorationThickness: 1.5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: SizeConfig.blockSizeHorizontal * 1.25,
                                                                                ),

                                                                                // price after discount
                                                                                Flexible(
                                                                                  child: TextWidget(
                                                                                    text: controller.getDiscountedPriceText(
                                                                                      discountType: controller.itemsList[sub].items?[item].discountType,
                                                                                      discount: controller.itemsList[sub].items?[item].discount,
                                                                                      basePrice: controller.itemsList[sub].items?[item].price
                                                                                    ),
                                                                                    color: AppColors.blackText,
                                                                                    fontSize: SizeConfig.regularFontSize
                                                                                  ),
                                                                                )
                                                                                /*controller.itemsList[sub].items?[item].discountType == 1
                                                                                    ? Flexible(
                                                                                        child: TextWidget(text: int.parse((double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") - (double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") * double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(0)) > 0 ?
                                                                                        '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                            (double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") - (double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") * double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}") / 100)).toStringAsFixed(2)))}'
                                                                                            : "${AppStrings.currSymbolIn}0", color: AppColors.blackText,
                                                                                            fontSize: SizeConfig.regularFontSize
                                                                                        ),
                                                                                      )
                                                                                    : Flexible(
                                                                                        child: TextWidget(text: int.parse((double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") - double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}")).toStringAsFixed(0)) > 0 ?
                                                                                        '${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(num.parse(
                                                                                            (double.parse("${controller.itemsList[sub].items?[item].price ?? 0}") - double.parse("${controller.itemsList[sub].items?[item].discount ?? 0}")).toStringAsFixed(2)))}'
                                                                                            : "${AppStrings.currSymbolIn}0", color: AppColors.blackText, fontSize: SizeConfig.regularFontSize,
                                                                                        ),
                                                                                      ),*/
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),


                                                                  // switch
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
                                                                                        value: controller.itemsList[sub].items?[item].status == 1,
                                                                                        onChanged: (bool value) {
                                                                                          controller.changeItemAvailability(
                                                                                              isAvailable: value,
                                                                                              index2: sub,
                                                                                              index3: item);
                                                                                        },
                                                                                        activeTrackColor: CupertinoColors.activeGreen,
                                                                                        thumbColor: CupertinoColors.white,
                                                                                        inactiveTrackColor: AppColors.red,
                                                                                      ))),
                                                                              Obx(() => TextWidget(
                                                                                    text: controller.itemsList[sub].items?[item].status == 1 ?  AppStrings.menuItemAvailable: AppStrings.menuItemOutOfStock,
                                                                                    fontFamily: FontFamily.fontMedium,
                                                                                    fontSize: controller.itemsList[sub].items?[item].status == 1 ? SizeConfig.blockSizeHorizontal * 2.5 : SizeConfig.blockSizeHorizontal * 2.3,
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
                    ]
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
