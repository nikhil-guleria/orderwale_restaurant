import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_merchant/constant/global_variables.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_pages.dart';


class PushNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static var storage = GetStorage();

  static Future<void> registerNotification() async {
   try {
     if (Platform.isAndroid) {
       await flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           AndroidFlutterLocalNotificationsPlugin>()
           ?.requestNotificationsPermission();
     }
     if (Platform.isIOS) {
       await flutterLocalNotificationsPlugin
           .resolvePlatformSpecificImplementation<
           IOSFlutterLocalNotificationsPlugin>()
           ?.requestPermissions(
         alert: true,
         badge: true,
         sound: true,
       );
     }


     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       showNotification(message);
       CommonUtils.utils.newOrderUpdate();
     });


     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
       log('onOpen app ==>$message');
       // await navigateAction(message);
     });

     firebaseMessaging.getToken().then((token) async {
       debugPrint('deviceToken ===> $token');
       GlobalVariables.token.value = "$token";
     }).catchError((err) {});
   } catch (e){
     debugPrint("exception token--> $e");
   }
  }

  static Future<void> fetchFCMToken() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }    firebaseMessaging.getToken().then((token)  {
      debugPrint('deviceToken ===> $token');
      GlobalVariables.token.value = "$token";
    }).catchError((err) {});
  }

  static Future<void> removeToken() async {
    await firebaseMessaging.deleteToken();
  }



  static Future<void> navigateAction(RemoteMessage message) async {
    Get.toNamed(Routes.ORDER_DETAILS, arguments: message.data["order_id"]);
    cancelNotification();
  }



   static Future<void> onSelectNotification(String payload) async {
    var message = jsonDecode(payload);
    var remoteMessage = RemoteMessage.fromMap({'data': message});
    await navigateAction(remoteMessage);
  }



  static void configLocalNotification() {
    var initializationSettingsAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher_round");
    var initializationSettingsIOS =  const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
      onSelectNotification(notificationResponse.payload!);}
    );
  }



  static void showNotification(RemoteMessage message) async {
    configLocalNotification();
    log('message${message.data}');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      "orderwalemerchant",
      "OrderWale",
          playSound: true,
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high,
          audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
        id: 0,
        title: (message.data["title"]).toString(),
        body: (message.data["body"]).toString(),
        notificationDetails: platformChannelSpecifics,
        payload: json.encode(message.data)
    );

  }



  static Future<void> createNotificationChannel() async{
    AndroidNotificationChannel channel =  const AndroidNotificationChannel(
        "orderwalemerchant",
        "OrderWale",
        playSound: true,
        enableVibration:true,
        enableLights: true,
        sound: RawResourceAndroidNotificationSound("orderwale"),
        importance: Importance.max,
        bypassDnd: true
    );

    await  flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

  }





  static void cancelNotification(){
    flutterLocalNotificationsPlugin.cancel(id: 0);
  }


}

