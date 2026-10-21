import 'package:dio/dio.dart';
import 'package:food_merchant/services/api/api_hitter.dart';
import 'package:food_merchant/services/base/base_repository.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import '../api/api_endpoint.dart';


class ApiController extends BaseRepository {

  // web register restaurant
  Future<ApiResponse> webRestaurantRegistration(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.webRestaurantRegistration , data: param);
    return apiResponse;
  }

  // web states list
  Future<ApiResponse> webRestaurantGetAllStates(String countryId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.webRegRestaurantStates + countryId);
    return apiResponse;
  }

  // web cities list
  Future<ApiResponse> webRestaurantGetAllCities(String stateId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.webRegRestaurantCities + stateId);
    return apiResponse;
  }

  // forget password
  Future<ApiResponse> forgotPassword(Map<String, String> email) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUserForgotPassword, data: email);
    return apiResponse;
  }

  // restaurant user app login
  Future<ApiResponse> restaurantUserAppLogin (Map<String, String> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUserAppLogin, data: param);
    return apiResponse;
  }


//--------------------------------------------------------------------------
//-------------------------------> token api's <-----------------------------
//---------------------------------------------------------------------------


  Map<String, dynamic> restaurantHeaders = {
    "Authorization": "Bearer ${StorageUtils.utils.restaurantUserToken}"
  };

  // restaurant user app logout
  Future<ApiResponse> restaurantUserLogout() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantUserAppLogoutAll , headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant dashboard orders
  Future<ApiResponse> restaurantDashboardOrders() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDashboardOrders , headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant change availability
  Future<ApiResponse> restaurantChangeAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantChangeAvailability , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant accept-decline order
  Future<ApiResponse> restaurantAcceptDeclineOrder(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAcceptDeclineOrder , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant order details
  Future<ApiResponse> restaurantOrderDetails(String orderId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantOrderDetails + orderId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant orders page
  Future<ApiResponse> restaurantOrdersPage(Map<String, dynamic> param, int page) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse("${ApiEndpoint.restaurantOrdersPage}$page", data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant user info
  Future<ApiResponse> restaurantUserInfo() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantUserInfo , headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update user name
  Future<ApiResponse> restaurantUpdateUserName(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUserNameUpdate , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant sales report
  Future<ApiResponse> restaurantSalesReport(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantSalesReport ,headers: restaurantHeaders, data: param);
    return apiResponse;
  }

  // restaurant subscription order
  Future<ApiResponse> restaurantSubscriptionOrder(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantSubscriptionOrder , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // request for payment
  Future<ApiResponse> restaurantWithdrawalRequest(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantWithdrawalRequest , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // pay admin charges
  Future<ApiResponse> restaurantClearBalance(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantClearBalance , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // verify cash free order
  Future<ApiResponse> restaurantVerifyCashFreeOrder(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantCashFreeVerifyOrder , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant change user password
  Future<ApiResponse> restaurantChangeUserPassword(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantChangeUserPassword , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant help & support
  Future<ApiResponse> restaurantHelpAndSupport(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantHelpSupport,isFormData: true, formData: formData, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant delivery area
  Future<ApiResponse> restaurantDeliveryArea() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDeliveryArea ,headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update delivery area
  Future<ApiResponse> restaurantUpdateDeliveryArea(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUpdateDeliveryArea , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant toppings list
  Future<ApiResponse> restaurantToppingsList() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantToppings, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant add new topping
  Future<ApiResponse> restaurantAddTopping(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAddUpdateTopping , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update topping
  Future<ApiResponse> restaurantUpdateTopping(Map<String, dynamic> param, String toppingId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse("${ApiEndpoint.restaurantAddUpdateTopping}/$toppingId", data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant delete topping
  Future<ApiResponse> restaurantDeleteTopping(String toppingId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDeleteTopping + toppingId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant coupons
  Future<ApiResponse> restaurantCoupons() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantCoupons, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant add coupon
  Future<ApiResponse> restaurantAddCoupon(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAddCoupon , isFormData: true, formData: formData,
        headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update coupon
  Future<ApiResponse> restaurantUpdateCoupon(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUpdateCoupon , isFormData: true, formData: formData,
        headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant delete coupon
  Future<ApiResponse> restaurantDeleteCoupon(String couponId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDeleteCoupon + couponId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant details/manage
  Future<ApiResponse> restaurantDetailsManage() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDetails, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant states
  Future<ApiResponse> restaurantStates(String countryId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantStates + countryId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant cities
  Future<ApiResponse> restaurantCities(String stateId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantCities + stateId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update details
  Future<ApiResponse> restaurantUpdateDetails(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantUpdateDetails,isFormData: true, formData: formData,
        headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant change delivery availability
  Future<ApiResponse> restaurantChangeDeliveryAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantChangeDelivery , data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant all reviews
  Future<ApiResponse> restaurantAllReviews() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantAllReviews, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant items list
  Future<ApiResponse> restaurantItems() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantItems, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant change item availability
  Future<ApiResponse> restaurantItemAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantItemAvailability, data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant categories list
  Future<ApiResponse> restaurantCategories() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantCategories, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant subcategories list
  Future<ApiResponse> restaurantAllSubcategories() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantAllSubcategories, headers: restaurantHeaders);
    return apiResponse;
  }


  // restaurant delete subcategory
  Future<ApiResponse> restaurantDeleteSubcategory(String subCategoryId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDeleteSubcategory + subCategoryId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant add new subcategory
  Future<ApiResponse> restaurantAddSubcategory(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAddUpdateSubcategory, data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update subcategory
  Future<ApiResponse> restaurantUpdateSubcategory(Map<String, dynamic> param, String subcategoryId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse("${ApiEndpoint.restaurantAddUpdateSubcategory}/$subcategoryId", data: param, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant add new item
  Future<ApiResponse> restaurantAddItem(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAddUpdateItem ,isFormData: true, formData: formData, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant update item
  Future<ApiResponse> restaurantUpdateItem(FormData formData, String subcategoryId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse("${ApiEndpoint.restaurantAddUpdateItem}/$subcategoryId", isFormData: true, formData: formData,
        headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant delete item
  Future<ApiResponse> restaurantDeleteItem(String itemId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantDeleteItem + itemId, headers: restaurantHeaders);
    return apiResponse;
  }

  // restaurant delete customisation
  Future<ApiResponse> restaurantDeleteCustomisations(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantDeleteCustomisation, data: param, headers: restaurantHeaders);
    return apiResponse;
  }

















  // login
  Future<ApiResponse> loginUser(Map<String, String> body) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.userLogin, data: body);
  return apiResponse;
  }



  // restaurants list
  Future<ApiResponse> getRestaurantList(Map<String, String> owner) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.resList, data: owner);
    return apiResponse;
  }



//------------------------------------------------------------------------------------------------
//-----------------------------------> maps api's <---------------------------------------------
//------------------------------------------------------------------------------------------------

  // suggesting place api
  Future<ApiResponse> mapsAutoComplete(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.mapsAutoComplete, data: param);
    return apiResponse;
  }

  // address from lat lng
  Future<ApiResponse> mapsAddressFromLatLng(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.mapsReverseGeocode, data: param);
    return apiResponse;
  }



}
