
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/constant/app_constant.dart';
import 'package:food_merchant/utils/SizeConfig.dart';


// ignore: must_be_immutable
/*class TextFormWidget extends StatelessWidget{
  final validator;
  TextEditingController? controller;
  TextCapitalization? textCapitalization;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  String? hintText;
  ValueChanged<String>? onSubmitted;
  ValueChanged<String>? onChanged;
  GestureTapCallback? onTap;
  List<TextInputFormatter>? inputFormatters;
  String? labelText;
  FocusNode? focusNode;
   Widget? suffixIcon;
  Widget? prefixIcon;
  Color? suffixIconColor;
  Color? prefixIconColor;
  bool? enableInteractiveSelection;
  bool? enabled;
  bool? readOnly;
  bool? autoFocus;
  bool? allowDecimal;
  bool? onlyNumbers;
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  InputBorder? disabledBorder;
  InputBorder? focusedErrorBorder;
  InputBorder? errorBorder;


  TextFormWidget(
      {super.key,  this.hintText,
        this.textCapitalization,
        this.inputAction,
        this.keyboardType,
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
        this.readOnly,
        this.inputFormatters,
        this.autoFocus,
        this.labelText,
        this.allowDecimal,
        this.onlyNumbers,
        this.validator,
        this.focusedBorder,
        this.enabledBorder,
        this.disabledBorder,
        this.errorBorder,
        this.focusedErrorBorder

       });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: allowDecimal ?? false ?
      [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          :  onlyNumbers ?? false ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : inputFormatters,
      readOnly: readOnly ?? false,
      onTap: onTap,
      enabled: enabled,
     autofocus: autoFocus ?? false,
     enableInteractiveSelection: enableInteractiveSelection,
      focusNode: focusNode,
      keyboardType:keyboardType,
      textInputAction:  inputAction ?? TextInputAction.done,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      style: TextStyle(fontSize: SizeConfig.regularFontSize, fontFamily: fontMedium, height: 1.3),
      controller: controller,
      onChanged: onChanged,
      strutStyle: const StrutStyle(leading: 0.0),
      cursorColor: colorPrimary,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        filled: true,
        isDense: true,
        fillColor: textFieldFillColor,
        focusColor: colorWhite,
        hintText: hintText,
        hintStyle: TextStyle(color: normalTextColor , fontFamily: fontMedium ,fontSize: SizeConfig.regularFontSize),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: enabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: disabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: disabledBorder,
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
      ),
    );
  }
}*/


// ignore: must_be_immutable
class TextFormWidget extends StatelessWidget{
  FormFieldValidator<String>? validator;
  TextEditingController? controller;
  TextCapitalization? textCapitalization;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  String? labelText;
  String? hintText;
  ValueChanged<String>? onSubmitted;
  ValueChanged<String>? onChanged;
  GestureTapCallback? onTap;
  TapRegionCallback? onTapOutside;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry? contentPadding;
  FocusNode? focusNode;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Color? fillColor;
  Color? suffixIconColor;
  Color? prefixIconColor;
  Color? labelColor;
  Color? cursorColor;
  bool? enableInteractiveSelection;
  bool? enabled;
  bool? readOnly;
  bool? isDense;
  bool? autoCorrect;
  bool? autoFocus;
  Color? textColor;
  bool? allowDecimal;
  bool? allTwoDecimalPlaces;
  bool? onlyNumbers;
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  InputBorder? disabledBorder;
  InputBorder? focusedErrorBorder;
  InputBorder? errorBorder;
  TextAlign? textAlign;
  String? errorText;
  int? maxLines;
  AutovalidateMode? autoValidateMode;


  TextFormWidget(
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
      style: TextStyle(fontSize: SizeConfig.regularFontSize,color: textColor ?? colorBlack,
        fontWeight: FontWeight.normal,fontFamily: fontMedium),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor ??  colorPrimary,
      //strutStyle: const StrutStyle(leading: 0.0),
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
        fillColor:  fillColor ??  colorWhite,
        focusColor: colorWhite,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor ??  colorPrimary , fontFamily: fontMedium ,
            fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.normal),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey , fontFamily: fontMedium ,
            fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.normal),
        errorText: errorText,
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: enabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(color: disabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
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