import 'package:flutter/cupertino.dart';
import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'coupons_model.dart';


class CouponsController extends GetxController {

  var showLoader = true.obs;
  var couponsList = <CouponsData>[].obs;
  GetStorage storage = GetStorage();
  //var initialLoad = true.obs;


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
      var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
      var couponsListData = await ApiController().getCouponsList(restId);
      couponsList.clear();
      showLoader.value = false;
        if (couponsListData.responseCode == 1) {
          CouponsModel couponsModel = CouponsModel.fromJson(
              couponsListData.response?.data ?? "");
          couponsList.value = couponsModel.result ?? [];
        }
        else {
          CommonUtils.utils.handleApiError(
              couponsListData.responseCode, couponsListData.msg,
            title: couponsListData.msg == 'No Data Found.' ?
            alert : error
          );
        }
    } catch (e) {
      showLoader.value = false;
      debugPrint("exception coupons --> $e");
    }
  }

  String calculateDiscount(CouponsData coupon) {
    final discount = coupon.discount ?? '';
    final maxDiscount = (coupon.maxDiscount ?? '').trim();
    final minDiscount = (coupon.minDiscount ?? '').trim();

    if (coupon.discountType == 1) {
      // percentage
      if (maxDiscount.isNotEmpty && maxDiscount != '0') {
        return '$discount% off up to $currSymbolIn$maxDiscount';
      }
      return '$discount% off';
    } else {
      // flat
      if (minDiscount.isNotEmpty && minDiscount != '0') {
        return 'FLAT $currSymbolIn$discount off above $currSymbolIn$minDiscount';
      }
      return 'FLAT $currSymbolIn$discount off';
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

  void goToUpdateCoupon(CouponsData coupon){
    Get.toNamed(Routes.ADD_COUPONS, arguments: coupon)?.then((value) {
      if(value == "updated" || value == "deleted") {
        showLoader.value = true;
        getCouponsList();
      }
    });
  }



  void goToAddCoupon(){
    Get.toNamed(Routes.ADD_COUPONS)?.then((value)  {
      if(value == "added") {
        showLoader.value = true;
        getCouponsList();
      }
    });
  }



goToUpdateCouponOld(index){
  var data = CouponsData();
  data.id = couponsList[index].id;
  data.image = couponsList[index].image;
  data.couponCode = couponsList[index].couponCode;
  data.description = couponsList[index].description;
  data.startDate = couponsList[index].startDate;
  data.endDate = couponsList[index].endDate;
  data.discount = couponsList[index].discount;
  data.discountType = couponsList[index].discountType;
  data.time = couponsList[index].time;
  Get.toNamed(Routes.ADD_COUPONS, arguments: data)?.then((value) {
    if(value == "updated" || value == "deleted") {
      showLoader.value = true;
      getCouponsList();
    }

  });

}



}