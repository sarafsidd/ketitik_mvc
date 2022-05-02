import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../../../utility/PreferenceModel.dart';
import '../../../utility/application_utils.dart';
import '../../../utility/colorss.dart';
import '../../../utility/prefrence_service.dart';
import '../../homescreen/view/home_screen.dart';
import '../preferencemodel.dart';
import '../widget/grid_item.dart';

class MyPrefrenceScreen extends StatefulWidget {
  List<CategoryName> cateName = [];

  MyPrefrenceScreen({Key? key, required this.cateName}) : super(key: key);

  @override
  State<MyPrefrenceScreen> createState() => _PrefrenceScreenState();
}

class _PrefrenceScreenState extends State<MyPrefrenceScreen> {
  List<PreferenceModelSve> itemList = [];
  List<PreferenceModelSve> selectedList = [];
  List<String> selectedStrList = [];
  PrefrenceService prefrenceService = PrefrenceService();

  List<Preference> allList = [];
  final APIService _apiService = APIService();

  var deviceId = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getSelectedData() {
    for (int i = 0; i < widget.cateName.length; i++) {
      print("Selected ONly ${widget.cateName[i].categories}");
    }
  }

  getData() async {
    deviceId = await ApplicationUtils.getDeviceDetails();
  }

  TopBar() {
    return Container(
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
          children: [
            InkWell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/left.png",
                  width: 25,
                  height: 25,
                ),
              ),
              onTap: () => {ApplicationUtils.onBackPress(context)},
            ),
            const SizedBox(
              width: 15,
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "My Saved Preferences",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }

  bindSavedData() {
    for (int i = 0; i < widget.cateName.length; i++) {
      selectedStrList.add(widget.cateName[i].id.toString());
    }
  }

  bool getSavedStatus(String categoryName) {
    bool isSaved = false;
    for (int i = 0; i < widget.cateName.length; i++) {
      if (categoryName == widget.cateName[i].categories) {
        isSaved = true;
      }
    }
    return isSaved;
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
            //showContent(),
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
                              isSelectedVal:
                                  getSavedStatus(itemList[index].name),
                              isSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    selectedList.add(itemList[index]);
                                    selectedStrList.add(itemList[index].id);
                                  } else {
                                    selectedList.remove(itemList[index]);
                                    selectedStrList.remove(itemList[index].id);
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
                  'Update Preference',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  bindSavedData();
                  //getDataSelected();
                  ApplicationUtils.openDialog();
                  var selectedCat = await _apiService.saveUserPrefrence(
                      selectedStrList.toString(), deviceId);
                  print("deviceId ${deviceId.toString()}");
                  print("selectedCat :${selectedStrList.toString()}");
                  if (selectedCat["status"] == true) {
                    selectedStrList.clear();
                    ApplicationUtils.closeDialog();
                    Get.to(
                      () => MyHomePage.withA(),
                    );
                  } else {
                    ApplicationUtils.closeDialog();
                    selectedStrList.clear();
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

  getDataSelected() {
    for (int i = 0; i < selectedList.length; i++) {
      selectedList.add(selectedList[i]);
    }
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
}
