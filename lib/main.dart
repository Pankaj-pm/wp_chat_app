import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wp_chat_app/firebase_options.dart';
import 'package:wp_chat_app/home_page.dart';
import 'package:wp_chat_app/login_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'chat_app', // id
  'chat_app', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showLocalNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  tz.initializeTimeZones();
  InitializationSettings settings =
      const InitializationSettings(android: AndroidInitializationSettings("ic_notification"));

  await flutterLocalNotificationsPlugin.initialize(settings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var cu = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: cu != null ? const HomePage() : const LoginPage(),
    );
  }
}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

void showLocalNotification([RemoteMessage? remoteMessage]) async {


  /*
  {
    "to": "ewCdCPEaRamliaGBOju9BC:APA91bE1hqj5wHq_ueFrla9aq_d4L0MMC2BRhVzh-CkFlfuNWnrx8OB9UfIRJLJyV9JSG4L0Q10iVZy29daErzuubSVlyV2JXcXILUoLiLbCAWZPF_3iSyMyLBY6kZXoMaEt7fVIAfma",
    "notification": {
        "title": "Hey All",
        "body": "Good Day"
    },
    "data": {
        "img": "https://uploads-ssl.webflow.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png"
    }
}
  * */


  var img = remoteMessage?.data["img"];
  img ??="https://uploads-ssl.webflow.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png";

  final ByteArrayAndroidBitmap largeIcon =
      ByteArrayAndroidBitmap(await _getByteArrayFromUrl(img));

  flutterLocalNotificationsPlugin.show(
    0,
    remoteMessage?.notification?.title ?? "--",
    remoteMessage?.notification?.body ?? "--",
    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          priority: Priority.max,
          importance: Importance.max,
          largeIcon: largeIcon,
          styleInformation: MediaStyleInformation()),
    ),
  );
}

void showLocalNotification2() {
  // requestExactAlarmsPermission();
  flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    "Hello",
    "Good morning",
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "GROUP",
        "GROUP",
        priority: Priority.max,
        importance: Importance.max,
      ),
    ),
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
