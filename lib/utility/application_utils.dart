import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationUtils {
  static Future<void> openDialog() async {
    showDialog(
        context: Get.overlayContext!,
        builder: (_) => WillPopScope(
              child: const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              ),
              onWillPop: () async => false,
            ));
  }

  static String getAvatarImage(String id) {
    String avatarPath = "";
    if (id == "0") {
      avatarPath = "assets/images/menavatarnew.png";
    } else if (id == "1") {
      avatarPath = "assets/images/boyavatar.png";
    } else if (id == "2") {
      avatarPath = "assets/images/ladyavatar.png";
    } else if (id == "3") {
      avatarPath = "assets/images/girlavatar.png";
    }
    return avatarPath;
  }

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  static Future<void> closeDialog() async {
    Navigator.of(Get.overlayContext!).pop();
  }
}
