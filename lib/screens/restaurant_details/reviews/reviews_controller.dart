import 'package:food_merchant/constant/app_strings.dart';
import 'package:get/get.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';
import 'reviews_model.dart';


class ReviewsController extends GetxController {
  var reviewsList = <ReviewData>[].obs;
  var initialLoad = true.obs;
  var showLoader = false.obs;
  var refreshLoad = false.obs;
  var lastPage = 1.obs;
  var currentPage = 1.obs;

  //ScrollController scrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    currentPage.value = 1;
    getRestaurantReviews(currentPage.value);
    //getRestaurantReviewsOnScroll();
  }





  Future<void> getRestaurantReviews(int page) async {
    try {
      var apiResponse = await ApiController().restaurantAllReviews();
      refreshLoad.value = false;
      showLoader.value = false;
      initialLoad.value = false;
      if (apiResponse.responseCode == AppStrings.apiSuccess) {
        RestaurantReviewsModel reviewsModel = RestaurantReviewsModel.fromJson(apiResponse.response?.data ?? {});
        if (page == 1) {
          reviewsList.clear();
        }
        reviewsList.addAll(reviewsModel.result ?? []);
        lastPage.value = reviewsModel.lastPage ?? 1;
        currentPage.value = reviewsModel.currentPage ?? 1;
      }
      else {
        if(apiResponse.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        if(apiResponse.responseCode == 0){
          reviewsList.clear();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
            code: apiResponse.responseCode,
            message: apiResponse.msg);
      }
    } catch (e){
      refreshLoad.value = false;
      showLoader.value = false;
      initialLoad.value = false;
      reviewsList.clear();
    }
  }


  void getRestaurantReviewsOnScroll(){
   /* scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (showLoader.value == false) {
          if (currentPage.value < lastPage.value) {
            showLoader.value = true;
            getRestaurantReviews(currentPage.value + 1);
          }
        }
      }
    });*/
  }

  Future<void> pullRefresh() async {
    refreshLoad.value = true;
    currentPage.value = 1;
    lastPage.value = 1;
    getRestaurantReviews(currentPage.value);
  }




}