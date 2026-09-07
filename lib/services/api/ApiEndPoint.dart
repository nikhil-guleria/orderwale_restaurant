
class ApiEndpoint {
  static String baseUrl = "https://api.orderwale.com/api/v1/owner/";



  //login
  static String userLogin = "login";

  // dashboard orders
  static String restaurantDashboardOrders = "restaurantDashboardOrders";

  //order_details
  static String orderDetails = 'restaurantOrderDetails/';

  //restaurant all orders
  static String restaurantAllOrders = 'restaurantAllOrders?page=';






  //Restaurants LIST
  static var resList = "restaurant_list";
  //Restaurant Details
  static var resDetails = 'details/';
  //Owner Profile
  static var ownerProfile = 'profile';
  // Sales Report
  static var salesReport = 'get_sales_report';
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
  static var orderOperation = 'accept_decline_order_new';
  //Notification List
  static var notificationList = 'notifications';
  // Forgot Password
  static var forgotPassword = "forgot_password";
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


}
