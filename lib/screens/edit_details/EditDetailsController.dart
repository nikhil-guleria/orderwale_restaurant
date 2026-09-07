import 'package:flutter/material.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:food_merchant/screens/edit_details/models/CitiesModel.dart';
import 'package:food_merchant/screens/edit_details/models/StatesModel.dart';
import 'package:food_merchant/utils/CheckPermission.dart';
import 'package:food_merchant/utils/ImagePicker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../component/DialogBox.dart';
import '../../constant/string_constants.dart';
import '../../routes/app_pages.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/GetStorageConstants.dart';
import '../restaurant_details/model/RestaurantDetailsModel.dart';
import 'models/CountriesModel.dart';
import 'package:dio/dio.dart' as dio;



class EditDetailsController extends GetxController{
  var storage = GetStorage();
  var restId ="".obs;
   ImagePicker imagePicker = ImagePicker();
 var imagePaths = [].obs;
 var fileImage = "".obs;
 var image = "".obs;
  var discountType = "".obs;
   var isHideIcon = true.obs;
  var  restaurantsDetail = RestaurantDetailsModel().obs;
  var showLoader = false.obs;
  var initialLoad = false.obs;
  var openingTime = "".obs;
  var closingTime = "".obs;
   var activePage = 0.obs;
   var countriesList =[].obs;
   var statesList =[].obs;
   var citiesList = [].obs;
   var country = "Select Country".obs;
   var state =  "Select State".obs;
   var city ="Select City".obs;
   var countryId = "0".obs;
   var stateId = "0".obs;
   var cityId = "0".obs;
  final formKey = GlobalKey<FormState>();


   PageController pageController = PageController(viewportFraction: 1,initialPage: 0);
  TextEditingController restNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController averagePriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController minOrderPriceController = TextEditingController();
  TextEditingController minDeliveryChargeController = TextEditingController();
  TextEditingController chargesPerKmController = TextEditingController();
  TextEditingController minDeliveryDistanceController = TextEditingController();
  TextEditingController freeDeliveryAmountController = TextEditingController();


  @override
  void onInit() {
    initialLoad.value = true;
    restaurantDetails();
    super.onInit();
  }

  onChangeType(String type){
    discountType.value = type;
  }

  goToMap() {
   /* Get.toNamed(Routes.GET_LOCATION)
        ?.then((value) {
      addressController.text = GlobalVariables.selectedLocation;
    });
*/

    LatLng latLng = LatLng(double.parse(restaurantsDetail.value.latitude!),
        double.parse(restaurantsDetail.value.longitude!));
    Get.toNamed(Routes.MAP, arguments:latLng)?.then((value) {
      addressController.text = GlobalVariables.selectedLocation;
    });

  }


  intToString(int value){
    return value.toString();
  }


  timeApiToScreen(time){
    return DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(time));
  }
timeScreenToApi( String time){
    DateTime parsedTime = DateFormat("hh:mm a").parse(time);
    return DateFormat("HH:mm:ss").format(parsedTime);
}
  openingTimePicker(context) async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      DateTime? parsedTime ;
      try {
         parsedTime = DateFormat("hh:mm a").parse(pickedTime.format(context));
      } catch (e){
         parsedTime = DateFormat("HH:mm").parse(pickedTime.format(context));
      }

      String formattedTime = DateFormat("hh:mm a").format(parsedTime);
      openingTime.value= formattedTime;
    }
  }


  closingTimePicker(context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },

    );
    if (pickedTime != null) {
      DateTime? parsedTime ;
      try {
        parsedTime = DateFormat("hh:mm a").parse(pickedTime.format(context));
      } catch (e){
        parsedTime = DateFormat("HH:mm").parse(pickedTime.format(context));
      }
      String formattedTime = DateFormat("hh:mm a").format(parsedTime);
     closingTime.value= formattedTime;
    }
  }



   getFromGallery()  async {
     var result = await RunTimePermissions.permissions.checkPermissions();
     if(result) {
       var path = await ImgPicker.pickImage("Gallery");
       if (path != null) {
         fileImage.value = path;
       }
     }

/*var paths = await ImgPicker.selectMultipleImages();
if (paths != null) {
  imagePaths.addAll(paths);
  imagePaths.refresh();
}*/
  }

   getFromCamera() async {

     var result = await RunTimePermissions.permissions.checkPermissions();
     if(result) {
       var path = await ImgPicker.pickImage("Camera");
        if (path != null) {
          fileImage.value = path;
          //imagePaths.add(path);
        }
      }
   }


 getCountry() async{
   if (countriesList.isEmpty){
     country.value = "Select Country";
     state.value = "Select State";
     city.value = "Select City";
     countryId.value = "0";
     stateId.value = "0";
     await getCountries();
   }
   else {
     null;
   }
 }
 getState() async{
   if (statesList.isEmpty  || state.value == "Select State")
   {await getStates(
       countryId.value);}
   else {
     null;
   }
 }
 getCity() async{
   if (citiesList.isEmpty || city.value == "Select City") {
     await getCities(stateId.value);}
 }

removeImages(){
  imagePaths.removeAt(activePage.value);
  imagePaths.refresh();
  if (activePage.value == imagePaths.length ){
 activePage.value = activePage.value-1;
  }
  imagePaths.length >1 ? isHideIcon.value = false : isHideIcon.value = true;
}




getCountries() async {

  showLoader.value = true;
  var countries = await ApiController().getCountries();
  showLoader.value = false;
  if (countries.responseCode == 1) {
    CountriesModel countriesModel = CountriesModel.fromJson(
        countries.response!.data);
    countriesList.value = countriesModel.result!;
  }
  else {
    CommonUtils.utils.handleApiError(
        countries.responseCode, countries.msg);
  }
}

getStates(var id) async{
  showLoader.value = true;
  var states = await ApiController().getAllStates(id);
  showLoader.value = false;
  if (states.responseCode == 1) {
    StatesModel statesModel =  StatesModel.fromJson(
        states.response!.data);
    statesList.value = statesModel.result!;
  }
  else {
    CommonUtils.utils.handleApiError(
        states.responseCode, states.msg);
  }
}
getCities(var id) async{
  showLoader.value = true;
  var cities = await ApiController().getAllCities(id);
  showLoader.value = false;
  if (cities.responseCode == 1) {
   CitiesModel citiesModel = CitiesModel.fromJson(
     cities.response!.data);
   citiesList.value = citiesModel.result!;
  }
  else {
    CommonUtils.utils.handleApiError(
        cities.responseCode, cities.msg);
  }
}
checkValidation(){
  FocusManager.instance.primaryFocus?.unfocus();
  if(formKey.currentState!.validate()) {
    if( countryId.value == "0"){
      return Get.snackbar(edit_screen_alert, "Please Select Country",duration: const Duration(seconds: 2));
    } else if(stateId.value == "0"){
      return Get.snackbar(edit_screen_alert, "Please Select State",duration: const Duration(seconds: 2));
    } else if(cityId.value == "0"){
      return Get.snackbar(edit_screen_alert, "Please Select City",duration: const Duration(seconds: 2));
    } else if(openingTime.value.isEmpty){
      return Get.snackbar(edit_screen_alert, "Please Select Opening Time",duration: const Duration(seconds: 2));
    } else if(closingTime.value.isEmpty){
      return Get.snackbar(edit_screen_alert, "Please Select Closing Time",duration: const Duration(seconds: 2));
    }
    if(fileImage.value.isNotEmpty || image.value.isNotEmpty) {
      updateRestaurant();
    } else {
      Get.snackbar(edit_screen_alert, "Please Select  Restaurant Image",duration: const Duration(seconds: 2));
    }

  }
}



   restaurantDetails() async {
     showLoader.value = true;
     restId.value = storage.read(GetStorageConstants.RESTAURANT_ID);
     print(restId.value);
     var restaurantDetails = await ApiController().getRestaurantDetails(restId.value);
     showLoader.value = false;
     initialLoad.value = false;
     if (restaurantDetails.responseCode == 1) {
         restaurantsDetail.value = RestaurantDetailsModel.fromJson(
             restaurantDetails.response!.data['result']);
         restNameController.text = restaurantsDetail.value.name!;
         emailController.text = restaurantsDetail.value.email!;
         phoneController.text = restaurantsDetail.value.phone!;
        country.value = restaurantsDetail.value.country!;
         state.value = restaurantsDetail.value.state!;
         city.value = restaurantsDetail.value.city!;
         countryId.value = restaurantsDetail.value.countryId!;
         stateId.value = restaurantsDetail.value.stateId!;
         cityId.value = restaurantsDetail.value.cityId!;
         pinCodeController.text = restaurantsDetail.value.pincode!;
         addressController.text = restaurantsDetail.value.address!;
         chargesPerKmController.text = restaurantsDetail.value.chargesPerKm!;
         minDeliveryChargeController.text = restaurantsDetail.value.minDeliveryCharges!;
         minOrderPriceController.text = restaurantsDetail.value.minOrderPrice!;
         minDeliveryDistanceController.text = restaurantsDetail.value.minDeliveryDistance!;
         GlobalVariables.selectedLocation = restaurantsDetail.value.address!;
         GlobalVariables.restaurantLatLng = LatLng(double.parse(restaurantsDetail.value.latitude!),
             double.parse(restaurantsDetail.value.longitude!));
         openingTime.value = timeApiToScreen(restaurantsDetail.value.openingTime!);
         closingTime.value = timeApiToScreen(restaurantsDetail.value.closingTime!);
         averagePriceController.text =
            "${restaurantsDetail.value.averagePrice!}";
         discountController.text =
             "${restaurantsDetail.value.discount!}";
         freeDeliveryAmountController.text =
             "${restaurantsDetail.value.freeDeliveryAmount!}";
         discountType.value = "${restaurantsDetail.value.discountType}";
        /* restaurantsDetail.value.bannerImage != ""?
         imagePaths.add(restaurantsDetail.value.bannerImage!) : null;*/
         image.value =  restaurantsDetail.value.bannerImage!;
         imagePaths.refresh();
       }
     else {
       CommonUtils.utils.handleApiError(
           restaurantDetails.responseCode, restaurantDetails.msg);
     }
   }


     updateRestaurant()  async {
   // var image = imagePaths[0].startsWith(RegExp('https')) ? imagePaths[1] : imagePaths[0];

       var newFileName = fileImage.value.split('/').last;
       if (!newFileName.contains(".")) {
         newFileName = "$newFileName.png";}
       showLoader.value = true;
       var storage = GetStorage();
       var ownerId = storage.read(GetStorageConstants.LOGIN_DATA);
       dio.FormData formData = dio.FormData.fromMap({
         "name": restNameController.text,
         "owner_id": "${ownerId["id"]}",
         "email": emailController.text,
         "phone": phoneController.text,
         "city_id": cityId.value,
         "state_id": stateId.value,
         "country_id": countryId.value,
         "pincode": pinCodeController.text,
         "address": addressController.text,
         "discount": "0"/*discountController.text*/,
         "discount_type":  "0"/*discountType.value*/,
         "average_price": averagePriceController.text,
         "opening_time": timeScreenToApi(openingTime.value),
         "closing_time": timeScreenToApi(closingTime.value),
         "latitude": "${GlobalVariables.restaurantLatLng.latitude}",
         "longitude": "${GlobalVariables.restaurantLatLng.longitude}",
         "charges_per_km" : chargesPerKmController.text,
         "min_delivery_charges": minDeliveryChargeController.text,
         "minimum_order_price" : minOrderPriceController.text,
         "minimum_delivery_distance" : minDeliveryDistanceController.text,
         "free_delivery_amount" : freeDeliveryAmountController.text,
       "profile_image":  fileImage.value != "" ? await dio.MultipartFile.fromFile(fileImage.value, filename: newFileName)
          : image.value
       });
       print(formData.fields);
     var restDetails = await ApiController().updateRestaurantDetails(formData, restId.value);
       showLoader.value = false;
     if (restDetails.responseCode == 1) {
       storage.write(GetStorageConstants.RESTAURANT_LATLNG, GlobalVariables.restaurantLatLng);
       //imagePaths.clear();
       //restaurantDetails();
       Get.dialog(PopScope(
         canPop: false,
         onPopInvoked: (didPop){
           if(didPop) {
             return ;
           } else {
             Get.close(2);
           }
         },
         child: showDialogBox(title: 'Restaurant Details',
           message: "Updated Successfully",
           twoButtons: false,
           onConfirm: (){Get.close(2);},
         ),
       ),
           barrierDismissible: false);
     } else {
       CommonUtils.utils.handleApiError(
           restDetails.responseCode, restDetails.msg);
     }

  }
 void deleteRestaurant() {
    Get.dialog(showDialogBox(title: edit_screen_alert,
      message: delete_rest,
      twoButtons: true,
      onCancel: () {
        Get.back();
      },
      onConfirm: (){ processDelete();},
      ));
  }

  processDelete() async {
    showLoader.value = true;
    var delete = await ApiController().deleteRestaurant(restId.value);
    showLoader.value = false;
    if (delete.responseCode == 1){
      Get.close(2);
    }
    else {
      CommonUtils.utils.handleApiError(
          delete.responseCode, delete.msg);
    }
  }





  }
