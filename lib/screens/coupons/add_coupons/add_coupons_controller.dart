import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/coupons/CouponsList/coupons_model.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;


class AddCouponsController extends GetxController {
  var showLoader = true.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CouponsListItem? couponsData = Get.arguments;
  Rxn<File> imageFile = Rxn<File>();
  var discountType = "".obs;
  var showDiscountError = false.obs;
  var showImageError = false.obs;
  GetStorage storage = GetStorage();




  TextEditingController couponCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController usageController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController maxDiscountController = TextEditingController();
  TextEditingController minDiscountController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();



  @override
  void onReady() {
    super.onReady();
    checkArguments();
  }


  void checkArguments(){
    if(couponsData != null){
      imageFile.value = null;
      discountType.value = "${couponsData?.discountType ?? ''}";
      couponCodeController.text = couponsData?.couponCode ?? '';
      descriptionController.text = couponsData?.description ?? '';
      usageController.text = "${couponsData?.time ?? ''}";
      discountController.text = "${couponsData?.discount ?? ''}";
      maxDiscountController.text = couponsData?.maxDiscount ?? '';
      minDiscountController.text = couponsData?.minDiscount ?? '';
      startDateController.text = couponsData?.startDate ?? '';
      endDateController.text = couponsData?.endDate ?? '';
    }
    showLoader.value = false;
  }

  void onChangeDiscountType(String type) {
    discountType.value = type;
  }

  Future<void> pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var path = await ImgPickerDialogBox.pickCroppedImagePath();
    if (path != null) {
      File original = File(path);
      File? compressed = await CustomImgPicker.compressTo1MB(original);
      if (compressed != null) {
        imageFile.value = compressed;
      }
    }
  }

  Future<void> startDatePicker(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 7));
    if (pickedDate != null) {
      startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> endDatePicker(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 7));
    if (pickedDate != null) {
      endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }




  void addCouponClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    showDiscountError.value = discountType.trim().isEmpty;
    showImageError.value = imageFile.value == null;
    if((formKey.currentState?.validate() ?? false) &&
        !showDiscountError.value && !showImageError.value) {
      addCouponProcess();
    } else {
      if(formKey.currentContext != null) {
        Scrollable.ensureVisible(
            formKey.currentContext!,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn);
      }
    }
  }

  Future<void> addCouponProcess() async {
    try {
      showLoader.value = true;
        var newFileName = (imageFile.value?.path ?? '').split('/').last;
        if (!newFileName.contains(".")) {
          newFileName = "$newFileName.png";
        }
      final formData = dio.FormData.fromMap({
        "coupon_code": couponCodeController.text.toUpperCase(),
        "description": descriptionController.text.trim(),
        "start_date": startDateController.text.trim(),
        "end_date": endDateController.text.trim(),
        "discount": discountController.text.trim(),
        "discount_type": discountType.value,
        "time": usageController.text.trim(),
        "max_discount": maxDiscountController.text.trim(),
        "min_discount": minDiscountController.text.trim(),
        "image": imageFile.value != null
            ? await dio.MultipartFile.fromFile(imageFile.value?.path ?? '',
            filename: newFileName)
            : null,
      });

      final addCouponResponse = await ApiController().restaurantAddCoupon(formData);
      showLoader.value = false;
      if (addCouponResponse.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "added");
      } else {
        CommonUtils.utils.handleAlertMsg(
           code:  addCouponResponse.responseCode,
           message:  addCouponResponse.msg);
      }
    } catch (e) {
      showLoader.value = false;
      debugPrint("add coupon exception $e");
    }
  }

  void updateCouponClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    showDiscountError.value = discountType.trim().isEmpty;
    showImageError.value = imageFile.value == null && (couponsData?.image ?? '').trim().isEmpty;
    if((formKey.currentState?.validate() ?? false) &&
        !showDiscountError.value && !showImageError.value) {
      updateCouponProcess();
    } else {
      if(formKey.currentContext != null) {
        Scrollable.ensureVisible(
            formKey.currentContext!,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn);
      }
    }
  }

  Future<void> updateCouponProcess() async {
    try {
      showLoader.value = true;
      var newFileName = (imageFile.value?.path ?? '').split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }
      final formData = dio.FormData.fromMap({
        "id": couponsData?.id,
        "coupon_code": couponCodeController.text.toUpperCase(),
        "description": descriptionController.text.trim(),
        "start_date": startDateController.text.trim(),
        "end_date": endDateController.text.trim(),
        "discount": discountController.text.trim(),
        "discount_type": discountType.value,
        "time": usageController.text.trim(),
        "max_discount": maxDiscountController.text.trim(),
        "min_discount": minDiscountController.text.trim(),
        "image": imageFile.value != null
            ? await dio.MultipartFile.fromFile(imageFile.value?.path ?? '',
            filename: newFileName)
            : (couponsData?.image ?? ""),
      });

      final updateCouponResponse = await ApiController().restaurantUpdateCoupon(formData);
      showLoader.value = false;
      if (updateCouponResponse.responseCode == AppStrings.apiSuccess) {
        Get.back(result:  "updated");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
           code:  updateCouponResponse.responseCode,
           message: updateCouponResponse.msg);
      }
    } catch (e) {
      showLoader.value = false;
      debugPrint("update coupon exception $e");
    }
  }


  void deleteCouponClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.alertMsgDeleteCoupon,
      twoButtons: true,
      onConfirm: (){ deleteCouponProcess();},
    ));
  }

  Future<void> deleteCouponProcess() async {
    try {
     showLoader.value = true;
    var deleteCoupon = await  ApiController().restaurantDeleteCoupon("${couponsData?.id}");
    showLoader.value = false;
    if(deleteCoupon.responseCode == AppStrings.apiSuccess) {
      Get.back(result: "deleted");
    } else {
      CommonUtils.utils.handleAlertMsg(
         code:  deleteCoupon.responseCode,
         message:  deleteCoupon.msg);
    }
    } catch (e) {
      showLoader.value = false;
      debugPrint("delete coupon exception $e");
    }
  }



}