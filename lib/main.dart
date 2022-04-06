import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ketitik/screens/auth/binding/login_binding.dart';
import 'package:ketitik/utility/app_route.dart';
import 'package:ketitik/utility/colorss.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        // textTheme: TextTheme(
        // )
      ),
      // home: ProfilePage(),
    );
  }
}
