import 'package:food_merchant/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../component/custom_dialog_box.dart';
import '../../../constant/app_strings.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import '../../add_product/model/sub_category_model.dart';

class SubCategoryEditController extends GetxController {
  var subCategoryList = <SubCategoryResult>[].obs;
  var initialLoad = true.obs;
  var showLoader = false.obs;
  var storage = GetStorage();
  var arguments = Get.arguments;


  @override
  void onInit() {
    getInitialList();
    super.onInit();
  }

  getInitialList() async {
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var param = {"restaurant_id": restId, "category_id": arguments ?? "0"};
    var subCategories = await ApiController().getAllSubCategories(param);
    showLoader.value = false;
    initialLoad.value = false;
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


  editButtonClick(index){
  Get.toNamed(AppRoutes.SUBCATEGORY_TITLE_SCREEN,
      arguments: [subCategoryList[index].categoryId,
                  subCategoryList[index].title,
                  subCategoryList[index].subcategoryId]);
  }

 void deleteButtonClick(index){
      Get.dialog(showDialogBox(title: subCategoryDelete,
        message: subCategoryDeleteDesc,
        twoButtons: true,
        onCancel: () {
          Get.back();
        },
        onConfirm: (){Get.back(result: "delete");},
       )).then((value) {
        if(value == "delete"){
          processDelete(index);
        }
      });
  }

  processDelete(index) async {
    showLoader.value  = true;
    var apiResponse = await ApiController().deleteSubCategory("${subCategoryList[index].subcategoryId}");
    showLoader.value = false;
    if(apiResponse.responseCode == 1){
      subCategoryList.removeAt(index);
      subCategoryList.refresh();
      if(subCategoryList.isEmpty){
        Get.back();
      }
    } else {
      CommonUtils.utils.handleApiError(
          apiResponse.responseCode, apiResponse.msg);
    }
  }


}