import 'package:food_merchant/screens/change_password/change_password.dart';
import 'package:food_merchant/screens/change_password/change_password_binding.dart';
import 'package:food_merchant/screens/coupons/CouponsList/coupons_binding.dart';
import 'package:food_merchant/screens/coupons/CouponsList/new_coupon_screen.dart';
import 'package:food_merchant/screens/coupons/add_coupons/add_coupons.dart';
import 'package:food_merchant/screens/coupons/add_coupons/add_coupons_binding.dart';
import 'package:food_merchant/screens/customised_product/add_customised_product/addCustomisedProduct.dart';
import 'package:food_merchant/screens/customised_product/add_customised_product/addCustomisedProductBinding.dart';
import 'package:food_merchant/screens/customised_product/customisation_type/customisationType.dart';
import 'package:food_merchant/screens/customised_product/customisation_type/customisationTypeBinding.dart';
import 'package:food_merchant/screens/dashboard/controller/dashboard_binding.dart';
import 'package:food_merchant/screens/dashboard/view/dashboard.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_binding.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_controller.dart';
import 'package:food_merchant/screens/dashboard_orders/view/dashboard_orders_view.dart';
import 'package:food_merchant/screens/edit_details/manage_restaurant.dart';
import 'package:food_merchant/screens/edit_details/manage_restaurant_binding.dart';
import 'package:food_merchant/screens/forgotPassword/controller/forgot_password_binding.dart';
import 'package:food_merchant/screens/forgotPassword/view/forgot_password_view.dart';
import 'package:food_merchant/screens/get_location/GetLocation.dart';
import 'package:food_merchant/screens/get_location/GetLocationBinding.dart';
import 'package:food_merchant/screens/map/map_view_binding.dart';
import 'package:food_merchant/screens/new_user/view/new_user.dart';
import 'package:food_merchant/screens/new_user/controller/new_user_binding.dart';
import 'package:food_merchant/screens/new_user/new_user_address/user_address.dart';
import 'package:food_merchant/screens/new_user/new_user_address/user_address_binding.dart';
import 'package:food_merchant/screens/order_details/controller/order_details_binding.dart';
import 'package:food_merchant/screens/order_details/view/order_details.dart';
import 'package:food_merchant/screens/orders_page/controller/orders_page_binding.dart';
import 'package:food_merchant/screens/orders_page/view/orders_page_view.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_settings_binding.dart';
import 'package:food_merchant/screens/printer_settings/view/printer_settings_view.dart';
import 'package:food_merchant/screens/profile/Profile.dart';
import 'package:food_merchant/screens/profile/ProfileBinding.dart';
import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsBinding.dart';
import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsController.dart';
import 'package:food_merchant/screens/restaurant_details/view/RestaurantDetails.dart';
import 'package:food_merchant/screens/sales_report/view/sales_report.dart';
import 'package:food_merchant/screens/sales_report/controller/sales_report_binding.dart';
import 'package:food_merchant/screens/select_delivery_area/delivery_area_binding.dart';
import 'package:food_merchant/screens/settings/controller/settings_controller.dart';
import 'package:food_merchant/screens/tab_bar/controller/tab_bar_controller.dart';
import 'package:food_merchant/screens/tab_bar/view/tab_bar_view.dart';
import 'package:food_merchant/screens/toppings/add_update_toppings/add_update_topping.dart';
import 'package:food_merchant/screens/toppings/add_update_toppings/add_update_topping_binding.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_binding.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_screen.dart';
import 'package:food_merchant/screens/update_profile/controller/update_profile_binding.dart';
import 'package:food_merchant/screens/update_profile/view/update_profile.dart';
import 'package:food_merchant/utils/storage_utils.dart';
import 'package:get/get.dart';
import '../screens/add_product/AddProduct.dart';
import '../screens/add_product/AddProductBinding.dart';
import '../screens/home/controller/HomeBinding.dart';
import '../screens/home/view/Home.dart';
import '../screens/login/controller/login_binding.dart';
import '../screens/login/view/mobile_login_screen.dart';
import '../screens/map/map.dart';
import '../screens/select_delivery_area/delivery_area.dart';
import '../screens/select_restaurant/SelectRestaurant.dart';
import '../screens/select_restaurant/SelectRestaurantBinding.dart';
import '../screens/settings_notifications/Notifications.dart';
import '../screens/settings_notifications/NotificationsBinding.dart';
import '../screens/sub_category_edit_screen/controller/sub_category_edit_binding.dart';
import '../screens/sub_category_edit_screen/view/sub_category_edit_screen.dart';
import '../screens/sub_category_title_screen/controller/sub_category_binding.dart';
import '../screens/sub_category_title_screen/view/sub_category_screen.dart';
import 'app_routes.dart';

class AppPages {
  static int durationTime = 150;

  static String getInitialRoutes(){
    String initialRoute = AppRoutes.userLogin;
    var loggedIn = StorageUtils.utils.restaurantUserToken;
    if (loggedIn.trim().isNotEmpty) {
      initialRoute = AppRoutes.tabBar;
    }
    return initialRoute;
  }


  static final routes = [
    ...authRoutes,
    ...homeRoutes,

    ...settingsRoutes
  ];



  // auth routes
  static final List<GetPage> authRoutes = [
    // login
    GetPage(
        name: AppRoutes.userLogin,
        page: ()=> const MobileLoginScreen(),
        binding: LoginBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // forgot password
    GetPage(
        name: AppRoutes.forgotPassword,
        page: () => const ForgotPasswordView(),
        binding: ForgotPasswordBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // register new user
    GetPage(name: AppRoutes.registerNewUser,
        page: () =>const NewUser(),
        binding: NewUserBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

  ];


  // home routes
  static final List<GetPage> homeRoutes = [
    // tab bar
    GetPage(
        name: AppRoutes.tabBar,
        page: () => TabBarView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<TabBarController>(() => TabBarController());
          Get.lazyPut<DashboardOrdersController>(() => DashboardOrdersController());
          Get.lazyPut<RestaurantDetailsController>(() => RestaurantDetailsController());
          Get.lazyPut<SettingsController>(() => SettingsController());
        }),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // order details
    GetPage(
        name: AppRoutes.orderDetails,
        page: () => const OrderDetails(),
        binding: OrderDetailsBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // orders page listing
    GetPage(name: AppRoutes.ordersList,
        page: () =>const OrdersPageView(),
        binding: OrdersPageBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),
  ];


  // restaurant routes



  // settings routes
  static final settingsRoutes = [

    // view & profile update
    GetPage(
        name: AppRoutes.updateProfile,
        page: () => const UpdateProfile(),
        binding: UpdateProfileBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // sales report
    GetPage(
        name: AppRoutes.salesReport,
        page: ()=> const SalesReport(),
        binding: SalesReportBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // manage restaurant
    GetPage(
        name: AppRoutes.manageRestaurant,
        page: () => const ManageRestaurant(),
        binding: ManageRestaurantBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // map
    GetPage(
        name: AppRoutes.map,
        page: () => const CustomMap(),
        binding: MapViewBinding()
    ),

    // delivery area
    GetPage(
        name: AppRoutes.deliveryArea,
        page: ()=> const DeliveryArea(),
        binding: DeliveryAreaBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // toppings list
    GetPage(
        name: AppRoutes.toppingsList,
        page: ()=> const ToppingsListScreen(),
        binding: ToppingsListBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // add update toppings
    GetPage(
        name: AppRoutes.addUpdateTopping,
        page: ()=> const AddUpdateTopping(),
        binding: AddUpdateToppingBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // coupons list
    GetPage(
        name: AppRoutes.couponsList,
        page: ()=> const NewCouponScreen(),
        binding:  CouponsBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // add update coupons
    GetPage(
        name: AppRoutes.addUpdateCoupons,
        page: ()=> const AddCoupons(),
        binding:  AddCouponsBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),

    // change password
    GetPage(
        name: AppRoutes.changePassword,
        page: () => const ChangePassword(),
        binding: ChangePasswordBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: durationTime)
    ),











    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const Dashboard(),
     binding: DashboardBinding(),
    ),


    // dashboard page
    GetPage(
        name: AppRoutes.MAIN,
        page: ()=> const DashboardOrdersView(),
        binding: DashboardOrdersBinding()
    ),

    GetPage(
        name: AppRoutes.SETTINGS_NOTIFICATIONS,
        page: () => Notifications(),
        binding: NotificationsBinding()
    ),
    GetPage(
        name: AppRoutes.SELECT_RESTAURANT,
        page: () => const SelectRestaurant(),
        binding: SelectRestaurantBinding()
    ),

    // printer settings
    GetPage(
        name: AppRoutes.printerSettings,
        page: () => const PrinterSettingsView(),
        binding: PrinterSettingsBinding()
    ),

    GetPage(
        name: AppRoutes.RESTAURANT_DETAILS,
        page: () => const RestaurantDetails(),
        binding: RestaurantDetailsBinding()
    ),
    GetPage(
        name: AppRoutes.ADD_PRODUCT,
        page: () => const AddProduct(),
        binding: AddProductBinding(),
    ),
    GetPage(
      name: AppRoutes.addCustomisedProduct,
      page: () => const AddCustomisedProduct(),
      binding: AddCustomisedProductBinding(),
    ),
    GetPage(
      name: AppRoutes.customisationType,
      page: () => const CustomisationTypeScreen(),
      binding: CustomisationTypeBinding(),
    ),

   /* GetPage(
        name: AppRoutes.GET_LOCATION,
        page: () => const GetLocation(),
        binding: GetLocationBinding()
    ),*/

    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const Profile(),
      binding: ProfileBinding(),
    ),

    GetPage(
        name: AppRoutes.USER_ADDRESS,
        page: () => const UserAddress(),
      binding: UserAddressBinding()
       ),

    GetPage(
        name: AppRoutes.SUBCATEGORY_TITLE_SCREEN,
        page: ()=> const SubCategoryScreen(),
        binding: SubCategoryBinding()),
    GetPage(
        name: AppRoutes.SUBCATEGORY_EDIT_SCREEN,
        page: ()=> const SubCategoryEditScreen(),
        binding: SubCategoryEditBinding()),

    GetPage(
        name: AppRoutes.HOME,
        page: () => Home(),
        binding: HomeBinding()
    ),

  ];

}
