import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:ketitik/controller/auth_controller.dart';
import 'package:ketitik/screens/auth/views/register_screen.dart';
import 'package:ketitik/screens/prefrences/views/prefrence_screen.dart';
import 'package:ketitik/utility/prefrence_service.dart';

import '../../../utility/application_utils.dart';
import '../views/login_screen.dart';

class LoginController extends GetxController {
  final googleSignIn = GoogleSignIn();
  var googleAcc = Rx<GoogleSignInAccount?>(null);
  var isLoading = false.obs;
  PrefrenceService prefrenceService = PrefrenceService();
  Rx<bool> isLoggedIn = false.obs;
  Dio dio = Dio();
  String deviceId = "";

  String getDeviceId() {
    _getId().then((id) {
      deviceId = id!;
    });
    return deviceId;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // Unique ID on Android
    }
  }

  void signInWithGoogle() async {
    final _prefrence = PrefrenceService();
    try {
      isLoading.value = true;
      deviceId = getDeviceId();
      googleAcc.value = await googleSignIn.signIn().then((value) async {
        print(" Value : $value");
        ApplicationUtils.openDialog();

        var loginDb = await loginToDB(value!.email, value.id, deviceId);
        isLoggedIn.value = loginDb["status"];

        prefrenceService.setLoggedIn(loginDb["status"]);

        print("Google Acc : ${isLoggedIn.value}");
        print("Google Acc : $value");

        var googleKey = await value.authentication;
        print("Google Key : ${googleKey.accessToken}");

        print("loginDb: $loginDb");

        if (loginDb['status'] == true) {
          // ApplicationUtils.closeDialog();

          _prefrence.setName(loginDb['data']['name']);
          _prefrence.setEmail(loginDb['data']['email']);
          _prefrence.setPhone(loginDb['data']['contact']);
          _prefrence.setToken(loginDb['token']);

          ApplicationUtils.closeDialog();

          Get.to(() => PrefrenceScreen());
        } else {
          ApplicationUtils.closeDialog();

          print(" Display Name : ${value.displayName}");
          Get.to(() => RegisterScreen(
                name: value.displayName,
                emailID: value.email,
                socialID: value.id,
              ));
        }

        update();
        return value;
      });
    } catch (e) {
      ApplicationUtils.closeDialog();
      print("Errorrr => ${e.toString()}");
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    }
  }

  loginToDB(String emailID, String socialID, String deviceId) async {
    try {
      final url =
          Uri.parse('http://83.136.219.147/News/public/api/sociallogin');

      Map<String, dynamic> mapData = {
        "email": emailID,
        "device_id": deviceId,
        "social_id": socialID,
      };
      print("Data Body: ${mapData.toString()}");

      var response = await http.post(url, body: mapData);

      print("Data: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        print("Data: $data");
        update();
        return data;
      } else {
        var data = json.decode(response.body);
        return data;
      }
    } on DioError catch (error) {
      print("Catch : ${error.toString()}");
    }
  }

  registerToDB(String emailID, String socialID, String name, String deviceID,
      String contactNumber) async {
    deviceId = getDeviceId();
    final url =
        Uri.parse('http://83.136.219.147/News/public/api/socialregister');
    Map<String, dynamic> mapData = {
      "email_id": emailID,
      "social_id": socialID,
      "name": name,
      "device_id": deviceId,
      "contact": contactNumber,
    };
    try {
      var response = await http.post(url, body: mapData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var postData = json.decode(response.body);
        print("Post Data : $postData");
        update();
        return postData;
      }
    } catch (e) {
      print("Catch Error : ${e.toString()}");
      return e;
    }
  }

  signOut() async {
    try {
      googleAcc.value = await googleSignIn.signOut();
      if (googleAcc.value == null) {
        Get.to(() => const LoginScreen());
      } else {
        return;
      }
      update();
    } catch (e) {
      return e;
    }
  }

  void facebookLogin() async {
    LoginResult result = await FacebookAuth.instance.login();
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential fbCredentials =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCred = await Get.find<AuthController>()
            .firebaseAuth
            .signInWithCredential(fbCredentials);
        // user = userCred.user;
        // print("User : $user");
        break;
      case LoginStatus.cancelled:
        break;
      case LoginStatus.operationInProgress:
        break;
      default:
        break;
    }
  }
}

class Resources {
  Status? status;
  Resources({this.status});
}

enum Status { Success, Error, Cancel }
