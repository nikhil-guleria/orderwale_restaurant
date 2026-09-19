import 'package:flutter/material.dart';
import 'package:food_merchant/utils/custom_scroll_behaviour.dart';
import 'package:food_merchant/utils/network_dependency.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'constant/app_strings.dart';
import 'routes/app_pages.dart';
import 'theme/theme_style.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    DependencyInjection.init();
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: AppStrings.appName,
      builder: (context, child) {
        return UpgradeAlert(
            showIgnore: false,
            navigatorKey: navigatorKey,
            child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child!
          ),
        ));
        },
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: AppPages.getInitialRoutes(),
        getPages: AppPages.routes,
        themeMode: ThemeMode.light,
        theme: ThemeStyle.themeStyle.lightThemeStyle(),
    );
  }
}
