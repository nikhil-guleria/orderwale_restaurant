
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import '../home_model/RestaurantListModel.dart';

class HomeController extends GetxController {
  var restaurantsList = [].obs;
  var showLoader = false.obs;
  @override
  void onInit() {
    myRestaurantList();
    super.onInit();
  }

  myRestaurantList() async {

    showLoader.value = true;
    var storage = GetStorage();
    var userData = storage.read(GetStorageConstants.LOGIN_DATA);
    var param = {
      "owner_id": "${userData["id"]}",
    };
    var userModel = await ApiController().getRestaurantList(param);
    showLoader.value = false;
    if (userModel.responseCode == 1) {
      RestaurantListModel restaurantList = RestaurantListModel.fromJson(userModel.response!.data);
      restaurantsList.clear();
      restaurantsList.value = restaurantList.result!;
  }
    else {
      CommonUtils.utils.handleApiError(userModel.responseCode, userModel.msg);
    }
  }
  Future<void> pullRefresh() async {

    myRestaurantList();
  }
onTap(String id){
  Get.toNamed(AppRoutes.RESTAURANT_DETAILS,arguments: id)?.then((value) {
    myRestaurantList();
});
      }
}
