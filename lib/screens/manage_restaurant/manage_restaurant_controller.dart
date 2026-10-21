import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_merchant/component/image_picker/image_picker.dart';
import 'package:food_merchant/component/image_picker/picker_dialog.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:food_merchant/services/commonModels/cities_model.dart';
import 'package:food_merchant/services/commonModels/countries_model.dart';
import 'package:food_merchant/services/commonModels/states_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../constant/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../services/repo/api_controller.dart';
import '../../utils/common_utils.dart';
import '../restaurant_details/model/restaurant_details_model.dart';
import 'package:dio/dio.dart' as dio;



class ManageRestaurantController extends GetxController{
  var  restaurantsDetail = RestaurantDetailsModel().obs;
  Rxn<File> imageFile = Rxn<File>();
  var country = CountryData(name: "India", countryId: "1").obs;

  
  var showLoader = false.obs;
  var initialLoad = false.obs;
   var statesList = <StateData>[].obs;
   var citiesList = <CityData>[].obs;
   var state =  AppStrings.hintSelectState.obs;
   var city = AppStrings.hintSelectCity.obs;
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
  TextEditingController minOrderPriceController = TextEditingController();
  TextEditingController minDeliveryChargeController = TextEditingController();
  TextEditingController chargesPerKmController = TextEditingController();
  TextEditingController minDeliveryDistanceController = TextEditingController();
  TextEditingController freeDeliveryAmountController = TextEditingController();
  TextEditingController fssaiController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();


  @override
  void onInit() {
    initialLoad.value = true;
    restaurantDetails();
    super.onInit();
  }




   Future<void> restaurantDetails() async {
    try {
      showLoader.value = true;
      var restaurantDetails = await ApiController().restaurantDetailsManage();
      showLoader.value = false;
      initialLoad.value = false;
      if (restaurantDetails.responseCode == AppStrings.apiSuccess) {
        restaurantsDetail.value = RestaurantDetailsModel.fromJson(
            restaurantDetails.response?.data['result']);
        setDataFromApi();
      }
      else {
        if(restaurantDetails.responseCode == AppStrings.unauthenticated){
          await CommonUtils.utils.unauthenticatedRestaurant();
          return;
        }
        CommonUtils.utils.handleAlertMsg(
           code: restaurantDetails.responseCode,
           message: restaurantDetails.msg);
      }
    } catch (e){
      showLoader.value = false;
      initialLoad.value = false;
    }
   }

   void setDataFromApi(){
     restNameController.text = restaurantsDetail.value.name ?? '';
     emailController.text = restaurantsDetail.value.email ?? '';
     phoneController.text = restaurantsDetail.value.phone ?? '';
     state.value = restaurantsDetail.value.state ?? 'Select State';
     city.value = restaurantsDetail.value.city ?? "Select City";
     stateId.value = restaurantsDetail.value.stateId ?? '0';
     cityId.value = restaurantsDetail.value.cityId ?? '0';
     pinCodeController.text = restaurantsDetail.value.pinCode ?? '';
     addressController.text = restaurantsDetail.value.address ?? '';
     openingTimeController.text =
         timeApiToScreen(restaurantsDetail.value.openingTime);
     closingTimeController.text =
         timeApiToScreen(restaurantsDetail.value.closingTime);
     averagePriceController.text =
     "${restaurantsDetail.value.averagePrice ?? ''}";
     minOrderPriceController.text = restaurantsDetail.value.minOrderPrice ?? '';
     minDeliveryDistanceController.text =
         restaurantsDetail.value.minDeliveryDistance ?? '';
     minDeliveryChargeController.text =
         restaurantsDetail.value.minDeliveryCharges ?? '';
     chargesPerKmController.text = restaurantsDetail.value.chargesPerKm ?? '';
     freeDeliveryAmountController.text =
     "${restaurantsDetail.value.freeDeliveryAmount ?? ''}";
     fssaiController.text = restaurantsDetail.value.fssaiNo ?? '';

     GlobalVariables.selectedLocation = restaurantsDetail.value.address ?? '';
     GlobalVariables.restaurantLatLng =
         LatLng(double.tryParse(restaurantsDetail.value.latitude ?? "${AppStrings.hpLatitude}") ?? AppStrings.hpLatitude,
             double.tryParse(restaurantsDetail.value.longitude ?? '${AppStrings.hpLongitude}') ??  AppStrings.hpLongitude);
  }

  String timeApiToScreen(String? time){
    try {
      if ((time ?? '').trim().isEmpty) {
        return '';
      }
      return DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(time ?? ''));
    } catch (e){
      return '';
    }
  }

  Future<void> pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var path = await ImgPickerDialogBox.pickCroppedImagePath();
    if (path != null) {
      File original = File(path);
      File? compressed = await CustomImgPicker.compressTo1MB(original);
      if (compressed != null) {
        imageFile.value = compressed;
      }
    }
  }


  void setCountry(CountryData newCountry){
    FocusManager.instance.primaryFocus?.unfocus();
    country.value = newCountry;
  }

  Future<void> getState() async{
    if (statesList.isEmpty  || state.value == "Select State")
    {await getStatesApi(country.value.countryId ?? '1');}
    else {
      null;
    }
  }

  Future<void> getCity() async{
    if (citiesList.isEmpty || city.value == "Select City") {
      await getCitiesApi(stateId.value);}
  }


  Future<void> getStatesApi(String id) async{
    try {
      showLoader.value = true;
      var states = await ApiController().restaurantStates(id);
      showLoader.value = false;
      if (states.responseCode == AppStrings.apiSuccess) {
        StatesModel statesModel = StatesModel.fromJson(
            states.response?.data);
        statesList.value = statesModel.result ?? [];
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: states.responseCode,
            message: states.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }

  Future<void> getCitiesApi(String id) async{
    try {
      showLoader.value = true;
      var cities = await ApiController().restaurantCities(id);
      showLoader.value = false;
      if (cities.responseCode == AppStrings.apiSuccess) {
        CitiesModel citiesModel = CitiesModel.fromJson(
            cities.response?.data);
        citiesList.value = citiesModel.result ?? [];
      }
      else {
        CommonUtils.utils.handleAlertMsg(
            code: cities.responseCode,
            message: cities.msg);
      }
    } catch (e){
      showLoader.value = false;
    }
  }

  void goToMap() {
    FocusManager.instance.primaryFocus?.unfocus();
    LatLng latLng = LatLng(double.tryParse(restaurantsDetail.value.latitude ?? "${AppStrings.hpLatitude}") ?? AppStrings.hpLatitude,
        double.tryParse(restaurantsDetail.value.longitude ?? '${AppStrings.hpLongitude}') ??  AppStrings.hpLongitude);
    Get.toNamed(AppRoutes.map, arguments:latLng)?.then((value) {
      addressController.text = GlobalVariables.selectedLocation;
    });

  }


  Future<void> openingTimePicker(BuildContext context) async {
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
      openingTimeController.text = formattedTime;
    }
  }

  Future<void> closingTimePicker(BuildContext context) async {
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
      closingTimeController.text= formattedTime;
    }
  }






  void checkValidation(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      if(stateId.value == "0"){
         Get.snackbar(AppStrings.alertTitle, AppStrings.hintSelectState,duration: const Duration(seconds: 2));
         return;
      } else if(cityId.value == "0"){
         Get.snackbar(AppStrings.alertTitle, AppStrings.hintSelectCity,duration: const Duration(seconds: 2));
         return;
      }
      if(imageFile.value != null ||
          (restaurantsDetail.value.bannerImage ?? '').trim().isNotEmpty) {
        updateRestaurant();
      } else {
        Get.snackbar(AppStrings.alertTitle, AppStrings.hintSelectRestaurantImage,duration: const Duration(seconds: 2));
        return;
      }
    }
  }


     Future<void> updateRestaurant()  async {
    try {
      var newFileName = (imageFile.value?.path ?? '')
          .split('/').last;
      if (!newFileName.contains(".")) {
        newFileName = "$newFileName.png";
      }
      showLoader.value = true;
      dio.FormData formData = dio.FormData.fromMap({
        "name": restNameController.text.trim(),
        "phone": phoneController.text.trim(),
        "country_id": country.value.countryId,
        "state_id": stateId.value,
        "city_id": cityId.value,
        "pincode": pinCodeController.text.trim(),
        "address": addressController.text.trim(),
        "discount": "0",
        "discount_type": "0",
        "opening_time": timeScreenToApi(openingTimeController.text.trim()),
        "closing_time": timeScreenToApi(closingTimeController.text.trim()),
        "average_price": averagePriceController.text.trim(),
        "minimum_order_price": minOrderPriceController.text.trim(),
        "minimum_delivery_distance": minDeliveryDistanceController.text.trim(),
        "min_delivery_charges": minDeliveryChargeController.text.trim(),
        "charges_per_km": chargesPerKmController.text.trim(),
        "free_delivery_amount": freeDeliveryAmountController.text.trim(),
        "fssai_no": fssaiController.text.trim(),
        "latitude": "${GlobalVariables.restaurantLatLng.latitude}",
        "longitude": "${GlobalVariables.restaurantLatLng.longitude}",
        "profile_image": imageFile.value != null ?
        await dio.MultipartFile.fromFile(imageFile.value?.path ?? '',
            filename: newFileName)
            : null,
      });
      var restDetails = await ApiController().restaurantUpdateDetails(formData);
      showLoader.value = false;
      if (restDetails.responseCode == AppStrings.apiSuccess) {
        CommonUtils.utils.handleAlertMsg(
          message: AppStrings.alertMsgManageRestaurant,
          title: AppStrings.alertSuccess,
        );
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: restDetails.responseCode,
            message: restDetails.msg);
      }
    } catch (e){
      showLoader.value = false;
    }

  }

  String timeScreenToApi(String time){
    try {
      if(time.isEmpty) return '';
      DateTime parsedTime = DateFormat("hh:mm a").parse(time);
      return DateFormat("HH:mm:ss").format(parsedTime);
    } catch (e){
      return '';
    }
  }


}
