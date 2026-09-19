import 'package:food_merchant/services/commonModels/customised_product_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_routes.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';



class RestaurantMenuController extends GetxController {
  var productDetails = <CustomisedSubcategories>[].obs;
  var showLoader = false.obs;
  var initialLoad = true.obs;

  @override
  void onInit() {
    getInitialData();
    super.onInit();
  }



  stringToInt(String value){
    return int.parse(value);
  }

  Future<void> pullRefresh() async {
    getInitialData();
  }


  getInitialData() async{
   showLoader.value = true;
    var storage = GetStorage();
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var restaurantMenu = await ApiController().getCustomisedRestaurantMenu(restaurantId);
    showLoader.value = false;
    initialLoad.value = false;
     if (restaurantMenu.responseCode == 1){
       productDetails.clear();
       CustomisedProductModel data1 = CustomisedProductModel.fromJson(restaurantMenu.response!.data);
       productDetails.value = data1.result!.subCategories!;
      }
      else {
      CommonUtils.utils.handleApiError(restaurantMenu.responseCode, restaurantMenu.msg);
       }
       }



     changeProductAvailability(bool isAvailable, int index2, int index3) async {
       var productAvailability = isAvailable ? 1 : 0;
       var param = {
         "status": productAvailability,
         "product_id": "${productDetails[index2].items?[index3].id}"
       };
       var result = await ApiController().changeProductAvailability(param);
       if (result.responseCode == 1) {
         productDetails[index2].items?[index3].status = isAvailable ? 1:0;
         productDetails.refresh();
       }
       else {
         CommonUtils.utils.handleApiError(result.responseCode, result.msg);
       }
     }


     updateProduct({sub, item}){
       Get.toNamed(AppRoutes.addCustomisedProduct, arguments: {
         "item" : productDetails[sub].items![item],
         "category_name": productDetails[sub].items![item].categoryName.toString(),
         "category_id": productDetails[sub].items![item].categoryId.toString(),
         "sub_name":  productDetails[sub].title.toString(),
         "sub_id": productDetails[sub].id.toString(),
       })?.then((value) {
         if(value == "updated" || value == "deleted") {
           getInitialData();
         }
         });
    /*   Get.to(() => UpdateProduct(
         details: productDetails[cat].subcategories![sub].items![item],
         catName: productDetails[cat].categoryName!,
         catId: "${productDetails[cat].categoryId}",
         subName: productDetails[cat].subcategories![sub].title!,
         subId: "${productDetails[cat].subcategories![sub].id}",

       ))?.then((value) {
         if(value == "updated" || value == "deleted") {
           getInitialData();
         }
       });*/
     }

     addNewProduct(){
       Get.toNamed(AppRoutes.addCustomisedProduct)?.then((value) {
         if(value == "added") {
           getInitialData();
         }
       });
     }


   }