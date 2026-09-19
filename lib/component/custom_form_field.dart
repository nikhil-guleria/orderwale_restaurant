import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/utils/size_config.dart';



class CustomFormField extends StatelessWidget{
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Color? labelColor;
  final Color? cursorColor;
  final bool? enableInteractiveSelection;
  final bool? enabled;
  final bool? readOnly;
  final bool? isDense;
  final bool? autoCorrect;
  final bool? autoFocus;
  final Color? textColor;
  final bool? allowDecimal;
  final bool? allTwoDecimalPlaces;
  final bool? onlyNumbers;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final TextAlign? textAlign;
  final String? errorText;
  final int? maxLines;
  final AutovalidateMode? autoValidateMode;


  const CustomFormField(
      {super.key, this.hintText,
        this.labelText,
        this.textCapitalization,
        this.inputAction,
        this.keyboardType,
        this.validator,
        this.controller,
        this.focusNode,
        this.onSubmitted,
        this.onChanged,
        this.suffixIcon,
        this.suffixIconColor,
        this.prefixIcon,
        this.prefixIconColor,
        this.enableInteractiveSelection,
        this.enabled,
        this.onTap,
        this.onTapOutside,
        this.readOnly,
        this.inputFormatters,
        this.isDense,
        this.autoCorrect,
        this.autoFocus,
        this.fillColor,
        this.contentPadding,
        this.textColor,
        this.allowDecimal,
        this.allTwoDecimalPlaces,
        this.onlyNumbers,
        this.focusedBorder,
        this.enabledBorder,
        this.disabledBorder,
        this.focusedErrorBorder,
        this.errorBorder,
        this.textAlign,
        this.errorText,
        this.maxLines,
        this.autoValidateMode,
        this.labelColor,
        this.cursorColor,
      });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: allowDecimal ?? false ?
      [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : allTwoDecimalPlaces ?? false ?
      [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
          :  onlyNumbers ?? false ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : inputFormatters,
      readOnly: readOnly ?? false,
      onTap: onTap,
      autofocus: autoFocus ?? false,
      enabled: enabled,
      autocorrect: autoCorrect ?? true,
      enableInteractiveSelection: enableInteractiveSelection,
      focusNode: focusNode,
      keyboardType:keyboardType,
      maxLines: maxLines ?? 1,
      textInputAction:  inputAction ?? TextInputAction.done,
      autovalidateMode: autoValidateMode,
      onFieldSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      style: TextStyle(fontSize: SizeConfig.regularTextSize,color: textColor ?? AppColors.blackText,
        fontWeight: FontWeight.normal,fontFamily: FontFamily.fontMedium),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor ??  AppColors.colorPrimary,
      textAlignVertical: TextAlignVertical.center,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        isDense: isDense ?? true,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        filled: true,
        fillColor:  fillColor ??  AppColors.white,
        focusColor: AppColors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor ??  AppColors.colorPrimary , fontFamily: FontFamily.fontMedium ,
            fontSize: SizeConfig.regularTextSize, fontWeight: FontWeight.normal),
        hintText: hintText,
        hintStyle: TextStyle(
            color: AppColors.grey , fontFamily: FontFamily.fontMedium ,
            fontSize: SizeConfig.regularTextSize, fontWeight: FontWeight.normal),
        errorText: errorText,
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class FirstLetterUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String formattedText = newValue.text[0].toUpperCase() + newValue.text.substring(1);

    return newValue.copyWith(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}

class CapitalizeEachWordFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String formattedText = newValue.text
        .split(' ')
        .map((word) => word.isEmpty
        ? word
        : word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return newValue.copyWith(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}