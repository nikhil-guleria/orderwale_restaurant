import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/utils/Validations.dart';
import 'package:get/get.dart';
import '../../component/button_widget.dart';
import '../../component/ColorLoader.dart';
import '../../component/TextFormFieldWidget.dart';
import '../../component/TextWidget.dart';
import '../../constant/app_color.dart';
import '../../constant/app_constant.dart';
import '../../constant/app_images.dart';
import '../../constant/string_constants.dart';
import '../../utils/SizeConfig.dart';
import 'UpdateProfileController.dart';

class UpdateProfile extends GetView<UpdateProfileController>{
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
          backgroundColor: colorWhite,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: TextWidget(text: profileTitle,
                color: Colors.black,
                fontSize: SizeConfig.appbarTitleSize,
                fontFamily: fontSemiBold,
                weight: FontWeight.w600,),

            elevation: 0.0),
          body:  SafeArea(
            child: Obx(()=> controller.initialLoad.value ?
                Center(child: TextWidget(text: "Please wait...",color: colorPrimary,
                fontSize: SizeConfig.mediumFontSize,fontFamily: fontMedium)) :
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
                        border: Border.all(width: 3, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30)),
                    child: Stack(
                      children: <Widget>[
                        controller.fileImage.value != "" ?
            
                        Container(
                          height: SizeConfig.blockSizeHorizontal*30,
                          width:SizeConfig.blockSizeHorizontal*30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30)
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*30),
                              child: Image.file(File(controller.fileImage.value),  fit: BoxFit.cover,
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
                                imageUrl: controller.profileDetails.value.profileImage!,
                                placeholder: (context, url) => Image.asset(loadingGif, fit: BoxFit.cover),
                                errorWidget: (context, url, error) => Image.asset(appLogoTransparent),
                              )
                          ),
                        ),
            
                        Positioned(
                          bottom: SizeConfig.blockSizeHorizontal*0.75,
                          right: SizeConfig.blockSizeHorizontal*0.75,
                          child: GestureDetector(
                            onTap: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.dialog(AlertDialog(
                                backgroundColor: colorWhite,
                                  surfaceTintColor: colorWhite,
                                  title:  Text(
                                      "Select Image",textAlign: TextAlign.center,style: TextStyle(
                                    fontSize: SizeConfig.semiBoldFontSize,
                                    fontFamily: fontSemiBold,
                                  )),
                                  actionsPadding: const EdgeInsets.only(top: 0,bottom: 0),
                                  actions: [
                                    Center(
                                      child: MaterialButton(
                                          child:  Text(
                                            "Take Photo", style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                              fontFamily: fontMedium),),
                                          onPressed: (){
                                            Get.back(result: "Camera");
                                          }),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: ()  {
                                          Get.back(result: "Gallery");
                                        },
                                        child:  Text(
                                          "Choose From Library",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: fontMedium),),
                                      ),
                                    ),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: (){
                                          Get.back();},
                                        child:  Text(
                                            "Cancel",style: TextStyle(fontSize: SizeConfig.mediumFontSize,
                                            fontFamily: fontMedium)),
                                      ),
                                    ),
                                  ])).then((value) {
                                if(value == "Camera"){
                                  controller.getFromCamera();
                                } else if(value == "Gallery"){
                                  controller.getFromGallery();
                                }
                              });
            
                            },
            
            
                            /*onTap: () {
                              Get.dialog(AlertDialog(
                                  title: TextWidget(
                                    text: select_image,
                                    fontFamily: fontMedium,
                                    fontSize: SizeConfig.mediumFontSize,
                                    color: colorPrimary,
                                  ),
                                  actions: [
                                    MaterialButton(
                                        child: TextWidget(
                                          text: from_gallery,
                                          fontFamily: fontRegular,
                                          fontSize:
                                          SizeConfig.regularFontSize,
                                          color: colorBlack,
                                        ),
                                        onPressed: () {
                                          controller.getFromGallery();
                                          Get.back();
                                        }),
                                    MaterialButton(
                                        child: TextWidget(
                                          text: from_camera,
                                          fontFamily: fontRegular,
                                          fontSize:
                                          SizeConfig.regularFontSize,
                                          color: colorBlack,
                                        ),
                                        onPressed: () {
                                          controller.getFromCamera();
                                          Get.back();
                                        })
                                  ]));
                            },*/
                            child: Container(
                              height: SizeConfig.blockSizeHorizontal * 7.5,
                              width: SizeConfig.blockSizeHorizontal * 7.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7.5),
                                  color: colorPrimary,
                                  border: Border.all(
                                      width: 2, color: Colors.grey[300]!)),
                              child:  Icon(
                                controller.profileDetails.value.profileImage != "" ?
                                Icons.edit : Icons.add,
                                size: SizeConfig.blockSizeHorizontal * 3,
                                color: Colors.white,
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
                    TextWidget(
            text: fullName,
            fontFamily: fontMedium,
            fontSize: SizeConfig.mediumFontSize,
            color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    TextFormWidget(
            controller: controller.nameInputController,
            validator: Validations.validations.validateEmptyFields,
            focusNode: controller.focusName,
              onSubmitted:  (v) {
                FocusScope.of(context)
                    .requestFocus(controller.focusPhone);
              },
            textCapitalization: TextCapitalization.words,
            inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            
                    TextWidget(
            text: mobileNumber,
            fontFamily: fontMedium,
            fontSize: SizeConfig.mediumFontSize,
            color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                    TextFormWidget(
            controller: controller.phoneInputController,
            validator: Validations.validations.validatePhone,
            onlyNumbers: true,
            keyboardType: TextInputType.number,
            focusNode: controller.focusPhone,
              onSubmitted:  (v) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            inputAction: TextInputAction.done,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            
                    TextWidget(
            text: readOnlyEmail,
            fontFamily: fontMedium,
            fontSize: SizeConfig.mediumFontSize,
            color: normalTextColor,
                    ),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                Container(padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal* 2.5),
                    width: Get.width,
                    height: SizeConfig.blockSizeHorizontal * 13.8,
                    decoration: BoxDecoration(
                        color: textFieldFillColor,
                        border:
                        Border.all(color: disabledBorderColor, width: 1.3),
                        borderRadius: const BorderRadius.all(Radius.circular(
                          10.0,
                        ))),
                    child: Align(alignment: AlignmentDirectional.centerStart,
                      child: TextWidget(text: controller.emailInputController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                      ),
                    )),
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            
                    SizedBox(height: SizeConfig.blockSizeHorizontal * 8),
                    ButtonWidget(
            text: updateProfileBtn,
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
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
          ColorLoader()

        ],
      )
          : const SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);


  }
}


