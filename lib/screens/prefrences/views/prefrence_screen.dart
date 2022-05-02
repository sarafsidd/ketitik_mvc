import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ketitik/utility/PreferenceModel.dart';
import 'package:ketitik/utility/application_utils.dart';
import 'package:ketitik/utility/colorss.dart';

import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../../../utility/prefrence_service.dart';
import '../../homescreen/view/home_screen.dart';
import '../widget/grid_item.dart';

class PrefrenceScreen extends StatefulWidget {
  PrefrenceScreen({Key? key}) : super(key: key);

  @override
  State<PrefrenceScreen> createState() => _PrefrenceScreenState();
}

class _PrefrenceScreenState extends State<PrefrenceScreen> {
  List<PreferenceModelSve> itemList = [];
  List<PreferenceModelSve> selectedList = [];
  PrefrenceService prefrenceService = PrefrenceService();
  List<Preference> allList = [];
  final APIService _apiService = APIService();
  var deviceId = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    deviceId = await ApplicationUtils.getDeviceDetails();
  }

  TopBar() {
    return Container(
        height: 80,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                MyColors.themeColor,
                MyColors.themeColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0]),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          border: Border.all(
            width: 1,
            color: MyColors.themeColor,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 15,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Select Preferences",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }

  getDataTotal(List<Preference> list) {
    itemList.clear();
    for (int i = 0; i < list.length; i++) {
      Preference pref = list[i];
      itemList.add(PreferenceModelSve("assets/images/gradyellotile.jpg",
          pref.categories.toString(), pref.id.toString()));
      print("-----------${itemList[i].name}");
    }
    print("${itemList.length.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopBar(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FutureBuilder<List<Preference>>(
                  future: _apiService.getCategory(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    allList = snapshot.data!;
                    getDataTotal(allList);
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          return GridItem(
                              item: itemList[index],
                              isSelectedVal: false,
                              isSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    selectedList.add(itemList[index]);
                                  } else {
                                    selectedList.remove(itemList[index]);
                                  }
                                });
                                print(
                                    "------ selected ${selectedList.length.toString()}");
                                print("$index : $value");
                              },
                              key: Key(itemList[index].id.toString()));
                        });
                  }),
            ),
            Spacer(),
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
                  ApplicationUtils.openDialog();
                  List<String> selectedListData = getSelected();

                  var selectedCat = await _apiService.saveUserPrefrence(
                      selectedListData.toString(), deviceId);
                  print("deviceId ${deviceId.toString()}");
                  print("selectedCat :${selectedList.toString()}");
                  if (selectedCat["status"] == true) {
                    prefrenceService.setPreferenceSaved(true);
                    selectedList.clear();
                    ApplicationUtils.closeDialog();
                    Get.to(
                      () => MyHomePage.withA(),
                    );
                  } else {
                    ApplicationUtils.closeDialog();
                    selectedList.clear();
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

  List<String> getSelected() {
    List<String> listData = [];
    for (int i = 0; i < selectedList.length; i++) {
      listData.add(selectedList[i].id);
    }
    return listData;
  }
/*  List<String> getSelectedChipId() {
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
  }*/
}
