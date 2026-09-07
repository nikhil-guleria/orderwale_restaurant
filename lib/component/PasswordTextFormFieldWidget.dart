import 'package:flutter/material.dart';

import '../constant/app_color.dart';
import '../constant/app_constant.dart';
import '../utils/SizeConfig.dart';

// ignore: must_be_immutable
/*class PasswordTextFormWidget extends StatelessWidget{
  final validator;
  TextEditingController? controller;
  final textCaptalisation;
  final keyboardType;
  final inputAction;
  var hintText;
  final onSubmitted;
  final onChanged;
  FocusNode? focusNode;
  bool obscureText;
  final toggel;
  final enableBorderColor;
  final disableBorderColor;
  final iconColor;
  final cursorColor;

  PasswordTextFormWidget(
      {this.hintText,
        this.textCaptalisation,
        this.inputAction,
        this.keyboardType,
        this.obscureText = true,
        this.validator,
        this.controller,
        this.focusNode,
        this.toggel,
        this.onSubmitted,
        this.onChanged,
      this.enableBorderColor,
      this.disableBorderColor,
      this.iconColor,
      this.cursorColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      focusNode: focusNode,
      keyboardType:keyboardType,
      textInputAction:  inputAction ?? TextInputAction.done,
      onFieldSubmitted: onSubmitted,
      textCapitalization: textCaptalisation ?? TextCapitalization.none,
      style:  TextStyle(fontSize:  SizeConfig.regularFontSize,fontFamily: fontMedium,height: 1.3),
      strutStyle: const StrutStyle(leading: 0.0),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor ?? colorPrimary,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(obscureText
              ? Icons.visibility_off_sharp
              :Icons.visibility_sharp,
              color:  iconColor ?? enabledBorderColor,
              size: SizeConfig.mediumFontSize),
          onPressed: toggel,
        ),
        filled: true,
        isDense: true,
        fillColor: textFieldFillColor,
        focusColor: colorWhite,
        hintText: hintText,
        hintStyle:  TextStyle(color: normalTextColor , fontFamily: fontMedium,fontSize:  SizeConfig.regularFontSize),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: enableBorderColor ??enabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: disableBorderColor ?? disabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
  
  
  

}*/


// ignore: must_be_immutable
class PasswordTextFormWidget extends StatelessWidget{
  FormFieldValidator<String>? validator;
  TextEditingController? controller;
  TextCapitalization? textCapitalization;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  String? hintText;
  String? labelText;
  ValueChanged<String>? onSubmitted;
  ValueChanged<String>? onChanged;
  GestureTapCallback? onTap;
  FocusNode? focusNode;
  bool obscureText;
  VoidCallback? toggle;
  Color? cursorColor;
  Color? fillColor;
  Color? labelColor;
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  InputBorder? disabledBorder;
  InputBorder? focusedErrorBorder;
  InputBorder? errorBorder;
  int? maxLines;
  bool isOwner;
  Color? iconColor;
  Color? enableBorderColor;
  Color? disableBorderColor;

  PasswordTextFormWidget(
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
        this.isOwner = false,
        this.iconColor,
        this.enableBorderColor,
        this.disableBorderColor
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
      style: TextStyle(fontSize:  SizeConfig.regularFontSize,color: colorBlack,
        fontWeight: FontWeight.normal,fontFamily: fontMedium),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor ??  colorPrimary,
      //strutStyle: const StrutStyle(leading: 0.0),
      obscureText: obscureText,
      decoration: InputDecoration(
        errorMaxLines: 3,
        suffixIcon: IconButton(
          icon: Icon(obscureText
              ? Icons.visibility_off_outlined
              :Icons.visibility_outlined,
              color: iconColor ?? enabledBorderColor,
              size: 20),
          onPressed: toggle,
        ),
        filled: true,
        isDense: true,
        fillColor: fillColor ?? colorWhite,
        focusColor: colorWhite,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor ??  colorPrimary , fontFamily: fontMedium ,fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.normal),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontFamily: fontMedium,fontSize: SizeConfig.regularFontSize, fontWeight: FontWeight.normal),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: enableBorderColor ?? enabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: disableBorderColor ?? disabledBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

}