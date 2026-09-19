import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/restaurant_details/reviews/ReviewsController.dart';
import 'package:food_merchant/utils/DateTimeUtils.dart';
import 'package:get/get.dart';
import '../../../component/custom_text_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../utils/size_config.dart';

// ignore: must_be_immutable
class Reviews extends StatelessWidget{
  ReviewsController controller = Get.put(ReviewsController());

  Reviews({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.white,
        body:
        Obx(()=> controller.restaurantReview.isEmpty  ? Center(child: TextWidget(text: 'No review found',
        fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.regularFontSize,color: AppColors.normalTextColor,)):
        RefreshIndicator(  color: AppColors.colorPrimary,
            onRefresh: controller.pullRefresh,
            child:
        ListView.builder(padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),

    shrinkWrap: true,
    itemCount: controller.restaurantReview.length,
            physics: const AlwaysScrollableScrollPhysics(),

    itemBuilder: (context, index) {
    return
      Container(width: Get.width,
          padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 0.25),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.blockSizeHorizontal*4),
                Row( crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*12),
                          child: CachedNetworkImage(
                            height: SizeConfig.blockSizeHorizontal*12,
                            width: SizeConfig.blockSizeHorizontal*12,
                            fit: BoxFit.cover,
                            imageUrl: controller.restaurantReview[index].userImage,
                            placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                          )
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextWidget(overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: '${controller.restaurantReview[index].userName}',
                                fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.w600,),
                              Row(
                                children: [
                                  Flexible(
                                    child: RatingBarIndicator(
                                        rating: double.parse(controller.restaurantReview[index].review!),
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
                                    child: TextWidget(text: '${controller.restaurantReview[index].review}',
                                      maxLines: 1,overflow: TextOverflow.ellipsis,
                                      fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.regularFontSize,),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*1),
                                  Expanded(
                                    child: TextWidget(text: '${DateTimeUtils.utils.getDurationTimeAgo(controller.restaurantReview[index].date,
                                        DateTimeUtils().DATE_FORMAT_DD_MMM_YYYY, true)}', textAlign: TextAlign.end,
                                      fontFamily: FontFamily.fontMedium,fontSize:  SizeConfig.regularFontSize,
                                      color: AppColors.normalTextColor,fontWeight: FontWeight.w500, maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  )
                                ],)]),
                      )]),
                SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                TextWidget(text: '${controller.restaurantReview[index].message}',
                  fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: AppColors.normalTextColor),
                Visibility(
                    visible: index != controller.restaurantReview.length -1,
                    child: const Divider()),
              ])
      );
    /*  Container(width: Get.width,
    padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 0.25),
    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.blockSizeHorizontal*4),
        Row( crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.blockSizeHorizontal*12,
          width: SizeConfig.blockSizeHorizontal*12,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*12),
              child:
              controller.restaurantReview[index].userImage != "" ?
                  CommonUtils.utils.haveImage(controller.restaurantReview[index].userImage) ?
              ProgressiveImage(
                  placeholder:  const AssetImage(AppImages.loadingGif),
                  thumbnail:  const AssetImage(AppImages.loadingGif),
                  image:  NetworkImage(controller.restaurantReview[index].userImage),
                  fit: BoxFit.cover,
                  width: SizeConfig.blockSizeHorizontal*12,
                  height:SizeConfig.blockSizeHorizontal*12,
              )

                  : Image.asset(appLogo,fit: BoxFit.cover,)
              : Image.asset(appLogo,fit: BoxFit.cover,)
          ),
        ),
        SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
        SizedBox(height: SizeConfig.blockSizeHorizontal*12,
          width:  SizeConfig.blockSizeHorizontal*76,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: '{controller.restaurantReview[index].userName}',
                  fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.regularFontSize),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Row(
                  children: [
                    RatingBarIndicator(
                        rating: controller.ratingStar(controller.restaurantReview[index].review),
                        itemCount: 5,
                        itemSize:
                        SizeConfig.blockSizeHorizontal*5.2,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppColors.colorPrimary,
                        )
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal*2.2,),
                    TextWidget(text: '${controller.restaurantReview[index].review}',
                      fontFamily: FontFamily.fontSemiBold,fontSize: SizeConfig.regularFontSize,),
                  ],
                ),

            TextWidget(text: '${DateTimeUtils.utils.getDurationTimeAgo(controller.restaurantReview[index].date,
            DateTimeUtils().DATE_FORMAT_DD_MMM_YYYY, true)}',fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.regularFontSize,color: AppColors.normalTextColor,)
                ],)])
              )]),
        SizedBox(height: SizeConfig.blockSizeHorizontal*2),
        TextWidget(text: '${controller.restaurantReview[index].message}',
          fontFamily: FontFamily.fontRegular,fontSize: SizeConfig.mediumFontSize,color: AppColors.normalTextColor,),
        Visibility(
          visible: index != controller.restaurantReview.length -1,
            child: const Divider()),
    ])
      )
    ;*/









        })
        )) );




  }
}