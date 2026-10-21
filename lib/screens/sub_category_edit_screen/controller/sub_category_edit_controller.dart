import 'package:food_merchant/routes/app_routes.dart';
import 'package:food_merchant/screens/customised_product/models/item_subcategories_model.dart';
import 'package:get/get.dart';
import '../../../component/custom_dialog_box.dart';
import '../../../constant/app_strings.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';


class SubCategoryEditController extends GetxController {
  var subCategoryList = <ItemSubCategory>[].obs;
  var initialLoad = true.obs;
  var showLoader = false.obs;


  @override
  void onReady() {
    getSubCategories();
    super.onReady();
  }



  Future<void> getSubCategories() async {
    try {
      var subCategories = await ApiController().restaurantAllSubcategories();
      subCategoryList.clear();
      showLoader.value = false;
      initialLoad.value = false;
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
      initialLoad.value = false;
    }
  }


  void editButtonClick(int index){
  Get.toNamed(AppRoutes.subcategoryTitleScreen,
      arguments: [subCategoryList[index].categoryId,
                  subCategoryList[index].title,
                  subCategoryList[index].subcategoryId]);
  }

 void deleteButtonClick(int index){
      Get.dialog(showDialogBox(title: AppStrings.subcategoryDelete,
        message: AppStrings.subcategoryDeleteDesc,
        twoButtons: true,
        onConfirm: (){processDelete(index);},
       ));
  }

  Future<void> processDelete(int index) async {
    try {
      showLoader.value = true;
      var apiResponse = await ApiController().restaurantDeleteSubcategory(
          "${subCategoryList[index].subcategoryId}");
      showLoader.value = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        subCategoryList.removeAt(index);
        subCategoryList.refresh();
        if (subCategoryList.isEmpty) {
          Get.back();
        }
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }


}