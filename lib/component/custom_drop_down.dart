import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/utils/size_config.dart';


DropdownButtonFormField customDropDown<T>({
  String? hintText,
  String? labelText,
  Color? labelColor,
  Color? fillColor,
  T? value,
  List<T>? items,
  VoidCallback? reload,
  FormFieldValidator<T>? validator,
  ValueChanged<T?>? onChanged,
  required String Function(T) displayItemName,
  InputBorder? focusedBorder,
  InputBorder? enabledBorder,
  InputBorder? disabledBorder,
  InputBorder? focusedErrorBorder,
  InputBorder? errorBorder,
  bool enableBorderColor = false,
  double? iconSize,
  bool isDense = true,
  double? fontSize,
  EdgeInsetsGeometry? padding,
  Widget Function(T)? itemBuilder,}){
  return DropdownButtonFormField<T>(
      iconSize: 0.0,
      padding: EdgeInsets.zero,
      isExpanded: true,
      dropdownColor: fillColor ?? AppColors.white,
      validator: validator,
      hint: Text(hintText ?? AppStrings.hintSelectOne,
          maxLines: 1,
          style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.normal,
              fontFamily: FontFamily.fontMedium,
              fontSize: fontSize ?? SizeConfig.regularTextSize)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor ?? (AppColors.colorPrimary) ,
            fontSize: fontSize ?? SizeConfig.regularTextSize,
            fontFamily: FontFamily.fontMedium,
            fontWeight: FontWeight.normal),
        isDense: isDense,
        filled: true,
        fillColor: fillColor ?? AppColors.white,
        focusColor: fillColor ?? AppColors.white,
        suffixIcon:
        items == null && reload != null ?
        InkWell(
          onTap: reload,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: Icon(Icons.refresh,
            size: iconSize ?? SizeConfig.icon18)
          ),
        )
        : Padding(
          padding: padding ?? const EdgeInsets.all(6.0),
          child: Icon(Icons.keyboard_arrow_down,
          size: iconSize ?? SizeConfig.icon18)
        ),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
            borderSide:  BorderSide(color: enableBorderColor ?  AppColors.enabledBorderColor : AppColors.white),
            borderRadius: BorderRadius.circular(SizeConfig.borderRadius8)),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
            borderSide:  BorderSide(color: enableBorderColor ?  AppColors.disabledBorderColor : AppColors.white),
            borderRadius: BorderRadius.circular(SizeConfig.borderRadius8)),
        disabledBorder: disabledBorder ?? OutlineInputBorder(
            borderSide:  BorderSide(color: enableBorderColor ?  AppColors.disabledBorderColor : AppColors.white),
            borderRadius: BorderRadius.circular(SizeConfig.borderRadius8)),
        focusedErrorBorder: focusedErrorBorder ?? OutlineInputBorder(
            borderSide:   BorderSide(color: AppColors.red.shade900),
            borderRadius: BorderRadius.circular(SizeConfig.borderRadius8)),
        errorBorder: errorBorder ?? OutlineInputBorder(
          borderSide:  const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
        ),
      ),
      initialValue: value,
      items: items?.map<DropdownMenuItem<T>>((item) {
        return DropdownMenuItem(
            value: item,
            child: itemBuilder != null
                ? itemBuilder(item)
            : Text(displayItemName(item),
                maxLines: 2,
                style:  TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.normal,
                    color: AppColors.blackText,
                    fontSize: fontSize ?? SizeConfig.regularTextSize,
                    fontFamily: FontFamily.fontMedium
                ))
        );
      }).toList(),
      onChanged: onChanged);

}