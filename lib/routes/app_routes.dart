import 'package:food_merchant/screens/change_password/ChangePassword.dart';
import 'package:food_merchant/screens/change_password/ChangePasswordBinding.dart';
import 'package:food_merchant/screens/coupons/CouponsList/coupons_binding.dart';
import 'package:food_merchant/screens/coupons/CouponsList/new_coupon_screen.dart';
import 'package:food_merchant/screens/coupons/add_coupons/AddCoupons.dart';
import 'package:food_merchant/screens/coupons/add_coupons/AddCouponsBinding.dart';
import 'package:food_merchant/screens/customised_product/add_customised_product/addCustomisedProduct.dart';
import 'package:food_merchant/screens/customised_product/add_customised_product/addCustomisedProductBinding.dart';
import 'package:food_merchant/screens/customised_product/customisation_type/customisationType.dart';
import 'package:food_merchant/screens/customised_product/customisation_type/customisationTypeBinding.dart';
import 'package:food_merchant/screens/dashboard/controller/dashboard_binding.dart';
import 'package:food_merchant/screens/dashboard/view/dashboard.dart';
import 'package:food_merchant/screens/dashboard_orders/controller/dashboard_orders_binding.dart';
import 'package:food_merchant/screens/dashboard_orders/view/dashboard_orders_view.dart';
import 'package:food_merchant/screens/edit_details/EditDetails.dart';
import 'package:food_merchant/screens/edit_details/EditDetailsBinding.dart';
import 'package:food_merchant/screens/forgotPassword/controller/ForgotPasswordBinding.dart';
import 'package:food_merchant/screens/forgotPassword/view/forgotPasswordPage.dart';
import 'package:food_merchant/screens/get_location/GetLocation.dart';
import 'package:food_merchant/screens/get_location/GetLocationBinding.dart';
import 'package:food_merchant/screens/map/MapBinding.dart';
import 'package:food_merchant/screens/new_user/NewUser.dart';
import 'package:food_merchant/screens/new_user/NewUserBinding.dart';
import 'package:food_merchant/screens/new_user/new_user_address/user_address.dart';
import 'package:food_merchant/screens/new_user/new_user_address/user_address_binding.dart';
import 'package:food_merchant/screens/order_details/controller/OrderDetailsBinding.dart';
import 'package:food_merchant/screens/order_details/view/order_details.dart';
import 'package:food_merchant/screens/orders_page/controller/orders_page_binding.dart';
import 'package:food_merchant/screens/orders_page/view/orders_page_view.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_settings_binding.dart';
import 'package:food_merchant/screens/printer_settings/view/printer_settings_view.dart';
import 'package:food_merchant/screens/profile/Profile.dart';
import 'package:food_merchant/screens/profile/ProfileBinding.dart';
import 'package:food_merchant/screens/restaurant_details/controller/RestaurantDetailsBinding.dart';
import 'package:food_merchant/screens/restaurant_details/view/RestaurantDetails.dart';
import 'package:food_merchant/screens/sales_report/view/SalesReport.dart';
import 'package:food_merchant/screens/sales_report/controller/sales_report_binding.dart';
import 'package:food_merchant/screens/select_delivery_area/DeliveryAreaBinding.dart';
import 'package:food_merchant/screens/toppings/add_update_toppings/add_update_topping.dart';
import 'package:food_merchant/screens/toppings/add_update_toppings/add_update_topping_binding.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppingsListBinding.dart';
import 'package:food_merchant/screens/toppings/toppings_list/toppingsListScreen.dart';
import 'package:food_merchant/screens/update_profile/UpdateProfile.dart';
import 'package:food_merchant/screens/update_profile/UpdateProfileBinding.dart';
import 'package:get/get.dart';
import '../screens/add_product/AddProduct.dart';
import '../screens/add_product/AddProductBinding.dart';
import '../screens/home/controller/HomeBinding.dart';
import '../screens/home/view/Home.dart';
import '../screens/login/controller/login_binding.dart';
import '../screens/login/view/mobile_login_screen.dart';
import '../screens/map/Map.dart';
import '../screens/select_delivery_area/DeliveryArea.dart';
import '../screens/select_restaurant/SelectRestaurant.dart';
import '../screens/select_restaurant/SelectRestaurantBinding.dart';
import '../screens/settings_notifications/Notifications.dart';
import '../screens/settings_notifications/NotificationsBinding.dart';
import '../screens/sub_category_edit_screen/controller/sub_category_edit_binding.dart';
import '../screens/sub_category_edit_screen/view/sub_category_edit_screen.dart';
import '../screens/sub_category_title_screen/controller/sub_category_binding.dart';
import '../screens/sub_category_title_screen/view/sub_category_screen.dart';
import 'app_pages.dart';

class AppPages {

  static const initialRoute = Routes.USER_LOGIN;
  static const initialDashboard = Routes.DASHBOARD;
  static const selectRestaurant = Routes.SELECT_RESTAURANT;

  static final routes = [
    // login screen
    GetPage(
        name: Routes.USER_LOGIN,
        page: () => const MobileLoginScreen(),
        binding: LoginBinding()
    ),

    // forgot password
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => const ForgotPasswordScreen(),
        binding: ForgotPasswordBinding()
    ),

    // dashboard tab bar
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const Dashboard(),
     binding: DashboardBinding(),
    ),


    // dashboard page
    GetPage(
        name: Routes.MAIN,
        page: ()=> const DashboardOrdersView(),
        binding: DashboardOrdersBinding()
    ),

    // orders page
    GetPage(name: Routes.ORDERS,
        page: () =>const OrdersPageView(),
        binding: OrdersPageBinding()),

    GetPage(
        name: Routes.CHANGE_PASSWORD,
        page: () => const ChangePassword(),
        binding: ChangePasswordBinding()
    ),
    GetPage(
        name: Routes.SETTINGS_NOTIFICATIONS,
        page: () => Notifications(),
        binding: NotificationsBinding()
    ),
    GetPage(
        name: Routes.SELECT_RESTAURANT,
        page: () => const SelectRestaurant(),
        binding: SelectRestaurantBinding()
    ),

    // printer settings
    GetPage(
        name: Routes.printerSettings,
        page: () => const PrinterSettingsView(),
        binding: PrinterSettingsBinding()
    ),

    GetPage(
        name: Routes.RESTAURANT_DETAILS,
        page: () => const RestaurantDetails(),
        binding: RestaurantDetailsBinding()
    ),
    GetPage(
        name: Routes.EDIT_DETAILS,
        page: () => const EditDetails(),
        binding: EditDetailsBinding()
    ),
    GetPage(
        name: Routes.ADD_PRODUCT,
        page: () => const AddProduct(),
        binding: AddProductBinding(),
    ),
    GetPage(
      name: Routes.addCustomisedProduct,
      page: () => const AddCustomisedProduct(),
      binding: AddCustomisedProductBinding(),
    ),
    GetPage(
      name: Routes.customisationType,
      page: () => const CustomisationTypeScreen(),
      binding: CustomisationTypeBinding(),
    ),
    GetPage(
        name: Routes.MAP,
        page: () => const CustomMap(),
        binding: MapViewBinding()
    ),
    GetPage(
        name: Routes.GET_LOCATION,
        page: () => const GetLocation(),
        binding: GetLocationBinding()
    ),
    GetPage(
      name: Routes.ORDER_DETAILS,
      page: () => const OrderDetails(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const Profile(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.UPDATE_PROFILE,
      page: () => const UpdateProfile(),
      binding: UpdateProfileBinding(),
    ),



    GetPage(name: Routes.NEW_USER,
        page: () =>const NewUser(),
        binding: NewUserBinding()),
    GetPage(
        name: Routes.USER_ADDRESS,
        page: () => const UserAddress(),
      binding: UserAddressBinding()
       ),




    GetPage(
        name: Routes.SALES_REPORT,
        page: ()=> const SalesReport(),
        binding: SalesReportBinding()
    ),
    GetPage(
        name: Routes.ADD_COUPONS,
        page: ()=> const AddCoupons(),
        binding:  AddCouponsBinding()),

    GetPage(
        name: Routes.COUPONS_LIST,
        page: ()=> const NewCouponScreen(),
        binding:  CouponsBinding()),

    GetPage(
        name: Routes.DELIVERY_AREA,
        page: ()=> const DeliveryArea(),
        binding: DeliveryAreaBinding()),
    GetPage(
        name: Routes.SUBCATEGORY_TITLE_SCREEN,
        page: ()=> const SubCategoryScreen(),
        binding: SubCategoryBinding()),
    GetPage(
        name: Routes.SUBCATEGORY_EDIT_SCREEN,
        page: ()=> const SubCategoryEditScreen(),
        binding: SubCategoryEditBinding()),
    GetPage(
        name: Routes.toppingsList,
        page: ()=> const ToppingsListScreen(),
        binding: ToppingsListBinding()),
    GetPage(
        name: Routes.addUpdateTopping,
        page: ()=> const AddUpdateTopping(),
        binding: AddUpdateToppingBinding()),



    GetPage(
        name: Routes.HOME,
        page: () => Home(),
        binding: HomeBinding()
    ),

  ];

}
