import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';
import '../../constant/app_images.dart';

class NoRestaurant extends StatelessWidget{
  const NoRestaurant({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: colorWhite,
     body: Center(child: Image.asset(noRestaurant)),
   );
  }

}