import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/screens/restaurant_details/menu/restaurant_menu_model.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_model.dart';
import 'package:food_merchant/services/repo/api_controller.dart';
import 'package:food_merchant/utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../services/commonModels/customisation_list_model.dart';
import '../models/item_categories_model.dart';
import '../models/item_subcategories_model.dart';

class AddCustomisedProductController extends GetxController {

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var args = Get.arguments;
  Rxn<File> imageFile = Rxn<File>();
  var menuItem = RestaurantMenuItem().obs;
  var categoryId = "0".obs;
  var category = AppStrings.itemSelectCategory.obs;
  var categoriesList = <ItemCategory>[].obs;
  var subcategoryId = "0".obs;
  var subCategoryTitle = AppStrings.itemSelectMenuTitle.obs;
  var subCategoryList = <ItemSubCategory>[].obs;
  var customisationType = "".obs;
  var customisationTitle = "".obs;
  var customisationList = <CustomisationModel>[].obs;
  var customisationItemsList = <CustomisationItemModel>[].obs;
  var selectedToppingCount = 0.obs;
  var toppingsList = <Toppings>[].obs;
  final formKey = GlobalKey<FormState>();
  var discountType = "".obs;
  var foodType = "".obs;
  var showFoodError = false.obs;
  var showDiscountError = false.obs;




  @override
  void onReady() {
    checkArguments();
    super.onReady();
  }

// checkArguments
  Future<void> checkArguments() async {
    if(args != null) {
      customisationItemsList.clear();
      toppingsList.clear();
      menuItem.value = args["item"];
      customisationItemsList.value = menuItem.value.customisations ?? [];
      await setInitialToppingData();
      customisationType.value = menuItem.value.customisationType ?? "";
      customisationTitle.value = menuItem.value.customisationTitle ?? "";
      itemNameController.text = menuItem.value.name ?? "";
      itemDescriptionController.text = menuItem.value.description ?? "";
      itemDiscountController.text = "${menuItem.value.discount ?? ''}";
      itemPriceController.text = "${menuItem.value.price ?? ''}";
      discountType.value = "${menuItem.value.discountType ?? ''}";
      foodType.value = "${menuItem.value.type ?? ''}";
      categoryId.value = args['category_id'];
      category.value = args['category_name'];
      subcategoryId.value = args['sub_id'];
      subCategoryTitle.value = args['sub_name'];
    }
    initialCustomisationList(customisationList);
    initialLoad.value = false;
  }


  Future<void> setInitialToppingData() async {
    await  getToppingsList();
    var firstList = menuItem.value.toppings ?? [];
    if(toppingsList.isNotEmpty && firstList.isNotEmpty) {
      for (var item1 in firstList) {
        for (var item2 in toppingsList) {
          if (item1.id == item2.id) {
            item2.selected = true;
            break;
          }
        }
      }
      selectedToppingCount.value = toppingsList.where((item) => item.selected == true).length;
    }
  }





  @override
  onClose(){
    super.onClose();
    CommonUtils.utils.statusBarColorTransparent();
  }

  void onChangeDiscountType(String type) {
    discountType.value = type;
  }

  void onChangeFoodType(String type) {
    foodType.value = type;
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



// get item categories list
  Future<void> getCategories() async {
    try {
      showLoader.value = true;
      var categories = await ApiController().restaurantCategories();
      categoriesList.clear();
      showLoader.value = false;
      if (categories.responseCode == AppStrings.apiSuccess) {
        ItemCategoriesModel categoriesModel = ItemCategoriesModel.fromJson(
            categories.response?.data);
        categoriesList.value = categoriesModel.result ?? [];
      }
      else {
        CommonUtils.utils.handleAlertMsg(
           code: categories.responseCode,
           message: categories.msg);
      }
    } catch (e){
      categoriesList.clear();
      showLoader.value = false;
    }
  }


// get item subcategories/menu list
  Future<void> getSubCategories() async {
    try {
      showLoader.value = true;
      var subCategories = await ApiController().restaurantAllSubcategories();
      subCategoryList.clear();
      showLoader.value = false;
      if (subCategories.responseCode == AppStrings.apiSuccess) {
        ItemSubCategoryModel subCategoryModel = ItemSubCategoryModel.fromJson(
            subCategories.response?.data);
        subCategoryList.value = subCategoryModel.result ?? [];
      }
      else {
        CommonUtils.utils.handleAlertMsg(
           code: subCategories.responseCode,
           message: subCategories.msg);
      }
    } catch (e){
      subCategoryList.clear();
      showLoader.value = false;
    }
  }



// add menu click
  void addMenuTap(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.subcategoryTitleScreen, arguments: [categoryId.value])?.then((value) {
      if(value == "added"){
        subCategoryTitle.value = "Select Menu Title";
        subcategoryId.value = "0";
        getSubCategories();
      }
    });
  }

// edit menu click
  void editSubCategoryTap(){
    Get.toNamed(AppRoutes.subcategoryEditScreen, arguments: categoryId.value)?.then((value) {
      subCategoryTitle.value = "Select Menu Title";
      subcategoryId.value = "0";
      getSubCategories();
    });
  }


// change customisation type
   void changeCustomisationType(String value){
      customisationType.value = value;
      customisationTitle.value = value;
   }

// customisation screen click
  void goToCustomisationScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    if(customisationType.value.isNotEmpty) {
      Get.back();
      Get.toNamed(AppRoutes.customisationType, arguments: {
        "type": customisationType.value,
        "title" : customisationTitle.value,
        "list": customisationItemsList})?.then((value) {
         if(value != null){
         customisationItemsList.value = value;
         customisationItemsList.refresh();
         if(customisationItemsList.isNotEmpty){
           itemPriceController.text = "${customisationItemsList.first.price}";
         }}
    });
    } else {
      Get.back();
      Get.snackbar(AppStrings.alertTitle,
          AppStrings.errorCustomisationType, duration: const Duration(seconds: 2));
    }
  }


// editCustomisation items
  void editCustomisationItems(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.customisationType, arguments: {
      "type": customisationType.value,
      "title" : customisationTitle.value,
      "list": customisationItemsList})?.then((value) {
      if(value != null){
        customisationItemsList.value = value;
        customisationItemsList.refresh();
      if(customisationItemsList.isNotEmpty){
        itemPriceController.text = customisationItemsList.first.price ?? '';
      }
      }
    });
  }


// clear customisation items list
 void  clearCustomisationItemList(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.alertMsgClearCustomisationList,
      twoButtons: true,
      onConfirm: (){customisationItemListClearLogic();},
    ));
  }

  Future<void> customisationItemListClearLogic() async {
    if(args != null){
      try {
        showLoader.value = true;
        var customisations = customisationItemsList
            .where((item) => (item.id ?? '').trim().isNotEmpty)
            .map((item) => item.id).toList();
        var param = {
          'ids': customisations.join(','),
        };
        var apiResponse = await ApiController().restaurantDeleteCustomisations(param);
        showLoader.value = false;
        if (apiResponse.responseCode == AppStrings.apiSuccess) {
          customisationItemsList.clear();
          customisationItemsList.refresh();
          itemPriceController.clear();
        } else {
          CommonUtils.utils.handleAlertMsg(
              code: apiResponse.responseCode,
              message: apiResponse.msg);
        }
      } catch(e){
        showLoader.value = false;
      }
    } else {
      customisationItemsList.clear();
      customisationItemsList.refresh();
      itemPriceController.clear();
    }
  }


// fetch  topping list
   Future<void> getToppingsList() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      var toppingsListData = await ApiController().restaurantToppingsList();
      showLoader.value = false;
      if (toppingsListData.responseCode == AppStrings.apiSuccess) {
        ToppingsListModel toppingsListModel = ToppingsListModel.fromJson(
            toppingsListData.response?.data ?? {});
        var list = toppingsListModel.result ?? [];
        if (list.isNotEmpty && toppingsList.isNotEmpty) {
          for (var item1 in toppingsList) {
            for (var item2 in list) {
              if (item1.id == item2.id) {
                item2.selected = item1.selected;
                break;
              }
            }
          }
        }
        toppingsList.value = list;
        toppingsList.refresh();
      }
      else {
        toppingsList.clear();
        CommonUtils.utils.handleAlertMsg(
            code: toppingsListData.responseCode,
            message: toppingsListData.msg);
      }
    } catch (e){
      showLoader.value = false;
      toppingsList.clear();
    }
   }


// add new topping
  Future<void> addNewTopping() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
    Get.toNamed(AppRoutes.addUpdateTopping)?.then((value) {
      if(value == "added") {
        showLoader.value = true;
        getToppingsList();
      }
    });
  }

// submit topping click
  void submitToppingClick(){
    selectedToppingCount.value = 0;
    selectedToppingCount.value = toppingsList.where((item) => item.selected == true).length;
    Get.back();
  }




// check validation
  void addUpdateClick(){
    if(args != null) {
      updateProductValidation();
    } else {
      addProductValidations();
    }
  }


  void addProductValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    showFoodError.value = foodType.value.isEmpty ? true :  false;
    showDiscountError.value = false;
    num discountValue = num.tryParse(itemDiscountController.text) ?? 0;
    if((formKey.currentState?.validate() ?? false)
        && foodType.value.isNotEmpty) {
      if(imageFile.value == null){
        Get.snackbar(AppStrings.alertTitle,
            "Please Add Image", duration: const Duration(seconds: 2));
        return;
      } else if(categoryId.value.trim() == "0" ||
          categoryId.value.trim().isEmpty){
        Get.snackbar(AppStrings.alertTitle,
            "Please Select Category",duration: const Duration(seconds: 2));
        return;
      }  else if(subcategoryId.value.trim() == "0" ||
          subcategoryId.value.trim().isEmpty){
        Get.snackbar(AppStrings.alertTitle,
            "Please Select Menu", duration: const Duration(seconds: 2));
        return;
      } else if(discountType.value.isEmpty &&
          discountValue > 0){
        showDiscountError.value = true;
        return;
      }
      addProduct();
    }
  }

    Future<void> addProduct() async{
    try {
      showLoader.value = true;
      var newFileName = (imageFile.value?.path ?? '').split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }
      final formData = dio.FormData.fromMap({
        "title": itemNameController.text.trim(),
        "category_id": categoryId.value.trim(),
        "subcategory_id": subcategoryId.value.trim(),
        "type": foodType.value.trim(),
        "description": itemDescriptionController.text.trim(),
        "discount": itemDiscountController.text.trim().isEmpty
            ? "0" : itemDiscountController.text.trim(),
        "discount_type": discountType.value.trim().isEmpty
            ? "0" : discountType.value.trim(),
        "price": itemPriceController.text.trim(),
        "customisation_type": customisationItemsList.isNotEmpty ?
        customisationType.value.trim() : "",
        "customisations": customisationItemsList.map((item) => item.toMap()).toList(),
        "topping_ids": toppingsList.where((item) => item.selected == true).map((
            topping) => topping.id).where((id) => id != null).join(', '),
        "image": imageFile.value != null
            ? await dio.MultipartFile.fromFile(imageFile.value?.path ?? '',
            filename: newFileName)
            : null,
      });

      var addProduct = await ApiController().restaurantAddItem(formData);
      showLoader.value = false;
      if (addProduct.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "added");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: addProduct.responseCode,
            message: addProduct.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }
  
  

    void updateProductValidation(){
      FocusManager.instance.primaryFocus?.unfocus();
      foodType.value.isEmpty ? showFoodError.value = true : showFoodError.value = false;
      showDiscountError.value = false;
      num discountValue = num.tryParse(itemDiscountController.text) ?? 0;
      if((formKey.currentState?.validate() ?? false) &&
          foodType.value.isNotEmpty) {
        if(categoryId.value == "0" ||
            categoryId.value.trim().isEmpty){
           Get.snackbar(AppStrings.alertTitle, "Please Select Category", duration: const Duration(seconds: 2));
           return;
        }  else if(subcategoryId.value == "0" ||
            subcategoryId.value.trim().isEmpty){
           Get.snackbar(AppStrings.alertTitle, "Please Select Menu", duration: const Duration(seconds: 2));
           return;
        } else if(discountType.value.isEmpty &&
            discountValue > 0){
           showDiscountError.value = true;
           return;
        }
        if(imageFile.value != null ||
            (menuItem.value.image ?? '').trim().isNotEmpty) {
          updateProduct();
        } else {
          Get.snackbar(AppStrings.alertTitle, "Please Select Image", duration: const Duration(seconds: 2));
        }
      }
    }

    Future<void> updateProduct() async{
    try {
      showLoader.value = true;
      var newFileName = (imageFile.value?.path ?? '').split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }
      final formData = dio.FormData.fromMap({
        "title": itemNameController.text.trim(),
        "category_id": categoryId.value.trim(),
        "subcategory_id": subcategoryId.value.trim(),
        "type": foodType.value.trim(),
        "description": itemDescriptionController.text.trim(),
        "discount": itemDiscountController.text.trim().isEmpty
            ? "0" : itemDiscountController.text.trim(),
        "discount_type": discountType.value.trim().isEmpty
            ? "0" : discountType.value.trim(),
        "price": itemPriceController.text.trim(),
        "customisation_type" : customisationItemsList.isNotEmpty ?
        customisationType.value.trim() : "",
        "customisations" : customisationItemsList.map((item) => item.toMap()).toList(),
        "topping_ids" : toppingsList.where((item) => item.selected == true).map((
            topping) => topping.id).where((id) => id != null).join(', '),
        "image":   imageFile.value != null
            ? await dio.MultipartFile.fromFile(imageFile.value?.path ?? '',
            filename: newFileName)
            : null,
      });
      var addProduct = await ApiController().restaurantUpdateItem(formData,menuItem.value.id ?? '');
      showLoader.value = false;
      if (addProduct.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "updated");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: addProduct.responseCode,
            message: addProduct.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }




  
  
// delete product   
  void deleteProduct(){
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: AppStrings.alertMsgDeleteItem,
      twoButtons: true,
      onConfirm: (){processDelete();},
    ));
  }


  Future<void> processDelete() async {
    try {
      showLoader.value = true;
      var deleteItem = await ApiController().restaurantDeleteItem(menuItem.value.id ?? '');
      showLoader.value = false;
      if (deleteItem.responseCode == AppStrings.apiSuccess) {
        Get.back(result: "deleted");
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: deleteItem.responseCode,
            message: deleteItem.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }

}