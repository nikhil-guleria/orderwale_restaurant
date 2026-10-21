import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_strings.dart';
import 'package:food_merchant/services/commonModels/cities_model.dart';
import 'package:food_merchant/services/commonModels/countries_model.dart';
import 'package:food_merchant/services/commonModels/states_model.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/repo/api_controller.dart';
import '../../../utils/common_utils.dart';


class NewUserController extends GetxController{

  var showLoader = false.obs;
  final formKey = GlobalKey<FormState>();
  var country = CountryData(name: "India", countryId: "1").obs;
  var stateList = <StateData>[].obs;
  var state = Rxn<StateData>();
  var cityList = <CityData>[].obs;
  var city = Rxn<CityData>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  FocusNode firstName = FocusNode();
  FocusNode lastName = FocusNode();
  FocusNode emailId = FocusNode();
  FocusNode phone = FocusNode();
  FocusNode pinCode = FocusNode();
  FocusNode addressFocus = FocusNode();

  @override
  void onReady() {
    fetchStatesList();
    super.onReady();
  }

  void setCountry(CountryData newCountry){
    FocusManager.instance.primaryFocus?.unfocus();
    country.value = newCountry;
    fetchStatesList();
  }

  void setCity(CityData newCity){
    FocusManager.instance.primaryFocus?.unfocus();
    city.value = newCity;
  }



  Future<void> fetchStatesList() async {
    if((stateList).isNotEmpty) {
      return;
    } else {
      var stateResponse = await ApiController().webRestaurantGetAllStates('1');
      if (stateResponse.responseCode == AppStrings.apiSuccess) {
        StatesModel ddModel = StatesModel.fromJson(
            stateResponse.response?.data);
        cityList.clear();
        city.value = null;
        state.value = null;
        stateList.value = ddModel.result ?? [];
      }
    }
  }


  Future<void> fetchCitiesList(BuildContext context, StateData newValue) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(state.value?.stateId == newValue.stateId &&
        (cityList).isNotEmpty){
      return;
    } else {
      state.value = newValue;
      cityList.clear();
      city.value = null;
      var cityResponse = await ApiController().webRestaurantGetAllCities(newValue.stateId ?? '-');
      if (cityResponse.responseCode == AppStrings.apiSuccess) {
        CitiesModel ddModel = CitiesModel.fromJson(
            cityResponse.response?.data);
        cityList.value = ddModel.result ?? [];
      } else {
        if(context.mounted) {
          CommonUtils.utils.handleAlertMsg(
              code: cityResponse.responseCode, message: cityResponse.msg);
        }
      }
    }
  }



  void goToSearchAddress(){
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.userAddress) ?.then((value) {
      if(value != null) {
        addressController.text = value;
      }
    });
  }


  void submitClick(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState?.validate() ?? false) {
      createOwnerRequest();
    } else {
      if(formKey.currentContext != null) {
        Scrollable.ensureVisible(
            formKey.currentContext!,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn);
      }
    }
  }


  Future<void> createOwnerRequest()  async {
    try {
      showLoader.value = true;
      var param = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "city_id": city.value?.cityId,
        "state_id": state.value?.stateId,
        "country_id": country.value.countryId,
        "pincode": pinCodeController.text.trim(),
        "address": addressController.text.trim()
      };
      var createOwner = await ApiController().webRestaurantRegistration(param);
      showLoader.value = false;
      if (createOwner.responseCode == AppStrings.apiSuccess) {
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        phoneController.clear();
        pinCodeController.clear();
        addressController.clear();
        cityList.clear();
        city.value = null;
        state.value = null;
        CommonUtils.utils.handleAlertMsg(
            title: AppStrings.alertTitleRegister,
            message: AppStrings.alertMsgRegisterRestaurant);
      } else {
        CommonUtils.utils.handleAlertMsg(
            code: createOwner.responseCode,
            message: AppStrings.alertMsgSomethingWentWrong);
      }
    } catch (e){
      CommonUtils.utils.handleAlertMsg(
          message: AppStrings.alertMsgSomethingWentWrong);
    }

  }







/*var countriesList =[].obs;
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
      CommonUtils.utils.handleAlertMsg(
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
      CommonUtils.utils.handleAlertMsg(
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
      CommonUtils.utils.handleAlertMsg(
          cities.responseCode, cities.msg);
    }
  }*/

}