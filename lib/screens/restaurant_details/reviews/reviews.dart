import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_merchant/component/color_loader.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/restaurant_details/reviews/reviews_controller.dart';
import 'package:food_merchant/utils/date_time_utils.dart';
import 'package:get/get.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../utils/size_config.dart';

class Reviews extends GetView<ReviewsController>{
  const Reviews({super.key});


  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child =  Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(()=> RefreshIndicator(  color: AppColors.colorPrimary,
            onRefresh: controller.pullRefresh,
            child: controller.initialLoad.value
                ? Center(child: ColorLoader())
                : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: controller.reviewsList.isEmpty ?
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal*4),
                    alignment: Alignment.center,
                    child: TextWidget(text: controller.showLoader.value  ||
                        controller.refreshLoad.value || controller.initialLoad.value
                        ? '' : AppStrings.reviewsEmpty,
                        color: AppColors.grey,
                        fontSize: SizeConfig.mediumFontSize,
                        fontFamily: FontFamily.fontMedium),
                  ),
                )

                        : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child:
                        ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal*2.5),
                            shrinkWrap: true,
                            itemCount: controller.reviewsList.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            //controller: controller.scrollController,
                            itemBuilder: (context, index) {
                              var review = controller.reviewsList[index];
                              return
                                Container(width: Get.width,
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: SizeConfig.blockSizeHorizontal * 0.25),
                                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeHorizontal*4),

                                          // user image, name & rating
                                          Row( crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // user image
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*12),
                                                    child: CachedNetworkImage(
                                                      height: SizeConfig.blockSizeHorizontal*12,
                                                      width: SizeConfig.blockSizeHorizontal*12,
                                                      fit: BoxFit.cover,
                                                      imageUrl: (review.userThumbnail ?? '').trim().isNotEmpty
                                                      ? (review.userThumbnail ?? '')
                                                      : (review.userImage ?? ''),
                                                      placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                                      errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                                    )
                                                ),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal*3,),

                                                // user name & ratings
                                                Expanded(
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        // user name
                                                        TextWidget(overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          text: review.userName ?? '',
                                                          fontFamily: FontFamily.fontSemiBold,
                                                          fontSize: SizeConfig.regularFontSize,
                                                          fontWeight: FontWeight.w600,),

                                                        // ratings
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: RatingBarIndicator(
                                                                  rating: double.tryParse(review.review ?? '0') ?? 5.0,
                                                                  itemCount: 5,
                                                                  itemSize:
                                                                  SizeConfig.blockSizeHorizontal*5,
                                                                  itemBuilder: (context, _) => const Icon(
                                                                    Icons.star,
                                                                    color: AppColors.colorPrimary,
                                                                  )
                                                              ),
                                                            ),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal*2.2,),
                                                            Expanded(
                                                              child: TextWidget(text: review.review ?? '',
                                                                maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.regularFontSize,),
                                                            ),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal*1),

                                                            // review date
                                                            Expanded(
                                                              child: TextWidget(text: DateTimeUtils.utils.getDurationTimeAgo(review.date ?? '',
                                                                  DateTimeUtils().dateFormatDDMMMYYYY, true), textAlign: TextAlign.end,
                                                                fontFamily: FontFamily.fontMedium,fontSize:  SizeConfig.regularFontSize,
                                                                color: AppColors.normalTextColor,fontWeight: FontWeight.w500, maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                            )
                                                          ],)]),
                                                )]),
                                          SizedBox(height: SizeConfig.blockSizeHorizontal*2),

                                          // message
                                          TextWidget(text: review.message ?? '',
                                              fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: AppColors.normalTextColor),

                                          // divider
                                          Visibility(
                                              visible: index != controller.reviewsList.length -1,
                                              child: const Divider()),
                                        ])
                                );
                            })
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
                    )

                )
                
              ],
            )
            

        )) );

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