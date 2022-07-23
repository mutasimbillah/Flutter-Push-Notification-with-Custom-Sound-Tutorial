import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/state_manager.dart';

class FcmService extends GetxService {
  //pre-config
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification_id', // id
    'NotificationName', // name
    description: 'Aanza Food user notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarm'),
    enableVibration: true,
  );

  //init local notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//Print Fcm Token
  Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print(token);
    return token;
  }

  //Display Notification
  displayNotification(RemoteNotification notification) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.yellow,
            importance: Importance.max,
            playSound: true,
            sound: const RawResourceAndroidNotificationSound('alarm'),
            icon: '@mipmap/ic_launcher',
          ),
        ));
  }

  //Background
  Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      displayNotification(notification);
    }
  }

  handleBackground() {
    //BackGround Handler
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  }

  handleForeground() {
    //Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        displayNotification(notification);
      }
    });
  }

  Future<FcmService> init() async {
    print('$runtimeType is ready!');

    await Firebase.initializeApp(
        //options: DefaultFirebaseOptions.currentPlatform,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //
    handleForeground();
    //Token
    //getToken();
    return this;
  }
}
