import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'TimePickerTheme.dart';

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
            foregroundColor: Colors.white //here you can give the text colo
            ),
        brightness: Brightness.dark,
        primaryColor: colorPrimary,
        buttonTheme: const ButtonThemeData(
          buttonColor: colorPrimary,
          disabledColor: Colors.grey,
        ));
  }

  ThemeData lightThemeStyle() {
    return ThemeData(
        fontFamily: 'Helvetica_Regular',

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            )
        ),
        dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white
        ),
        brightness: Brightness.light,
        primaryColor: colorPrimary,
        scaffoldBackgroundColor: colorWhite,
        timePickerTheme: timePickerTheme,
        textSelectionTheme:  TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionHandleColor: colorPrimary,
          selectionColor: colorPrimary.withAlpha((255 * 0.3).round())
        ),
          inputDecorationTheme:  InputDecorationTheme(
            labelStyle: const TextStyle(
               color: colorPrimary),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: colorPrimary,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: enabledBorderColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: disabledBorderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:  const BorderSide(color: enabledBorderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:  const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ?  TextStyle(color: colorPrimary,fontSize: SizeConfig.regularFontSize,
                      fontWeight: FontWeight.bold)
                  :  TextStyle(color:Colors.black45,fontSize: SizeConfig.regularFontSize,
                    fontWeight: FontWeight.w500),
            )),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateColor.resolveWith((states) => colorPrimary),
            backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        datePickerTheme:  DatePickerThemeData(
          headerBackgroundColor: colorPrimary,
          backgroundColor: colorWhite,
          elevation: 0.0,
          todayBackgroundColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.selected) ? colorPrimary : Colors.transparent),
            todayForegroundColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : colorPrimary),
            yearBackgroundColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected) ? colorPrimary : Colors.transparent),
          dayBackgroundColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.selected) ? colorPrimary : Colors.transparent)),

        buttonTheme: const ButtonThemeData(
          buttonColor: colorPrimary,
          disabledColor: Colors.grey,
        ));
  }
}
