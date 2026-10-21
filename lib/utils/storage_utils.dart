import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtils {

  static final StorageUtils utils = StorageUtils._internal();
  static const _sRestaurantUserName = 'restaurant.user.name';
  static const _sRestaurantUserToken = 'restaurant.user.token';
  static const _sRestaurantUserRole = 'restaurant.user.role';
  static const sFCMOrderId = 'fcm_orderId';


  factory StorageUtils() {
    return utils;
  }

  StorageUtils._internal();

  final _storage = GetStorage();



   Future<void> _storeValue({required String key, dynamic value}) async {
     try {
       if (value != null) {
         await _storage.write(key, value.toString());
       }
     }catch(e){
       debugPrint("write storage exception $e");
     }
  }

  Future<void> removeKey(String key) async {
     try {
       await _storage.remove(key);
     } catch(e){
       debugPrint("remove storage exception $e");
     }
  }

  Future<void> removeFCMOrderId() async {
    await removeKey(sFCMOrderId);
  }




  String get restaurantUserName => _storage.read(_sRestaurantUserName) ?? "";

  String get restaurantUserToken => _storage.read(_sRestaurantUserToken) ?? "";

  String get restaurantUserRole => _storage.read(_sRestaurantUserRole) ?? "";

  String? get getFcmOrderId => _storage.read(sFCMOrderId);


   Future<void> saveSession({
    String? restaurantUserName,
     String? restaurantUserToken,
     String? userRole
}) async {
   await _storeValue(key: _sRestaurantUserToken, value: restaurantUserToken);
   await _storeValue(key: _sRestaurantUserRole, value: userRole);
   await _storeValue(key: _sRestaurantUserName, value: restaurantUserName);

}


    Future<void> clearSession() async {
    await removeKey(_sRestaurantUserToken);
    await removeKey(_sRestaurantUserRole);
    await removeKey(_sRestaurantUserName);
    await removeKey(sFCMOrderId);
  }





}