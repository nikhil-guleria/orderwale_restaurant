import 'package:dio/dio.dart';
import 'package:food_merchant/services/api/ApiConstant.dart';
import 'package:food_merchant/services/api/api_hitter.dart';
import 'package:food_merchant/services/base/BaseRepository.dart';
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
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.forgotPassword, data: email);
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

  // restaurant sales report
  Future<ApiResponse> restaurantSalesReport(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantSalesReport ,headers: restaurantHeaders, data: param);
    return apiResponse;
  }

  // restaurant change user password
  Future<ApiResponse> restaurantChangeUserPassword(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantChangeUserPassword , data: param, headers: restaurantHeaders);
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


  // restaurant order details
  Future<ApiResponse> getOrderDetails(String orderId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.orderDetails + orderId);
    return apiResponse;
  }

  // restaurant all orders
  Future<ApiResponse> restaurantAllOrders(Map<String, dynamic> param, String page) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantAllOrders + page, data: param);
    return apiResponse;
  }

  // restaurant details
  Future<ApiResponse> getRestaurantDetails(String restaurantId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.resDetails + restaurantId);
    return apiResponse;
  }
  Future<ApiResponse> getRestaurantReviews(String restaurantId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.getAllReviews + restaurantId);
    return apiResponse;
  }
  Future<ApiResponse> changeRestaurantAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.closeRestaurant, data: param);
    return apiResponse;
  }
  Future<ApiResponse> changeDeliveryAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.closeDelivery, data: param);
    return apiResponse;
  }
  Future<ApiResponse> changeProductAvailability(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.outofStockItem, data: param);
    return apiResponse;
  }
  Future<ApiResponse> getAutoPlaceLocation(String input, String lang , var cancelToken) async {
    var request =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=establishment&language=$lang&components=country:in&key=${ApiConstant.androidKey}&sessiontoken=$cancelToken";
    ApiResponse apiResponse =  await apiHitter.getApiRawResponses(request);
    return apiResponse;
  }
  Future<ApiResponse> updateRestaurantDetails(FormData formData , String restaurantId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateRestaurant + restaurantId,isFormData: true, formData: formData);
    return apiResponse;
  }
  Future<ApiResponse> createOwnerRequest(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.createOwnerRequest,data: param);
    return apiResponse;
  }
  Future<ApiResponse> getCountries() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.getAllCountry);
    return apiResponse;
  }
  Future<ApiResponse> getAllStates(String countryId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.getAllStateList + countryId);
    return apiResponse;
  }
  Future<ApiResponse> getAllCities(String stateId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.getAllCityList + stateId);
    return apiResponse;
  }
  Future<ApiResponse> deleteRestaurant(String restId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.deleteRestaurant + restId);
    return apiResponse;
  }
  Future<ApiResponse> getAllCategories() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.getAllCategory);
    return apiResponse;
  }
  Future<ApiResponse> getAllSubCategories(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.getAllSubCategory, data: param);
    return apiResponse;
  }
  Future<ApiResponse> addSubCategory(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.addSubCategory, data: param);
    return apiResponse;
  }
  Future<ApiResponse> editSubCategory(Map<String, dynamic> param, String subCategoryId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.editSubCategory + subCategoryId, data: param);
    return apiResponse;
  }
  Future<ApiResponse> deleteSubCategory(String subCategoryId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.deleteSubCategory + subCategoryId);
    return apiResponse;
  }



  // add , update and delete product
  Future<ApiResponse> addNewProduct(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.addNewProduct ,isFormData: true, formData: formData);
    return apiResponse;
  }
  Future<ApiResponse> updateProduct(FormData formData , String subcategoryId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateProduct + subcategoryId, isFormData: true, formData: formData);
    return apiResponse;
  }

  Future<ApiResponse> addCustomisedProduct(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.addCustomisedProduct ,isFormData: true, formData: formData);
    return apiResponse;
  }

  Future<ApiResponse> updateCustomisedProduct(FormData formData , String subcategoryId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateCustomisedProduct + subcategoryId, isFormData: true, formData: formData);
    return apiResponse;
  }

  Future<ApiResponse> deleteProduct(String productId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.deleteProduct + productId);
    return apiResponse;
  }
  Future<ApiResponse> deleteCustomisations(Map<String, dynamic> param) async {
    ApiResponse apiResponse =await apiHitter.getPostApiResponse(ApiEndpoint.deleteCustomisations, data: param);
    return apiResponse;
  }




  // change password
  Future<ApiResponse> changePassword(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.changePassword , data: param);
    return apiResponse;
  }
  Future<ApiResponse> getNotifications(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.notificationList , data: param);
    return apiResponse;
  }


  Future<ApiResponse> getCancelReasons() async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse("https://staging-api.orderwale.com/api/v1/cancel_reasons");
    return apiResponse;
  }
  Future<ApiResponse> cancelOrderWithReason(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse("https://staging-api.orderwale.com/api/v1/cancel_order_with_reason", data: param);
    return apiResponse;
  }



  Future<ApiResponse> getOwnerProfile(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.ownerProfile , data: param);
    return apiResponse;
  }

  Future<ApiResponse> updateOwnerProfile(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateProfile , isFormData: true, formData: formData);
    return apiResponse;
  }

  // restaurant menu
  Future<ApiResponse> getRestaurantMenu(String restId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantMenu + restId);
    return apiResponse;
  }
  Future<ApiResponse> getCustomisedRestaurantMenu(String restId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.restaurantMenuCustomised + restId);
    return apiResponse;
  }



  // toppings list, add, update, delete topping
  Future<ApiResponse> getToppingsList(String restId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.toppingsList + restId);
    return apiResponse;
  }
  Future<ApiResponse> addTopping(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.addTopping , data: param);
    return apiResponse;
  }
  Future<ApiResponse> updateTopping(Map<String, dynamic> param, String toppingId) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateTopping + toppingId, data: param);
    return apiResponse;
  }
  Future<ApiResponse> deleteTopping(String toppingId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.deleteTopping + toppingId);
    return apiResponse;
  }




  // coupons list , add, update, delete coupon
  Future<ApiResponse> getCouponsList(String restId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.couponsList + restId);
    return apiResponse;
  }

  Future<ApiResponse> addCoupon(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.addCoupon , isFormData: true, formData: formData);
    return apiResponse;
  }

  Future<ApiResponse> updateCoupon(FormData formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.updateCoupon , isFormData: true, formData: formData);
    return apiResponse;
  }

  Future<ApiResponse> deleteCoupon(String couponId) async {
    ApiResponse apiResponse = await apiHitter.getApiRawResponse(ApiEndpoint.deleteCoupon + couponId);
    return apiResponse;
  }



  Future<ApiResponse> manageDeliveryLocations(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.manageDeliveryArea , data: param);
    return apiResponse;
  }

  Future<ApiResponse> getDeliveryLocations(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.getDeliveryLocations , data: param);
    return apiResponse;
  }

  Future<ApiResponse> logOutOwner(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.logout , data: param);
    return apiResponse;
  }

  // remaining balance settlement
  Future<ApiResponse> createPaymentOrderId(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.createPaymentOrderId, data: param);
    return apiResponse;
  }
  Future<ApiResponse> verifyPaymentOrderId(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.verifyPaymentOrderId, data: param);
    return apiResponse;
  }
  Future<ApiResponse> clearRemainingBalance(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.clearBalance, data: param);
    return apiResponse;
  }
  Future<ApiResponse> requestForBalance(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.requestBalance, data: param);
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
