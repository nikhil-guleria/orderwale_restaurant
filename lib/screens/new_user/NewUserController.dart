import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/DialogBox.dart';
import '../../routes/app_pages.dart';
import '../../services/repo/CommonRepo.dart';
import '../../utils/CommonUtils.dart';
import '../edit_details/models/CitiesModel.dart';
import '../edit_details/models/CountriesModel.dart';
import '../edit_details/models/StatesModel.dart';

class NewUserController extends GetxController{
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode firstName = FocusNode();
  FocusNode lastName = FocusNode();
  FocusNode emailId = FocusNode();
  FocusNode phone = FocusNode();
  FocusNode pinCode = FocusNode();
  FocusNode addressFocus = FocusNode();
  final formKey = GlobalKey<FormState>();


var showLoader = false.obs;
  var countriesList =[].obs;
  var statesList =[].obs;
  var citiesList = [].obs;
  var country = "Select Country".obs;
  var state =  "Select State".obs;
  var city ="Select City".obs;
  var countryId = "0".obs;
  var stateId = "0".obs;
  var cityId = "0".obs;


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



  goToSearchAddress(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(Routes.USER_ADDRESS) ?.then((value) {
      if(value != null) {
        addressController.text = value;
      }
    });
  }


  onSubmit(context){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()) {
      if (countryId.value == "0") {
        return Get.snackbar("Alert", " please select country",duration: const Duration(seconds: 2));
      } else if (stateId.value == "0") {
        return Get.snackbar("Alert", " please select state",duration: const Duration(seconds: 2));
      } else if (cityId.value == "0") {
        return Get.snackbar("Alert", " please select city",duration: const Duration(seconds: 2));
      }
      createOwnerRequest();
    }

  }


  createOwnerRequest()  async {
    showLoader.value = true;
   var param = {
      "first_name": firstNameController.text,
     "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "city_id": cityId.value,
      "state_id": stateId.value,
      "country_id": countryId.value,
      "pincode": pinCodeController.text,
      "address": addressController.text
    };
    var createOwner = await ApiController().createOwnerRequest(param);
    showLoader.value = false;
    if (createOwner.responseCode == 1) {
        Get.dialog(PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _){
            if(didPop) {
              return ;
            } else {
              Get.close(2);
            }
          },
          child: showDialogBox(title: "Alert",
            message: "Your request has been submitted.\nWe will contact you.",
            twoButtons: false,
            onConfirm: (){Get.close(2);}),
        ),
        barrierDismissible: false);
    }
    else {
      CommonUtils.utils.handleApiError(createOwner.responseCode, createOwner.msg);
    }

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




  String? validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex =  RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }




}