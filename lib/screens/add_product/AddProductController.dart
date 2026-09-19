import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CheckPermission.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import '../../utils/ImagePicker.dart';
import 'model/CategoriesModel.dart';
import 'package:dio/dio.dart' as dio;
import 'model/sub_category_model.dart';


class AddProductController extends GetxController {
  var storage = GetStorage();
  var discountType = "".obs;
  var foodType = "".obs;
  var category = "Select Category".obs;
  var categoryId = "0".obs;
  var categoriesList = <CategoryResult>[].obs;
  var subCategoryTitle = "Select Menu Title".obs;
  var subcategoryId = "0".obs;
  var subCategoryList = <SubCategoryResult>[].obs;
  var showLoader = false.obs;
  final picker = ImagePicker();
  var imageFile = "".obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController menuNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();

  @override
  onClose(){
    super.onClose();
    CommonUtils.utils.statusBarColorTransparent();
  }

  onChangeDiscountType(String type) {
    discountType.value = type;
  }

  onChangeFoodType(String type) {
    foodType.value = type;
  }
  getFromGallery()  async {
    var result = await RunTimePermissions.permissions.checkPermissions();
    if(result) {
      var path = await ImgPicker.pickImage("Gallery");
      if (path != null) {
        imageFile.value = path;
      }
    }
  }


  getFromCamera() async {
    var result = await RunTimePermissions.permissions.checkPermissions();
    if(result) {
      var path = await ImgPicker.pickImage("Camera");
      if (path != null) {
        imageFile.value = path;
      }
    }
  }



  getCategories() async {
    showLoader.value = true;
    var categories = await ApiController().getAllCategories();
    showLoader.value = false;
    if (categories.responseCode == 1) {
      CategoriesModel categoriesModel = CategoriesModel.fromJson(
          categories.response!.data);
      categoriesList.value = categoriesModel.result!;
    }
    else {
      CommonUtils.utils.handleApiError(
          categories.responseCode, categories.msg);
    }
  }

  getSubCategories() async {
    showLoader.value = true;
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {"restaurant_id": restId ,  "category_id": categoryId.value};
    var subCategories = await ApiController().getAllSubCategories(param);
    showLoader.value = false;
    if (subCategories.responseCode == 1) {
      SubCategoryModel subCategoryModel = SubCategoryModel.fromJson(
          subCategories.response!.data);
      subCategoryList.clear();
      subCategoryList.value = subCategoryModel.result!;
    }
    else {
      CommonUtils.utils.handleApiError(
          subCategories.responseCode, subCategories.msg);
    }
  }



  checkValidation(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      if(imageFile.value.isEmpty){
        return  Get.snackbar(AppStrings.alertTitle, "Please Add Image");
      } else if(categoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Category");
      }  else if(subcategoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Menu");
      } else if(discountType.value.isEmpty && num.parse(itemDiscountController.text.isEmpty? "0" :
      itemDiscountController.text) > 0){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Discount Type");
      } else if(foodType.value.isEmpty){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Food Type");
      }
      addProduct();
    }
  }
  uploadImg(var imagePath) {
    final bytes = Io.File(imagePath).readAsBytesSync();
    return  base64Encode(bytes);
  }

  addProduct() async{
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
   // var imageString = await uploadImg(imageFile.value) ;
    var newFileName = imageFile.value.split('/').last;
    if (!newFileName.contains(".")) {
      newFileName = "$newFileName.png";}
    showLoader.value = true;
    dio.FormData formData = dio.FormData.fromMap({
      "title": productNameController.text,
      "category_id": categoryId.value,
      "subcategory_id": subcategoryId.value,
      "type": foodType.value,
      "restaurant_id": restId,
      "description": itemDescriptionController.text,
      "discount": itemDiscountController.text.isEmpty ? "0" : itemDiscountController.text,
      "discount_type": discountType.value.isEmpty ? "0" :  discountType.value,
      "price": itemPriceController.text,
      "image":   await dio.MultipartFile.fromFile(imageFile.value, filename: newFileName)
    });

    print(formData.fields);
    var addProduct = await ApiController().addNewProduct(formData);
    showLoader.value = false;
    if (addProduct.responseCode == 1) {
      Get.back(result: "added");
    }
    else {
      CommonUtils.utils.handleApiError(
          addProduct.responseCode, addProduct.msg);
    }
  }




    addMenuTap(){
      FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.SUBCATEGORY_TITLE_SCREEN, arguments: [categoryId.value])?.then((value) {
     if(value == "added"){
       subCategoryTitle.value = "Select Menu Title";
       subcategoryId.value = "0";
       getSubCategories();
     }
    });
    }

    editSubCategoryTap(){
    Get.toNamed(AppRoutes.SUBCATEGORY_EDIT_SCREEN, arguments: categoryId.value)?.then((value) {
      subCategoryTitle.value = "Select Menu Title";
      subcategoryId.value = "0";
      getSubCategories();
    });
    }




}