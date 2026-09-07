import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';

import '../utils/SizeConfig.dart';

class MyRadioListTile extends StatelessWidget {
  final  value;
  final  groupValue;
  final  leading;
  final  title;
  final  onChanged;

  const MyRadioListTile({
     this.value,
     this.groupValue,
     this.onChanged,
     this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      splashColor: colorWhite,
      highlightColor: colorWhite,
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
        color: isSelected ? colorPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? colorPrimary : disabledBorderColor,
          width: 2,
        ),
      ),
      child: Visibility(
        visible: isSelected,
        child: Icon(
          Icons.check,
            color:  colorWhite,
            size: SizeConfig.blockSizeHorizontal*4.9,

        ),
      ),
    );
  }
}