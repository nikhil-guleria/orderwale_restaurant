class ApiEndpoint {
  static const  String baseUrl = "https://staging-api.orderwale.com/api/v1";
  static const  String baseUrlRestaurant = "/restaurant";


  // register new restaurant
  static const webRestaurantRegistration = "$baseUrlRestaurant/register_request";
  static const webRegRestaurantStates = "$baseUrlRestaurant/getState/";
  static const webRegRestaurantCities = "$baseUrlRestaurant/getCity/";


  // forgot password
  static var restaurantUserForgotPassword = "$baseUrlRestaurant/restaurantUserForgotPassword";

  // restaurant user app login
  static const restaurantUserAppLogin = "$baseUrlRestaurant/restaurantUserAppLogin";

  // restaurant user app logout
  static const restaurantUserAppLogoutAll = "$baseUrlRestaurant/restaurantUserAppLogoutAll";

  // restaurant user info-profile
  static const restaurantUserInfo = "$baseUrlRestaurant/restaurantUserInfo";

  // restaurant update user name
  static const restaurantUserNameUpdate = "$baseUrlRestaurant/restaurantUserUpdateName";

  // restaurant dashboard orders
  static const restaurantDashboardOrders = "$baseUrlRestaurant/restaurant_dashboard_orders";

  // restaurant availability
  static const restaurantChangeAvailability = "$baseUrlRestaurant/change_restaurant_availability";

  // accept decline order
  static const restaurantAcceptDeclineOrder = "$baseUrlRestaurant/accept_decline_order_new";

  // restaurant order details
  static const restaurantOrderDetails = "$baseUrlRestaurant/restaurantOrderDetails/";

  // restaurant orders list
  static const restaurantOrdersPage = "$baseUrlRestaurant/restaurantAllOrdersApp?page=";

  // restaurant sales report
  static const restaurantSalesReport = '$baseUrlRestaurant/salesReportApp';
  static const restaurantSubscriptionOrder = "$baseUrlRestaurant/restaurantSubscriptionOrder";

  // restaurant withdrawal request
  static const restaurantWithdrawalRequest = "$baseUrlRestaurant/restaurantWithdrawalRequest";
  static const restaurantClearBalance = "$baseUrlRestaurant/restaurantClearBalance";
  static const restaurantCashFreeVerifyOrder = "$baseUrlRestaurant/verifyCashfreeOrder";

  // restaurant details/manage
  static const restaurantDetails = "$baseUrlRestaurant/restaurantDetails";
  static const restaurantStates = "$baseUrlRestaurant/restaurantStates/";
  static const restaurantCities = "$baseUrlRestaurant/restaurantCities/";
  static const restaurantUpdateDetails = "$baseUrlRestaurant/updateRestaurantDetails";


  // restaurant delivery area
  static const restaurantDeliveryArea = "$baseUrlRestaurant/restaurantDeliveryArea";
  static const restaurantUpdateDeliveryArea = "$baseUrlRestaurant/updateDeliveryArea";

  // restaurant toppings
  static const restaurantToppings = "$baseUrlRestaurant/restaurantToppings";
  static const restaurantDeleteTopping = "$baseUrlRestaurant/deleteTopping/";
  static const restaurantAddUpdateTopping = "$baseUrlRestaurant/addUpdateTopping";

  // restaurant coupons
  static const restaurantCoupons = "$baseUrlRestaurant/restaurantCoupons";
  static const restaurantAddCoupon = "$baseUrlRestaurant/restaurantAddCoupon";
  static const restaurantUpdateCoupon = "$baseUrlRestaurant/restaurantUpdateCoupon";
  static const restaurantDeleteCoupon = "$baseUrlRestaurant/restaurantDeleteCoupon/";

  // restaurant change user password
  static const restaurantChangeUserPassword = "$baseUrlRestaurant/changeRestaurantUserPassword";

  // restaurant help & support
  static const restaurantHelpSupport = "$baseUrlRestaurant/helpAndSupport";

  // restaurant delivery availability
  static const restaurantChangeDelivery = "$baseUrlRestaurant/restaurantDeliveryAvailability";

  // restaurant reviews
  static const restaurantAllReviews = "$baseUrlRestaurant/restaurantAllReviews";

  // restaurant menu
  static const restaurantItems = "$baseUrlRestaurant/getRestaurantMenu";
  static const restaurantItemAvailability = "$baseUrlRestaurant/change_product_availability";
  static const restaurantCategories = "$baseUrlRestaurant/itemCategories";
  static const restaurantAllSubcategories = "$baseUrlRestaurant/restaurantSubcategories";

  // subcategories
  static const restaurantAddUpdateSubcategory = "$baseUrlRestaurant/addUpdateSubcategory";
  static const restaurantDeleteSubcategory = "$baseUrlRestaurant/delete_subcategory/";

  // items
  static const restaurantAddUpdateItem = "$baseUrlRestaurant/addUpdateProductNew";
  static const restaurantDeleteItem = "$baseUrlRestaurant/delete_product/";
  static const restaurantDeleteCustomisation = "$baseUrlRestaurant/deleteItemCustomisation";


  // maps api's
  static const mapsAutoComplete = "/maps/autoComplete";
  static const mapsReverseGeocode = "/maps/reverseGeocode";












  //login
  static String userLogin = "login";

  //Restaurants LIST
  static var resList = "restaurant_list";

  // Update Profile
  static var updateProfile = "updateProfile";


}
