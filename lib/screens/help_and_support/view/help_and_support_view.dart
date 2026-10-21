import 'package:flutter/material.dart';
import 'package:food_merchant/component/button_widget.dart';
import 'package:food_merchant/component/color_loader.dart';
import 'package:food_merchant/component/custom_form_field.dart';
import 'package:food_merchant/component/custom_text_widget.dart';
import 'package:food_merchant/constant/app_colors.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/screens/help_and_support/controller/help_and_support_controller.dart';
import 'package:food_merchant/screens/help_and_support/models/help_and_support_model.dart';
import 'package:food_merchant/utils/size_config.dart';
import 'package:food_merchant/utils/validations.dart';
import 'package:get/get.dart';

class HelpAndSupportView extends GetView<HelpAndSupportController>{
const HelpAndSupportView({super.key});

@override
Widget build(BuildContext context) {
  List<Widget> widgetList = [];
  var child = Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(title: AppStrings.helpAndSupportTitle),
      body: SafeArea(
          child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeHorizontal * 2,
                horizontal: SizeConfig.blockSizeHorizontal * 4),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // images
                  buildImagesSection(),
                  SizeConfig.verticalSpace16,

                  // phone
                  buildInputFieldHeading(AppStrings.headingPhone),
                    CustomFormField(
                      controller: controller.phoneController,
                      onlyNumbers: true,
                      validator: Validations.validations.validatePhone,
                      inputAction: TextInputAction.next),
                    SizeConfig.verticalSpace16,

                    // description
                    buildInputFieldHeading(AppStrings.headingDescription),
                    CustomFormField(
                      maxLines: 7,
                      controller: controller.descriptionController,
                      validator: Validations.validations.validateEmptyFields,
                    ),
                    SizeConfig.verticalSpace20,


                    ButtonWidget(
                      text: AppStrings.btnSubmit,
                      onPressed: () {
                        controller.submitClick();
                      },
                    ),

                    SizeConfig.verticalSpace8,



                ]
                ),
              )
            ),
          )),
  );

  widgetList.add(child);
  final modal = Obx(
        () => controller.showLoader.value
        ? Stack(
      alignment: Alignment.center,
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



// images section: add-image button + up to 3 thumbnails with remove option
Widget buildImagesSection() {
  const int maxImages = 3;

  return Obx(()=> Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildInputFieldHeading("Images"),
      SizeConfig.verticalSpace8,
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // existing image thumbnails
          for (int index = 0; index < controller.images.length; index++)
            _imageThumbnail(
              image: controller.images[index],
              onRemove: () => controller.removeImage(index),
            ),

          // add-image button (hidden once max reached)
          if (controller.images.length < maxImages)
            _addImageButton(
              onTap: controller.imgLoader.value ? null
                  : () => controller.uploadImgClick(),
              isLoading: controller.imgLoader.value,
            ),
        ],
      ),
    ],
  ));
}

Widget _imageThumbnail({
  required HelpSupportImageModel image,
  required VoidCallback onRemove,
}) {
  return SizedBox(
    width: 75,
    height: 75,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
          child: image.imageBytes != null
              ? Image.memory(
            image.imageBytes!,
            width: 75,
            height: 75,
            fit: BoxFit.cover,
          )
              : Container(
            width: 75,
            height: 75,
            color: AppColors.white,
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.padding2),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cancel, color: AppColors.red,
                  size: SizeConfig.icon20),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _addImageButton({required VoidCallback? onTap, bool isLoading = false}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
    child: Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorPrimary),
        borderRadius: BorderRadius.circular(SizeConfig.borderRadius8),
      ),
      child: isLoading
          ? Center(
        child: ColorLoader(),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: AppColors.colorPrimary),
          SizeConfig.verticalSpace4,
          TextWidget(
            text: AppStrings.btnAddImg,
            fontSize: SizeConfig.smallTextSize,
            color: AppColors.colorPrimary,
          ),
        ],
      ),
    ),
  );
}
}