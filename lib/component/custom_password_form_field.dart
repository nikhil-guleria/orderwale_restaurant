import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/font_family.dart';
import '../utils/size_config.dart';



class CustomPasswordFormField extends StatelessWidget{
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final bool obscureText;
  final VoidCallback? toggle;
  final Color? cursorColor;
  final Color? fillColor;
  final Color? labelColor;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final int? maxLines;
  final Color? iconColor;
  final bool? isDense;
  final Color? textColor;


  const CustomPasswordFormField(
      {super.key, this.hintText,
        this.labelText,
        this.textCapitalization,
        this.inputAction,
        this.keyboardType,
        this.obscureText = true,
        this.validator,
        this.onTap,
        this.controller,
        this.focusNode,
        this.toggle,
        this.onSubmitted,
        this.onChanged,
        this.cursorColor,
        this.fillColor,
        this.focusedBorder,
        this.enabledBorder,
        this.disabledBorder,
        this.focusedErrorBorder,
        this.errorBorder,
        this.maxLines,
        this.labelColor,
        this.iconColor,
        this.isDense,
        this.textColor
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType:keyboardType,
      maxLines: maxLines ?? 1,
      textInputAction:  inputAction ?? TextInputAction.done,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      style: TextStyle(fontSize:  SizeConfig.regularTextSize,color: textColor ?? AppColors.blackText,
        fontWeight: FontWeight.normal,fontFamily: FontFamily.fontMedium),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor ??  AppColors.colorPrimary,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorMaxLines: 3,
        suffixIcon: IconButton(
          icon: Icon(obscureText
              ? Icons.visibility_off_outlined
              :Icons.visibility_outlined,
              color: iconColor ?? AppColors.enabledBorderColor,
              size: SizeConfig.icon20),
          onPressed: toggle,
        ),
        filled: true,
        isDense: isDense ?? true,
        fillColor: fillColor ?? AppColors.white,
        focusColor: AppColors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor ??  AppColors.colorPrimary , fontFamily: FontFamily.fontMedium ,fontSize: SizeConfig.regularTextSize, fontWeight: FontWeight.normal),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.grey, fontFamily: FontFamily.fontMedium,fontSize: SizeConfig.regularTextSize, fontWeight: FontWeight.normal),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.enabledBorderColor),
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.disabledBorderColor),
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
        ),
        disabledBorder: disabledBorder,
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
      ),
    );
  }

}