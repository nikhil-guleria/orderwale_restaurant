import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import 'NotificationsModel.dart';

class NotificationsController extends GetxController{
var showLoader = false.obs;
var notificationsList = [].obs;

@override
void onInit() {
  fetchNotifications();
  super.onInit();
}

  fetchNotifications() async {
    showLoader.value = true;
    var storage = GetStorage();
    var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
   var  param = {"owner_id": "${ownerId["id"]}"} ;
    var notifications = await ApiController().getNotifications(param);
    showLoader.value = false;
    if (notifications.responseCode == 1) {
      NotificationsModel notificationsModel = NotificationsModel.fromJson(notifications.response!.data);
      notificationsList.clear();
      notificationsList.value = notificationsModel.result!;
    }
    else {
      CommonUtils.utils.handleApiError(notifications.responseCode, notifications.msg);
    }
  }

Future<void> pullRefresh() async {
  fetchNotifications();
}
}