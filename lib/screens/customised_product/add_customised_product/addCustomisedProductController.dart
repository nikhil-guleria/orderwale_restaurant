import 'package:flutter/material.dart';
import 'package:food_merchant/component/custom_dialog_box.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_model.dart';
import 'package:food_merchant/services/commonModels/customised_product_model.dart';
import 'package:food_merchant/services/repo/CommonRepo.dart';
import 'package:food_merchant/utils/CheckPermission.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:food_merchant/utils/ImagePicker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import '../../../services/commonModels/customisation_list_model.dart';
import '../models/item_categories_model.dart';
import '../models/item_subcategories_model.dart';

class AddCustomisedProductController extends GetxController {
  TextEditingController productNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();
  var showLoader = false.obs;
  var initialLoad = true.obs;
  var args = Get.arguments;
  var storage = GetStorage();
  final formKey = GlobalKey<FormState>();
  var imageFile = "".obs;
  var image = "".obs;
  var categoriesList = <ItemCategory>[].obs;
  var category = "Select Category".obs;
  var categoryId = "0".obs;
  var subCategoryList = <ItemSubCategory>[].obs;
  var subCategoryTitle = "Select Menu Title".obs;
  var subcategoryId = "0".obs;

  var customisationList = <CustomisationModel>[].obs;
  var customisationType = "".obs;
  var customisationTitle = "".obs;
  var customisationItemsList = <CustomisationItemModel>[].obs;
  var toppingsList = <Toppings>[].obs;
  var selectedToppingCount = 0.obs;
  var discountType = "".obs;
  var foodType = "".obs;
  var customisedProduct = CustomisedItems().obs;

  var showFoodError = false.obs;
  var showDiscountError = false.obs;




  @override
  void onReady() {
    checkArguments();
    super.onReady();
  }

// checkArguments
  checkArguments() async {
    if(args != null) {
      customisationItemsList.clear();
      toppingsList.clear();
      customisedProduct.value = args["item"];
      customisationItemsList.value = customisedProduct.value.customisations ?? [];
      await setInitialToppingData();
      customisationType.value = customisedProduct.value.customisationType ?? "";
      customisationTitle.value = customisedProduct.value.customisationTitle ?? "";
      productNameController.text = customisedProduct.value.name ?? "";
      itemDescriptionController.text = customisedProduct.value.description ?? "";
      itemDiscountController.text = customisedProduct.value.discount != null ?
      customisedProduct.value.discount.toString() : "" ;
      itemPriceController.text = customisedProduct.value.price != null ?
      customisedProduct.value.price.toString() : "" ;
      discountType.value = customisedProduct.value.discountType != null ?
      customisedProduct.value.discountType.toString() : "" ;
      foodType.value = customisedProduct.value.type != null ?
      customisedProduct.value.type.toString() : "" ;
      image.value = customisedProduct.value.image ?? "";
      categoryId.value = args['category_id'];
      category.value = args['category_name'];
      subcategoryId.value = args['sub_id'];
      subCategoryTitle.value = args['sub_name'];
    }
    initialCustomisationList(customisationList);
    initialLoad.value = false;
  }


  setInitialToppingData() async {
    await  getToppingsList();
    var firstList = customisedProduct.value.toppings ?? [];
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

  onChangeDiscountType(String type) {
    discountType.value = type;
  }

  onChangeFoodType(String type) {
    foodType.value = type;
  }



// select item image
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



// get item categories list
  getCategories() async {
    showLoader.value = true;
    var categories = await ApiController().getAllCategories();
    showLoader.value = false;
    if (categories.responseCode == 1) {
      ItemCategoriesModel categoriesModel = ItemCategoriesModel.fromJson(
          categories.response!.data);
      categoriesList.clear();
      categoriesList.value = categoriesModel.result!;
    }
    else {
      categoriesList.clear();
      CommonUtils.utils.handleApiError(
          categories.responseCode, categories.msg);
    }
  }



// get item subcategories/menu list
  getSubCategories() async {
    showLoader.value = true;
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {"restaurant_id": restId};
    var subCategories = await ApiController().getAllSubCategories(param);
    showLoader.value = false;
    if (subCategories.responseCode == 1) {
      ItemSubCategoryModel subCategoryModel = ItemSubCategoryModel.fromJson(
          subCategories.response!.data);
      subCategoryList.clear();
      subCategoryList.value = subCategoryModel.result!;
    }
    else {
      subCategoryList.clear();
      CommonUtils.utils.handleApiError(
          subCategories.responseCode, subCategories.msg);
    }
  }



// add menu click
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

// edit menu click
  editSubCategoryTap(){
    Get.toNamed(AppRoutes.SUBCATEGORY_EDIT_SCREEN, arguments: categoryId.value)?.then((value) {
      subCategoryTitle.value = "Select Menu Title";
      subcategoryId.value = "0";
      getSubCategories();
    });
  }


// change customisation type
   changeCustomisationType(value){
      customisationType.value = value;
      customisationTitle.value = value;
   }

// customisation screen click
  goToCustomisationScreen() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(customisationType.value.isNotEmpty) {
      Get.back();
      Get.toNamed(AppRoutes.customisationType, arguments: {"type": customisationType.value,
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
      Get.snackbar("Alert", "Please Select Customisation Type", duration: const Duration(seconds: 2));
    }
  }


// editCustomisation items
  editCustomisationItems(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.customisationType, arguments: {"type": customisationType.value,
      "title" : customisationTitle.value,
      "list": customisationItemsList})?.then((value) {
      if(value != null){
        customisationItemsList.value = value;
        customisationItemsList.refresh();
      if(customisationItemsList.isNotEmpty){
        itemPriceController.text = "${customisationItemsList.first.price}";
      }
      }
    });
  }


// clear customisation items list
 void  clearCustomisationItemList(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(showDialogBox(title: AppStrings.alertTitle,
      message: "Are you really want to delete this list.",
      twoButtons: true,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){ Get.back(result: "delete");},
    )).then((value) {
      if(value == "delete"){
        customisationItemListClearLogic();
      }
    });
  }

  customisationItemListClearLogic() async {
    if(args != null){
      showLoader.value = true;
      var customisations = customisationItemsList
          .map((item) => item.id.toString())
          .toList();
      var  param = {
        'ids': customisations.toString().substring(1,customisations.toString().length -1),
      };
      var apiResponse = await ApiController().deleteCustomisations(param);
      showLoader.value = false;
      if (apiResponse.responseCode == 1) {
        customisationItemsList.clear();
        customisationItemsList.refresh();
        itemPriceController.clear();
      } else {
        CommonUtils.utils.handleApiError(
            apiResponse.responseCode, apiResponse.msg);
      }
    } else {
      customisationItemsList.clear();
      customisationItemsList.refresh();
      itemPriceController.clear();
    }
  }


// fetch  topping list
   getToppingsList() async {
     FocusManager.instance.primaryFocus?.unfocus();
     var storage = GetStorage();
     var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
     var toppingsListData = await ApiController().getToppingsList(restId);
     showLoader.value = false;
     if (toppingsListData.responseCode == 1) {
       ToppingsListModel toppingsListModel = ToppingsListModel.fromJson(
           toppingsListData.response!.data);
       var list = toppingsListModel.result!;
       if(list.isNotEmpty && toppingsList.isNotEmpty) {
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
       CommonUtils.utils.handleApiError(
           toppingsListData.responseCode, toppingsListData.msg);
     }
   }


// add new topping
  addNewTopping() async {
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
  submitToppingClick(){
    selectedToppingCount.value = 0;
    selectedToppingCount.value = toppingsList.where((item) => item.selected == true).length;
    Get.back();
  }




// check validation
  addUpdateClick(){
    if(args != null) {
      updateProductValidation();
    } else {
      addProductValidations();
    }
  }


  addProductValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    foodType.value.isEmpty ? showFoodError.value = true : showFoodError.value = false;
    showDiscountError.value = false;
    if(formKey.currentState!.validate() && foodType.value.isNotEmpty) {
      if(imageFile.value.isEmpty){
        return  Get.snackbar(AppStrings.alertTitle, "Please Add Image", duration: const Duration(seconds: 2));
      } else if(categoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Category",duration: const Duration(seconds: 2));
      }  else if(subcategoryId.value == "0"){
        return Get.snackbar(AppStrings.alertTitle, "Please Select Menu", duration: const Duration(seconds: 2));
      } else if(discountType.value.isEmpty && num.parse(itemDiscountController.text.isEmpty? "0" :
      itemDiscountController.text) > 0){
        return showDiscountError.value = true;
      }
      addProduct();
    }
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
      "customisation_type" : customisationItemsList.isNotEmpty ? customisationType.value : "",
      "customisations" : customisationItemsList.map((item) => item.toMap()).toList(),
      "topping_ids" : toppingsList.where((item) => item.selected == true).map((topping) => topping.id).where((id) => id != null).join(', '),
      "image":   await dio.MultipartFile.fromFile(imageFile.value, filename: newFileName)
    });

    var addProduct = await ApiController().addCustomisedProduct(formData);
    showLoader.value = false;
    if (addProduct.responseCode == 1) {
      Get.back(result: "added");
    }
    else {
      CommonUtils.utils.handleApiError(
          addProduct.responseCode, addProduct.msg);
    }
  }
  
  

    updateProductValidation(){
      FocusManager.instance.primaryFocus?.unfocus();
      foodType.value.isEmpty ? showFoodError.value = true : showFoodError.value = false;
      showDiscountError.value = false;
      if(formKey.currentState!.validate() && foodType.value.isNotEmpty) {
        if(categoryId.value == "0"){
          return Get.snackbar(AppStrings.alertTitle, "Please Select Category");
        }  else if(subcategoryId.value == "0"){
          return Get.snackbar(AppStrings.alertTitle, "Please Select Menu");
        } else if(discountType.value.isEmpty && num.parse(itemDiscountController.text.isEmpty? "0" :
        itemDiscountController.text) > 0){
          return showDiscountError.value = true;
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
        "discount": itemDiscountController.text.isEmpty ? "0" : itemDiscountController.text,
        "discount_type": discountType.value.isEmpty ? "0" :  discountType.value,
        "price": itemPriceController.text,
        "customisation_type" : customisationItemsList.isNotEmpty ? customisationType.value : "",
        "customisations" : customisationItemsList.map((item) => item.toMap()).toList(),
        "topping_ids" : toppingsList.where((item) => item.selected == true).map((topping) => topping.id).where((id) => id != null).join(', '),
        "image":  imageFile.value != "" ?  await dio.MultipartFile.fromFile(imageFile.value, filename: newFileName)
            : image.value
      });
      var addProduct = await ApiController().updateCustomisedProduct(formData , customisedProduct.value.id!);
      showLoader.value = false;
      if (addProduct.responseCode == 1) {
        Get.back(result: "updated");
      }
      else {
        CommonUtils.utils.handleApiError(
            addProduct.responseCode, addProduct.msg);
      }
    }




  
  
// delete product   
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
    var delete = await ApiController().deleteProduct(customisedProduct.value.id!);
    showLoader.value = false;
    if (delete.responseCode == 1){
      Get.back(result: "deleted");
    }
    else {
      CommonUtils.utils.handleApiError(
          delete.responseCode, delete.msg);
    }
  }

}