import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';

final timePickerTheme =  TimePickerThemeData(
        elevation: 0.0,
        backgroundColor: AppColors.white,
        hourMinuteShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
             side: BorderSide(color: AppColors.white, width: 0.5)),
    dayPeriodBorderSide: const BorderSide(color: AppColors.transparent, width: 0.1),
     dayPeriodColor:  WidgetStateColor.resolveWith((states) =>
     states.contains(WidgetState.selected) ? AppColors.colorPrimary.withAlpha((255*0.2).round()) : AppColors.grey.shade300),
     shape: const RoundedRectangleBorder(
     borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: AppColors.white, width: 0.1)),
      dayPeriodTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected) ? AppColors.colorPrimary : AppColors.grey.shade800),
      dayPeriodShape: const RoundedRectangleBorder(
     borderRadius: BorderRadius.all(Radius.circular(8)),
       side: BorderSide(color: AppColors.transparent, width: 0.1)),
       hourMinuteColor: WidgetStateColor.resolveWith((states) =>
       states.contains(WidgetState.selected) ? AppColors.colorPrimary.withAlpha((255*0.2).round()) : AppColors.grey.shade300),
       hourMinuteTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.colorPrimary : AppColors.grey.shade800),
        dialHandColor: AppColors.colorPrimary,
       dialBackgroundColor: AppColors.colorPrimary.withAlpha((255*0.2).round()),
            dialTextColor: WidgetStateColor.resolveWith(
             (states) => states.contains(WidgetState.selected) ? AppColors.white : AppColors.black),
           entryModeIconColor : AppColors.colorPrimary,
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
);