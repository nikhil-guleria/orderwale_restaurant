import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../component/custom_dialog_box.dart';
import '../../constant/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../services/commonModels/ProductItemModel.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CheckPermission.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import '../../utils/ImagePicker.dart';
import '../add_product/model/CategoriesModel.dart';
import '../add_product/model/sub_category_model.dart';

class UpdateProductController extends GetxController {
  Items itemDetails;
  String catName;
  String catId;
  String subName;
  String subId;
  UpdateProductController( this.itemDetails, this.catName, this.catId,
      this.subName, this.subId);
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
  var image = "".obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();

  @override
  void onInit() {
    productDetails();
    super.onInit();
  }

  @override
  onClose(){
    super.onClose();
    CommonUtils.utils.statusBarColorTransparent();
  }


  productDetails(){
    productNameController.text = itemDetails.name!;
    itemDescriptionController.text = itemDetails.description!;
    itemDiscountController.text = "${itemDetails.discount!}";
    itemPriceController.text = "${itemDetails.price!}";
    discountType.value = "${itemDetails.discountType}" ;
    foodType.value = "${itemDetails.type}";
    image.value = itemDetails.image!;
    categoryId.value = catId;
    subcategoryId.value = subId;
    subCategoryTitle.value = subName;
    category.value = catName;
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
     }}
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
    var param = {"restaurant_id": restId , "category_id": categoryId.value};
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
       if(categoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Category");
      }  else if(subcategoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Menu");
      } else if(discountType.value.isEmpty && num.parse(itemDiscountController.text.isEmpty? "0" :
      itemDiscountController.text) > 0){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Discount Type");
      } else if(foodType.value.isEmpty){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Food Type");
      }
      if(imageFile.value != "" || image.value != "") {
        updateProduct();
      } else {
        Get.snackbar(AppStrings.alertTitle, "Please Select Image");
      }
    }
  }


  updateProduct() async{
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var newFileName = imageFile.value.split('/').last;
    if (!newFileName.contains(".")) {
      newFileName = "$newFileName.png";}
    showLoader.value = true;
    dio.FormData formData = dio.FormData.fromMap({
      "title": productNameController.text,
      "category_id": categoryId.value,
      "subcategory_id": subcategoryId.value,
      "type": foodType.value,
      "restaurant_id": restaurantId,
      "description": itemDescriptionController.text,
      "discount":  itemDiscountController.text.isEmpty ? "0" : itemDiscountController.text,
      "discount_type": discountType.value.isEmpty ? "0" :  discountType.value,
      "price": itemPriceController.text,
      "image":  imageFile.value != "" ?  await dio.MultipartFile.fromFile(imageFile.value, filename: newFileName)
        : image.value
    });
    print(formData.fields);
    var addProduct = await ApiController().updateProduct(formData , itemDetails.id!);
    showLoader.value = false;
    if (addProduct.responseCode == 1) {
      Get.back(result: "updated");
    }
    else {
      CommonUtils.utils.handleApiError(
          addProduct.responseCode, addProduct.msg);
    }
  }

 void deleteProduct(){
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: delete_product,
      twoButtons: true,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){ Get.back(result: "processDelete");},
      )).then((value) {
      if(value == "processDelete") {
        processDelete();
      }
    });
  }


  processDelete() async {
    showLoader.value = true;
    var delete = await ApiController().deleteProduct(itemDetails.id!);
    showLoader.value = false;
    if (delete.responseCode == 1){
     Get.back(result: "deleted");
    }
    else {
      CommonUtils.utils.handleApiError(
          delete.responseCode, delete.msg);
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