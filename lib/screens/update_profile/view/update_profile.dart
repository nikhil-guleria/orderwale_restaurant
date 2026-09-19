import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/ColorLoader.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_images.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/constant/font_family.dart';
import 'package:food_merchant/screens/update_profile/controller/update_profile_controller.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:get/get.dart';


class UpdateProfile extends GetView<UpdateProfileController>{
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(title: AppStrings.profileTitle),
        body:  SafeArea(
          child: Obx(()=> controller.initialLoad.value ?
          Center(child: TextWidget(text: AppStrings.headingPleaseWait,
              color: AppColors.colorPrimary,
              fontSize: SizeConfig.mediumFontSize,fontFamily: FontFamily.fontMedium)) :
          Container(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth,
              padding: EdgeInsets.only(
                  bottom:  SizeConfig.blockSizeHorizontal*2,
                  left: SizeConfig.blockSizeHorizontal*3,
                  right: SizeConfig.blockSizeHorizontal*3),
              child: SingleChildScrollView(
                  child: Form(key: controller.formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.blockSizeHorizontal*2),
                          SizedBox(
                            height: SizeConfig.blockSizeHorizontal*32.5,
                            child: Center(
                              child: Container(
                                height: SizeConfig.blockSizeHorizontal*30,
                                width: SizeConfig.blockSizeHorizontal*30,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 3, color: AppColors.grey.shade300),
                                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30)),
                                child: Stack(
                                  children: <Widget>[
                                    controller.imageFile.value != null ?

                                    Container(
                                      height: SizeConfig.blockSizeHorizontal*30,
                                      width:SizeConfig.blockSizeHorizontal*30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30)
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30),
                                          child: Image.file(controller.imageFile.value!,  fit: BoxFit.cover,
                                              height: SizeConfig.blockSizeHorizontal*30,
                                              width: SizeConfig.blockSizeHorizontal*30)),
                                    )
                                        :

                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30)
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30),
                                          child: CachedNetworkImage(
                                            height: SizeConfig.blockSizeHorizontal*30,
                                            width:SizeConfig.blockSizeHorizontal*30,
                                            fit: BoxFit.cover,
                                            imageUrl: controller.profileDetails.value.restaurantThumbnail ?? '',
                                            placeholder: (context, url) => Image.asset(AppImages.loadingGif, fit: BoxFit.cover),
                                            errorWidget: (context, url, error) => Image.asset(AppImages.appLogoTransparent),
                                          )
                                      ),
                                    ),

                                    Positioned(
                                      bottom: SizeConfig.blockSizeHorizontal*0.75,
                                      right: SizeConfig.blockSizeHorizontal*0.75,
                                      child: GestureDetector(
                                        onTap: controller.pickImage,
                                        child: Container(
                                          height: SizeConfig.blockSizeHorizontal * 7.5,
                                          width: SizeConfig.blockSizeHorizontal * 7.5,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7.5),
                                              color: AppColors.colorPrimary,
                                              border: Border.all(
                                                  width: 2, color: AppColors.grey.shade300)),
                                          child:  Icon(
                                            (controller.profileDetails.value.restaurantImage ?? '').trim().isNotEmpty ?
                                            Icons.edit : Icons.add,
                                            size: SizeConfig.blockSizeHorizontal * 3,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeHorizontal * 3),


                          // full name
                          buildHeadingAndField(
                              heading: (controller.profileDetails.value.role ?? '').trim() != 'admin' ?
                              AppStrings.profileFullName : AppStrings.profileRestaurantName,
                          field:  CustomFormField(
                            controller: controller.nameInputController,
                            validator: Validations.validations.validateName,
                            textCapitalization: TextCapitalization.words,
                            inputAction: TextInputAction.done,
                          ),),


                          // email
                          buildHeadingAndField(
                              heading: AppStrings.headingEmail,
                              field: CustomFormField(
                                controller: controller.emailInputController,
                                inputAction: TextInputAction.done,
                                readOnly: true,
                              )),


                          // restaurant name
                          if((controller.profileDetails.value.role ?? '').trim() != 'admin')
                          buildHeadingAndField(
                              heading: AppStrings.profileRestaurantName,
                              field: CustomFormField(
                                controller: controller.restaurantNameController,
                                inputAction: TextInputAction.done,
                                readOnly: true,
                              ),),

                          // restaurant phone
                          buildHeadingAndField(
                              heading: AppStrings.profileRestaurantPhone,
                              field: CustomFormField(
                                  controller: controller.phoneInputController,
                                  onlyNumbers: true,
                                  readOnly: (controller.profileDetails.value.role ?? '').trim() != 'admin',
                                  inputAction: TextInputAction.done),),




                          SizedBox(height: SizeConfig.blockSizeHorizontal * 8),
                          ButtonWidget(
                            text: AppStrings.btnUpdate,
                            fontSize: SizeConfig.mediumFontSize,
                            onPressed: () {
                              controller.checkValidations();
                            },
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

                        ]),
                  )





              ))),
        ));
    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack( alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: AppColors.white),
          ),
          ColorLoader()

        ],
      )
          : const SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);


  }


  Widget buildHeadingAndField({
    required String heading, required Widget field
}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          text: heading,
          fontFamily: FontFamily.fontMedium,
          fontSize: SizeConfig.mediumFontSize,
          color: AppColors.normalTextColor,
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
        field,
        SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
      ],
    );
  }
}


