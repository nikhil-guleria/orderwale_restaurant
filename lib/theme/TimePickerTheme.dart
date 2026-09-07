import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';

final timePickerTheme =  TimePickerThemeData(
        elevation: 0.0,
        backgroundColor: Colors.white,
        hourMinuteShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
             side: BorderSide(color: Colors.white, width: 0.5)),
    dayPeriodBorderSide: const BorderSide(color: Colors.transparent, width: 0.1),
     dayPeriodColor:  WidgetStateColor.resolveWith((states) =>
     states.contains(WidgetState.selected) ? colorPrimary.withOpacity(0.2) : Colors.grey.shade300),
     shape: const RoundedRectangleBorder(
     borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.white, width: 0.1)),
      dayPeriodTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected) ? colorPrimary : Colors.grey.shade800),
      dayPeriodShape: const RoundedRectangleBorder(
     borderRadius: BorderRadius.all(Radius.circular(8)),
       side: BorderSide(color: Colors.transparent, width: 0.1)),
       hourMinuteColor: WidgetStateColor.resolveWith((states) =>
       states.contains(WidgetState.selected) ? colorPrimary.withOpacity(0.2) : Colors.grey.shade300),
       hourMinuteTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? colorPrimary : Colors.grey.shade800),
        dialHandColor: colorPrimary,
       dialBackgroundColor: colorPrimary.withOpacity(0.2),
            dialTextColor: WidgetStateColor.resolveWith(
             (states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black),
           entryModeIconColor : colorPrimary,
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),







);