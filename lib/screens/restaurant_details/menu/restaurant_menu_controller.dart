import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';
import 'restaurant_menu_model.dart';



class RestaurantMenuController extends GetxController {
  var itemsList = <RestaurantMenuSubcategories>[].obs;
  var showLoader = false.obs;
  var initialLoad = true.obs;

  @override
  void onReady() {
    getItemsList();
    super.onReady();
  }



  Future<void> pullRefresh() async {
    showLoader.value = true;
    getItemsList(loader: false);
  }



  Future<void> getItemsList({bool loader = true}) async {
    try {
      if(loader){
        initialLoad.value = true;}
      final apiResponse = await ApiController().restaurantItems();
      showLoader.value = false;
      initialLoad.value = false;
      itemsList.clear();
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        final itemsModel = RestaurantMenuModel.fromJson(apiResponse.response?.data ?? {});
        itemsList.value = itemsModel.result?.subcategories ?? [];
      } else {
        if(apiResponse.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg,
          );
      }
    } catch (e) {
      itemsList.clear();
      showLoader.value = false;
      initialLoad.value = false;
    }
  }


  String getDiscountedPriceText({num? basePrice, num? discount, int? discountType}) {
    final double price = double.tryParse("$basePrice") ?? 0;
    final double disc = double.tryParse("$discount") ?? 0;

    final double discountedValue = discountType == 1
        ? price - (price * disc / 100)
        : price - disc;

    final int rounded = int.parse(discountedValue.toStringAsFixed(0));

    if (rounded <= 0) {
      return "${AppStrings.currSymbolIn}0";
    }

    final num formattedValue = num.tryParse(discountedValue.toStringAsFixed(2)) ?? 0;
    return "${AppStrings.currSymbolIn}${CommonUtils.utils.formatNumber(formattedValue)}";
  }



  Future<void> changeItemAvailability({required bool isAvailable,
    required int index2, required int index3}) async {
    try {
      var productAvailability = isAvailable ? 1 : 0;
      itemsList[index2].items?[index3].status = isAvailable ? 1 : 0;
      itemsList.refresh();
      var param = {
        "status": productAvailability,
        "product_id": itemsList[index2].items?[index3].id
      };
      var apiResponse = await ApiController().restaurantItemAvailability(param);
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        itemsList[index2].items?[index3].status = isAvailable ? 1 : 0;
        itemsList.refresh();
      }
      else {
        itemsList[index2].items?[index3].status = isAvailable ? 0 : 1;
        itemsList.refresh();
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg,
          );
      }
    } catch (e){
      itemsList[index2].items?[index3].status = isAvailable ? 0 : 1;
      itemsList.refresh();
    }
  }


     void updateProduct({required int sub, required int item}){
       Get.toNamed(AppRoutes.addCustomisedProduct, arguments: {
         "item" : itemsList[sub].items?[item],
         "category_name": itemsList[sub].items?[item].categoryName ?? "",
         "category_id": itemsList[sub].items?[item].categoryId ?? "0",
         "sub_name":  itemsList[sub].title ?? "",
         "sub_id": "${itemsList[sub].id ?? '0'}",
       })?.then((value) {
         if(value == "updated" || value == "deleted") {
           pullRefresh();
         }
         });
     }

     void addNewProduct(){
       Get.toNamed(AppRoutes.addCustomisedProduct)?.then((value) {
         if(value == "added") {
           pullRefresh();
         }
       });
     }


   }