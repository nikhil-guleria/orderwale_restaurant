import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:food_merchant/myApp.dart';
import 'package:food_merchant/utils/CommonUtils.dart';
import 'package:food_merchant/utils/GetStorageConstants.dart';
import 'package:food_merchant/utils/PushNotifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await GetStorage.init();
  if(message.notification == null) {
    showCallkitIncoming(message.data["title"],message.data["body"]);
    _handleCall(message.data["order_id"]);
  }
}




Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // initialize Get Storage
  await GetStorage.init();

  // initialize Fire Base
  await Firebase.initializeApp();
  await PushNotificationService.createNotificationChannel();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await PushNotificationService.registerNotification();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}


Future<void> showCallkitIncoming(String title, String description) async {
  var uuid = const Uuid();
  final params = CallKitParams(
    id: uuid.v4(),
    nameCaller: title,
    appName: 'OrderWale Restaurant',
    avatar: 'assets/logo',
    handle: description,
    type: 0,
    duration: 30000,
    textAccept: 'Show Order',
    textDecline: 'Decline',
    missedCallNotification:  const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Pending Order',
      callbackText: 'Show Order',
    ),
   /* extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},*/
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      isShowCallID: true,
      ringtonePath: 'orderwale',
      backgroundUrl: 'assets/lock_screen_bg.png',
      actionColor: '#FF8B3D',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: "Incoming Call",
      missedCallNotificationChannelName: "Missed Call",
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );

  await FlutterCallkitIncoming.showCallkitIncoming(params);
}



_handleCall(dynamic fcmOrderId) async {
  try {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print('HOME: $event');
      switch (event!.event) {
        case Event.actionCallIncoming:
        // TODO: received an incoming call
        print("Event --- ${event.event}");
          break;
        case Event.actionCallStart:
        // TODO: started an outgoing call
        // TODO: show screen calling in Flutter
          print("Event --- ${event.event}");
          break;
        case Event.actionCallAccept:

          print("Event --- ${event.event}");

          var storage = GetStorage();
          storage.write(GetStorageConstants.fcmOrderId , "$fcmOrderId");
          print("saving order id --> $fcmOrderId");



          final SendPort? send = IsolateNameServer.lookupPortByName('fcm_Message');
          send?.send("$fcmOrderId");

          break;
        case Event.actionCallDecline:
          //await FlutterCallkitIncoming.endAllCalls();

          print("Event --- ${event.event}");
          // TODO: declined an incoming call
          //await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
          break;
        case Event.actionCallEnded:
          print("Event --- ${event.event}");
        // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          print("Event --- ${event.event}");
        // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          print("Event --- ${event.event}");

          var storage = GetStorage();
          storage.write(GetStorageConstants.fcmOrderId , fcmOrderId);
          final SendPort? send = IsolateNameServer.lookupPortByName('fcm_Message');
          send?.send(fcmOrderId);

          break;
        case Event.actionCallToggleHold:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          print("Event --- ${event.event}");
        // TODO: only iOS
          break;
        case Event.actionCallCustom:
          print("Event --- ${event.event}");
          break;
      }
      //  callback(event);
    });
  } on Exception catch (e) {
    print(e);
  }
}
