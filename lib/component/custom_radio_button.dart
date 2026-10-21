import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';

import '../utils/size_config.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({super.key,
     required this.value,
     required this.groupValue,
     required this.onChanged,
     this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      splashColor: AppColors.white,
      highlightColor: AppColors.white,
      onTap: () => onChanged(value),
      child: SizedBox(
        height: SizeConfig.blockSizeHorizontal*10,
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(width: SizeConfig.blockSizeHorizontal*2),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      height: SizeConfig.blockSizeHorizontal*6.35,
      width: SizeConfig.blockSizeHorizontal*6.7,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.colorPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? AppColors.colorPrimary : AppColors.disabledBorderColor,
          width: 2,
        ),
      ),
      child: Visibility(
        visible: isSelected,
        child: Icon(
          Icons.check,
            color:  AppColors.white,
            size: SizeConfig.blockSizeHorizontal*4.9,
        ),
      ),
    );
  }
}