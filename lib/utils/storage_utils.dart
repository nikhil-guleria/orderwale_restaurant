import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtils {

  static final StorageUtils utils = StorageUtils._internal();
  static const _sRestaurantName = 'restaurant.name';
  static const _sRestaurantImage = 'restaurant.image';
  static const _sRestaurantUserName = 'restaurant.user.name';
  static const _sRestaurantUserToken = 'restaurant.user.token';

   final String fcmOrderId = 'fcm_orderId';

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


  String get restaurantName => _storage.read(_sRestaurantName) ?? "";

  String get restaurantImage => _storage.read(_sRestaurantImage) ?? "";

  String get restaurantUserName => _storage.read(_sRestaurantUserName) ?? "";

  String get restaurantUserToken => _storage.read(_sRestaurantUserToken) ?? "";



   Future<void> saveSession({
    String? restaurantName, String? restaurantImage,
    String? restaurantUserName, String? restaurantUserToken
}) async {
   await _storeValue(key: _sRestaurantUserToken, value: restaurantUserToken);
   await _storeValue(key: _sRestaurantName, value: restaurantName);
   await _storeValue(key: _sRestaurantImage, value: restaurantImage);
   await _storeValue(key: _sRestaurantUserName, value: restaurantUserName);
}


    Future<void> clearSession() async {
    await removeKey(_sRestaurantName);
    await removeKey(_sRestaurantImage);
    await removeKey(_sRestaurantUserName);
    await removeKey(_sRestaurantUserToken);
  }





}