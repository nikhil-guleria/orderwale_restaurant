import 'package:dio/dio.dart';
import 'package:food_merchant/services/api/ApiConstant.dart';
import 'package:food_merchant/services/api/ApiHitter.dart';
import 'package:food_merchant/services/base/BaseRepository.dart';
import '../api/ApiEndPoint.dart';


class ApiController extends BaseRepository {

  // login
  Future<ApiResponse> loginUser(Map<String, String> body) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.userLogin, data: body);
  return apiResponse;
  }

  // forget password
  Future<ApiResponse> forgotPassword(Map<String, String> email) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.forgotPassword, data: email);
    return apiResponse;
  }

  // restaurants list
  Future<ApiResponse> getRestaurantList(Map<String, String> owner) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.resList, data: owner);
    return apiResponse;
  }

  // restaurant dashboard orders
  Future<ApiResponse> restaurantDashboardOrders(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.restaurantDashboardOrders , data: param);
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

  Future<ApiResponse> orderOperations(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.orderOperation , data: param);
    return apiResponse;
  }

  Future<ApiResponse> getOwnerProfile(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.ownerProfile , data: param);
    return apiResponse;
  }
  Future<ApiResponse> getRestaurantSalesReport(Map<String, dynamic> param) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(ApiEndpoint.salesReport , data: param);
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





}
