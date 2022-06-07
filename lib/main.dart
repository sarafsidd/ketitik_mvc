import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ketitik/screens/auth/binding/login_binding.dart';
import 'package:ketitik/utility/app_route.dart';
import 'package:ketitik/utility/colorss.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'com.app.ketitik.ketitik', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  print("data Object Background ::  ${message.data}");
  flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: "@mipmap/ic_ketitiknew",
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_ketnew'),
        ),
      ));

  parseNotificationData(message.data);
  // Get.to(NotificationDetailPage("id"));
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });

  String? title;
  String? body;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

parseNotificationData(Map<String, dynamic> response) {
  var _data = jsonDecode(response["news_id"]);

  print("Sorted Notifiction Bundle :: $_data");
}

class _MyAppState extends State<MyApp> {
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_ketitiknew');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          print("data Object Initial :: ${message.data}");
          parseNotificationData(message.data);
          //Get.to(NotificationDetailPage("id"));
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("data Object OnMessage :: ${message.data}");
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_ketitiknew",
                largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_ketnew'),
              ),
            ));

        print("data Object OnMessage :: ${message.data}");
        parseNotificationData(message.data);

        //Get.to(NotificationDetailPage("id"));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      print("Notification MessageOpen :: ${notification?.body}");
      print("data Object OnOpened :: ${message.data}");
      parseNotificationData(message.data);

      //Get.to(NotificationDetailPage("id"));
    });

    getToken();
  }

  String? token;

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
  }

  parseNotificationData(Map<String, dynamic> response) {
    var _data = jsonDecode(response["news_id"]);
    print("Sorted Notifiction Bundle :: $_data");
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: LoginBinding(),
      title: 'KeTitik',
      initialRoute: RoutingNameConstants.SPLASH_SCREEN_ROUTE,
      getPages: AppRoute.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColors.themeColorYellow,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colors.black),
        primarySwatch: Colors.yellow,
        fontFamily: 'Montserrat',
      ),
      // home: ProfilePage(),
    );
  }
}
