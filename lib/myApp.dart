import 'package:flutter/material.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:food_merchant/utils/ScrollBehaviour.dart';
import 'package:food_merchant/utils/network_dependency.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';
import 'constant/string_constants.dart';
import 'routes/app_routes.dart';
import 'theme/ThemeStyle.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    DependencyInjection.init();
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: appName,
      builder: (context, child) {
        return UpgradeAlert(
            showIgnore: false,
            navigatorKey: navigatorKey,
            child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child!
          ),
        ));
        },
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: getInitialRoutes(),
        getPages: AppPages.routes,
        themeMode: ThemeMode.light,
        theme: ThemeStyle.themeStyle.lightThemeStyle(),
    );
  }

}
String getInitialRoutes(){

  String initialRoute = AppPages.initialRoute;
  var storage = GetStorage();
  var loggedIn = storage.read(GetStorageConstants.IS_LOGGED);
  var restaurantSelected = storage.read(GetStorageConstants.RESTAURANT_SELECTED);

  if (loggedIn != null && loggedIn){
    if (restaurantSelected != null && restaurantSelected){
      initialRoute = AppPages.initialDashboard;
    }
    else {
      initialRoute = AppPages.selectRestaurant;
    }
  }
  return initialRoute;
}
