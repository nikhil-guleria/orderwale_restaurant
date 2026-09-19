class ApiEndpoint {
  static const  String baseUrl = "https://staging-api.orderwale.com/api/v1";
  static const  String baseUrlRestaurant = "/restaurant";


  // register new restaurant
  static const webRestaurantRegistration = "$baseUrlRestaurant/register_request";
  static const webRegRestaurantStates = "$baseUrlRestaurant/getState/";
  static const webRegRestaurantCities = "$baseUrlRestaurant/getCity/";


  // forgot password todo: create api in restaurant controller
  static var forgotPassword = "/owner/forgot_password";

  // restaurant user app login
  static const restaurantUserAppLogin = "$baseUrlRestaurant/restaurantUserAppLogin";

  // restaurant user app logout
  static const restaurantUserAppLogoutAll = "$baseUrlRestaurant/restaurantUserAppLogoutAll";

  // restaurant user info-profile
  static const restaurantUserInfo = "$baseUrlRestaurant/restaurantUserInfo";

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











  //login
  static String userLogin = "login";


  //order_details
  static String orderDetails = 'restaurantOrderDetails/';

  //restaurant all orders
  static String restaurantAllOrders = '/owner/restaurantAllOrders?page=';

  //Restaurants LIST
  static var resList = "restaurant_list";
  //Restaurant Details
  static var resDetails = 'details/';
  //Owner Profile
  static var ownerProfile = '/owner/profile';
  // Sales Report

  // Restaurant Menu
  static var restaurantMenu = "get_restaurant_menu/";
  // customised menu
  static var restaurantMenuCustomised = "get_restaurant_menu_new/";
  // Coupons List
  static var couponsList = "coupons/0/";



  //Change Password
  static var changePassword = 'change_password';
  //Get Country List
  static var getAllCountry = 'getCountry';
  //Get State List
  static var getAllStateList = 'getState/';
  //Get City List
  static var getAllCityList = 'getCity/';
  //Add Restaurant
  static var addRestaurant = 'addUpdateRestaurant';
  //Update Restaurant
  static var updateRestaurant = 'addUpdateRestaurant/';
  // Create Owner
  static var createOwnerRequest = "register_request";
  //Add Product
  static var addNewProduct = 'addUpdateProduct';
  //Update Product
  static var updateProduct = 'addUpdateProduct/';
  // Add Coupon
  static var addCoupon = "add-coupon";
  // Update Coupon
  static var updateCoupon = "update-coupon";
  // Delete Coupon
  static var deleteCoupon = "delete-coupon/";
  // Update Coupon

  //Category List
  static var getAllCategory = 'categories';
  // SubCategory List
  static var getAllSubCategory = "subCategories";
  // Add SubCategory
  static var addSubCategory = "addUpdateSubcategory";
  static var editSubCategory = "addUpdateSubcategory/";
  static var deleteSubCategory = "delete_subcategory/";

  //All SubcategoryList
  static var getSubcategories = 'mealDeal/';
  //Close Restaurant
  static var closeRestaurant = 'change_restaurant_availability';
  // Close Delivery
  static var closeDelivery = "delivery_availability";
  //OutofStock Item
  static var outofStockItem = 'change_product_availability';
  //Delete Product
  static var deleteProduct = 'delete_product/';
  //Delete Retaurant
  static var deleteRestaurant = 'delete_restaurant/';
  //Restaurat Review
  static var getAllReviews = 'get_all_review/';
  //Order Operations
  //Notification List
  static var notificationList = 'notifications';
  // Update Profile
  static var updateProfile = "updateProfile";
  // Manage Delivery Area
  static var manageDeliveryArea = "manage_delivery_locations";
  // Get Deliver Locations
  static var getDeliveryLocations = "get_delivery_locations";



  // add, update customised product, delete customisation
  static var addCustomisedProduct = 'addUpdateProductNew';
  static var updateCustomisedProduct = 'addUpdateProductNew/';
  static var deleteCustomisations = 'delete_item_customisation';


  // payment methods
  static var createPaymentOrderId = "create_payment_orderid";
  static var verifyPaymentOrderId = "verify_order";
  static var clearBalance = "clear-balance";
  static var requestBalance = "withdrawal_requests";


  // toppings
  static var toppingsList = "toppings/";
  static var addTopping = "addUpdateTopping";
  static var updateTopping = "addUpdateTopping/";
  static var deleteTopping = "delete_topping/";


  // logout
  static var logout = "logout";



  // maps api's
  static const mapsAutoComplete = "/maps/autoComplete";
  static const mapsReverseGeocode = "/maps/reverseGeocode";
}
