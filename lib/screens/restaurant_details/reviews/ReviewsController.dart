import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/repo/CommonRepo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/GetStorageConstants.dart';
import 'ReviewsModel.dart';
class ReviewsController extends GetxController {
  var restaurantReview = [].obs;
  var showLoader = false.obs;

  @override
  void onInit() {
    getRestaurantReviews();
    super.onInit();
  }

  getRestaurantReviews() async {
    showLoader.value = true;
   // var id = Get.arguments;
    var storage = GetStorage();
    var restId = storage.read(GetStorageConstants.RESTAURANT_ID);
    var restaurantReviews = await ApiController().getRestaurantReviews(restId);
    showLoader.value = false;
    if (restaurantReviews.responseCode == 1) {
      RestaurantReviewsModel restReviews = RestaurantReviewsModel.fromJson(
          restaurantReviews.response!.data);
      restaurantReview.clear();
      restaurantReview.value = restReviews.result!;
    }
    else {
      if (restaurantReviews.responseCode == 0 && restaurantReviews.msg.startsWith( "No Data Found")) {
        RestaurantReviewsModel restReviews = RestaurantReviewsModel.fromJson(
            restaurantReviews.response!.data);
        restaurantReview.clear();
        restaurantReview.value = restReviews.result!;
      }
      else {
        CommonUtils.utils.handleApiError(restaurantReviews.responseCode, restaurantReviews.msg);
      }
    }
  }

  Future<void> pullRefresh() async {
    getRestaurantReviews();
  }

  ratingStar(String value) {
    return double.parse(value);
  }



}