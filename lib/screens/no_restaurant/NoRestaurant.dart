import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_colors.dart';
import '../../constant/app_images.dart';

class NoRestaurant extends StatelessWidget{
  const NoRestaurant({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: AppColors.white,
     body: Center(child: Image.asset(AppImages.noRestaurant)),
   );
  }

}