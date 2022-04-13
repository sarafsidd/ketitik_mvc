import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ketitik/utility/application_utils.dart';
import 'package:ketitik/utility/colorss.dart';

import '../../../controller/profile_controller.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../../homescreen/view/home_screen.dart';
import '../widget/multi_select_chip.dart';

class PrefrenceScreen extends StatefulWidget {
  PrefrenceScreen({Key? key}) : super(key: key);

  @override
  State<PrefrenceScreen> createState() => _PrefrenceScreenState();
}

class _PrefrenceScreenState extends State<PrefrenceScreen> {
  List<String> selectedCategoryList = [];
  List<String> selectedCategoryIds = [];
  List<Preference> allList = [];
  final APIService _apiService = APIService();

  var deviceId = "";
  ProfileController profileController = ProfileController();
  List<Preference> categoryList = [];

  @override
  void initState() {
    super.initState();
    profileController.getUserData();
    deviceId = getDeviceId();
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'Select Preferences',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //showContent(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FutureBuilder<List<Preference>>(
                  future: _apiService.getCategory(),
                  builder: (context, snapshot) {
                    var category = snapshot.data;
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    allList = snapshot.data!;
                    return MultiSelectChip(
                      category!,
                      onSelectionChanged: (selectedList) {
                        setState(
                          () {
                            selectedCategoryList.addAll(selectedList);
                          },
                        );
                      },
                    );
                  }),
            ),
            const Spacer(),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    primary: MyColors.themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: MyColors.themeColor,
                    )),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  var listIds = getSelectedChipId();
                  ApplicationUtils.openDialog();
                  var selectedCat = await _apiService.saveUserPrefrence(
                      listIds.toString(),
                      deviceId,
                      profileController.authToken.value);
                  print("deviceId ${deviceId.toString()}");
                  print("selectedCat :${selectedCategoryIds.toString()}");
                  if (selectedCat["status"] == true) {
                    selectedCategoryIds.clear();
                    ApplicationUtils.closeDialog();
                    Get.to(
                      () =>  MyHomePage.withA(),
                    );
                  } else {
                    ApplicationUtils.closeDialog();
                    selectedCategoryIds.clear();
                    Get.snackbar('Error', 'Something Went Wrong');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSelectedChipId() {
    for (int i = 0; i < selectedCategoryList.length; i++) {
      String selectedItem = selectedCategoryList[i];
      for (int j = 0; j < allList.length; j++) {
        Preference AllItem = allList[j];
        if (AllItem.categories == selectedItem) {
          if (!selectedCategoryIds.contains(AllItem.id)) {
            selectedCategoryIds.add(AllItem.id.toString());
          }
        }
      }
    }
    print("Last selected one ${selectedCategoryIds.toString()}");
    return selectedCategoryIds;
  }
}
