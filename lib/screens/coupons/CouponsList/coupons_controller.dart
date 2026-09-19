import 'package:flutter/cupertino.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'coupons_model.dart';


class CouponsController extends GetxController {

  var showLoader = true.obs;
  var couponsList = <CouponsListItem>[].obs;
  GetStorage storage = GetStorage();


  @override
  void onReady() {
    super.onReady();
    getCouponsList();
  }



  Future<void> pullToRefresh() async {
    showLoader.value = true;
    getCouponsList();
  }


  Future<void> getCouponsList()  async {
    try {
      var couponsListData = await ApiController().restaurantCoupons();
      couponsList.clear();
      showLoader.value = false;
        if (couponsListData.responseCode == AppStrings.apiSuccess) {
          CouponsModel couponsModel = CouponsModel.fromJson(
              couponsListData.response?.data ?? "");
          couponsList.value = couponsModel.result ?? [];
        }
        else {
          if(couponsListData.responseCode == AppStrings.unauthenticated){
            await CommonUtils.utils.unauthenticatedRestaurant();
            return;
          }
          if(couponsListData.responseCode != 0){
          CommonUtils.utils.handleAlertMsg(
             code: couponsListData.responseCode,
             message: couponsListData.msg,
          );}
        }
    } catch (e) {
      showLoader.value = false;
      debugPrint("exception coupons --> $e");
    }
  }



  bool isCouponValid(String endDateString) {
    if (endDateString.trim().isEmpty) return false;
    try {
      DateTime endDate = DateFormat('yyyy-MM-dd').parse(endDateString);

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

      return !end.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  void goToUpdateCoupon(CouponsListItem coupon){
    Get.toNamed(AppRoutes.addUpdateCoupons, arguments: coupon)?.then((value) {
      if(value == "updated" || value == "deleted") {
        showLoader.value = true;
        getCouponsList();
      }
    });
  }



  void goToAddCoupon(){
    Get.toNamed(AppRoutes.addUpdateCoupons)?.then((value)  {
      if(value == "added") {
        showLoader.value = true;
        getCouponsList();
      }
    });
  }



  String calculateDiscount(CouponsListItem coupon) {
    final discount = coupon.discount ?? '';
    final maxDiscount = (coupon.maxDiscount ?? '').trim();
    final minDiscount = (coupon.minDiscount ?? '').trim();

    if (coupon.discountType == 1) {
      // percentage
      if (maxDiscount.isNotEmpty && maxDiscount != '0') {
        return '$discount% off up to ${AppStrings.currSymbolIn}$maxDiscount';
      }
      return '$discount% off';
    } else {
      // flat
      if (minDiscount.isNotEmpty && minDiscount != '0') {
        return 'FLAT ${AppStrings.currSymbolIn}$discount off above ${AppStrings.currSymbolIn}$minDiscount';
      }
      return 'FLAT ${AppStrings.currSymbolIn}$discount off';
    }
  }

}