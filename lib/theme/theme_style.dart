import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'time_picker_theme.dart';

class ThemeStyle {
  ThemeStyle._internal();

  static final ThemeStyle themeStyle = ThemeStyle._internal();

  factory ThemeStyle() {
    return themeStyle;
  }

  ThemeData darkThemeStyle() {
    return ThemeData(
        // fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
            foregroundColor: AppColors.white //here you can give the text colo
            ),
        brightness: Brightness.dark,
        primaryColor: AppColors.colorPrimary,
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.colorPrimary,
          disabledColor: AppColors.grey,
        ));
  }

  ThemeData lightThemeStyle() {
    return ThemeData(
        fontFamily: 'Helvetica_Regular',

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          foregroundColor: AppColors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            )
        ),
        dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white
        ),
        brightness: Brightness.light,
        primaryColor: AppColors.colorPrimary,
        scaffoldBackgroundColor: AppColors.white,
        timePickerTheme: timePickerTheme,
        textSelectionTheme:  TextSelectionThemeData(
          cursorColor: AppColors.colorPrimary,
          selectionHandleColor: AppColors.colorPrimary,
          selectionColor: AppColors.colorPrimary.withAlpha((255 * 0.3).round())
        ),
          inputDecorationTheme:  InputDecorationTheme(
            labelStyle:  TextStyle(
               color: AppColors.colorPrimary),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.colorPrimary,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: AppColors.enabledBorderColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.disabledBorderColor),
              borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:   BorderSide(color: AppColors.red.shade900),
              borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:  const BorderSide(color: AppColors.red),
              borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
            ),
          ),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ?  TextStyle(color: AppColors.colorPrimary,fontSize: SizeConfig.regularFontSize,
                      fontWeight: FontWeight.bold)
                  :  TextStyle(color:AppColors.black45,fontSize: SizeConfig.regularFontSize,
                    fontWeight: FontWeight.w500),
            )),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.colorPrimary),
            backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.transparent),
            overlayColor: WidgetStateColor.resolveWith((states) => AppColors.transparent),
          ),
        ),
        datePickerTheme:  DatePickerThemeData(
          headerBackgroundColor: AppColors.colorPrimary,
          backgroundColor: AppColors.white,
          elevation: 0.0,
          todayBackgroundColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.selected) ? AppColors.colorPrimary : AppColors.transparent),
            todayForegroundColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.white : AppColors.colorPrimary),
            yearBackgroundColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.colorPrimary : AppColors.transparent),
          dayBackgroundColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.selected) ? AppColors.colorPrimary : AppColors.transparent)),

        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.colorPrimary,
          disabledColor: AppColors.grey,
        ));
  }
}
