
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import '../../component/DialogBox.dart';
import '../../constant/string_constants.dart';
import '../home/home_model/RestaurantListModel.dart';

class SelectRestaurantController extends GetxController {

  var restaurantsList = [].obs;
 /// var restaurantsList = [].obs;

  var initialLoad = true.obs;
  var showLoader = false.obs;
  var currentIndex = 0.obs;
  @override
  void onInit() {
    restaurantList();
    super.onInit();
  }

  restaurantList() async {
    var arguments = Get.arguments;
      if(arguments != null){
        initialLoad.value = false;
        restaurantsList.value = arguments;
      }
      else {
        showLoader.value = true;
        var storage = GetStorage();
        var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
        var param = {
          "owner_id": "${ownerId["id"]}",
        };
        var userModel = await ApiController().getRestaurantList(param);
        showLoader.value = false;
        initialLoad.value = false;
        if (userModel.responseCode == 1) {
          RestaurantListModel restaurantList = RestaurantListModel.fromJson(
              userModel.response!.data);
          storage.write(GetStorageConstants.RESTAURANTS_COUNT, restaurantList.result!.length);
          restaurantsList.clear();
          restaurantsList.value = restaurantList.result!;
          initialIndex();
        }
        else {
          CommonUtils.utils.handleApiError(
              userModel.responseCode, userModel.msg);
        }
      }
  }
  Future<void> pullRefresh() async {
    restaurantList();
  }
  submitButton(){
    var storage = GetStorage();
    LatLng latLng = LatLng(double.parse(restaurantsList[currentIndex.value].latitude),
        double.parse(restaurantsList[currentIndex.value].longitude));
    storage.write(GetStorageConstants.RESTAURANT_SELECTED, true);
    storage.write(GetStorageConstants.RESTAURANT_ID, restaurantsList[currentIndex.value].id!);
    storage.write(GetStorageConstants.REST_NAME, restaurantsList[currentIndex.value].name!);
    storage.write(GetStorageConstants.RESTAURANT_LATLNG, latLng);
    storage.write(GetStorageConstants.GLOBAL_ID, currentIndex.value);
    Get.offAllNamed(Routes.DASHBOARD);
        /*?.then((value) {
      restaurantList();
    });*/
  }

  selectRestaurant(index){
      currentIndex.value = index;
      restaurantsList.refresh();
  }


  initialIndex(){
    var storage = GetStorage();
    var restaurantId = storage.read(GetStorageConstants.RESTAURANT_ID);
    if(restaurantId != null) {
      currentIndex.value =
          restaurantsList.indexWhere((item) => item.id == restaurantId);
    }
    else {
      currentIndex.value = 0;
    }
  }




  processLogout(){
    var storage = GetStorage();
    storage.remove(GetStorageConstants.LOGIN_DATA);
    storage.remove(GetStorageConstants.IS_LOGGED);
    storage.remove(GetStorageConstants.RESTAURANT_ID);
    storage.remove(GetStorageConstants.REST_NAME);
    storage.remove(GetStorageConstants.RESTAURANT_SELECTED);
    storage.remove(GetStorageConstants.RESTAURANTS_COUNT);
    storage.remove(GetStorageConstants.GLOBAL_ID);
    storage.remove(GetStorageConstants.RESTAURANT_LATLNG);
    Get.offAllNamed(Routes.USER_LOGIN);
  }
  logOut() {
    Get.dialog(showDialogBox(title: settings_logout,
      message: settings_logout_dialog_middle_text,
      twoButtons: true,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){processLogout();}));
  }

}
