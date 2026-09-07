
import 'package:food_merchant/screens/profile/ProfileModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_pages.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';

class ProfileController extends GetxController{
  var showLoader = false.obs;
  var  profileDetails = ProfileModel().obs;
  @override
  void onInit() {
    getProfileDetails();
    super.onInit();
  }

  getProfileDetails() async {
    showLoader.value = true;
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
    var param = {
      "owner_id": "${ownerId["id"]}",
    };
    var ownerProfile = await ApiController().getOwnerProfile(param);
    showLoader.value = false;
    if (ownerProfile.responseCode == 1) {
      profileDetails.value = ProfileModel.fromJson(ownerProfile.response!.data['result']);
    }
    else {
      CommonUtils.utils.handleApiError(ownerProfile.responseCode, ownerProfile.msg);
    }
  }

  goToUpdateProfileScreen(){
    Get.toNamed(Routes.UPDATE_PROFILE,
        arguments: [profileDetails.value.profileImage,
          profileDetails.value.name,
          profileDetails.value.phone,
          profileDetails.value.email])
    ?.then((value) {
      profileDetails.value.name = value[1];
      profileDetails.value.phone = value[2];
    profileDetails.refresh();
    });
  }

  stringToDouble(String numberString){
    return double.parse(numberString);

  }
}