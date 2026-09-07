import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../component/DialogBox.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CheckPermission.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import '../../utils/ImagePicker.dart';
import '../profile/ProfileModel.dart';

class UpdateProfileController extends GetxController{
  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();

  var showLoader = false.obs;
  var initialLoad = true.obs;
  final formKey = GlobalKey<FormState>();

  final focusName = FocusNode();
  final focusPhone = FocusNode();
  final focusEmail = FocusNode();
  var fileImage = "".obs;
  var  profileDetails = ProfileModel().obs;


  @override
  void onInit() {
    getProfileDetails();
    super.onInit();
  }



  Future<void> getProfileDetails() async {
    showLoader.value = true;
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var param = {
      "owner_id": "${ownerId["id"]}",
    };
    var ownerProfile = await ApiController().getOwnerProfile(param);
    showLoader.value = false;
    if (ownerProfile.responseCode == 1) {
      initialLoad.value = false;
      profileDetails.value = ProfileModel.fromJson(ownerProfile.response!.data['result']);
      nameInputController.text = profileDetails.value.name!;
      phoneInputController.text = profileDetails.value.phone!;
      emailInputController.text = profileDetails.value.email!;
    }
    else {
      CommonUtils.utils.handleApiError(ownerProfile.responseCode, ownerProfile.msg);
    }
  }


  Future<void> getFromGallery()  async {
    var result = await RunTimePermissions.permissions.checkPermissions();
    if(result) {
      var path = await ImgPicker.pickImage("Gallery");
      if (path != null) {
        fileImage.value = path;
      }
    }
  }

  Future<void> getFromCamera() async {
    var result = await RunTimePermissions.permissions.checkPermissions();
    if(result) {
      var path = await ImgPicker.pickImage("Camera");
      if (path != null) {
        fileImage.value = path;
      }
    }
  }


  void checkValidations(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      if (nameInputController.text != profileDetails.value.name ||
          phoneInputController.text != profileDetails.value.phone ||
          fileImage.value.isNotEmpty) {
        updateProfile();
      }
    }
  }


Future<void> updateProfile() async{
      var newFileName = fileImage.value.split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";}
  showLoader.value = true;
  var storage = GetStorage();
  var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    dio.FormData formData = dio.FormData.fromMap({
      "first_name": nameInputController.text,
      "id": "${ownerId["id"]}",
      "phone": phoneInputController.text,
      "email": emailInputController.text,
    "image": fileImage.value != "" ? await dio.MultipartFile.fromFile(fileImage.value, filename: newFileName)
        : profileDetails.value.profileImage!
    });

    var updateProfile = await ApiController().updateOwnerProfile(formData);
  showLoader.value = false;
  if (updateProfile.responseCode == 1) {

    Get.dialog(PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) {
          return ;
        } else {
          Get.close(2);
        }
      },
      child:   showDialogBox(title: 'Profile',
        message: "Updated Successfully",
        twoButtons: false,
        onConfirm: (){Get.close(2);},
      ),
    ),
        barrierDismissible: false);
  }
  else {
    CommonUtils.utils.handleApiError(updateProfile.responseCode, updateProfile.msg);
  }
}





}