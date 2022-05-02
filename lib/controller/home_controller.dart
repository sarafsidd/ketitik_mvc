import 'dart:math';

import 'package:get/get.dart';
import 'package:ketitik/models/ketitiknews.dart';
import 'package:ketitik/services/api_service.dart';
import 'package:ketitik/utility/application_utils.dart';

import '../utility/prefrence_service.dart';

class HomeController extends GetxController {
  RxBool isVisible = false.obs;
  RxInt pageNumber = 1.obs;
  RxList<KetitikModel> list = <KetitikModel>[].obs;
  APIService _apiService = APIService();
  RxString filter = "allNews".obs;
  RxInt indexCurrent = 0.obs;
  RxInt bookmarkStatus = 0.obs;
  PrefrenceService prefrenceService = PrefrenceService();
  RxBool isLoggedin = false.obs;
  RxString userToken = "".obs;
  String deviceId = "";
  RxBool isLiked = false.obs;

  onTapVisibilty() {
    if (isVisible.value == true) {
      isVisible.value = false;
    } else {
      isVisible.value = true;
    }
  }

  updateValueList(int index) {
    var count = list.value[index].bookmarks;
    print("object $count");
    bookmarkStatus.value = count == 0 ? 1 : 0;
    list.value[index].bookmarks = count == 0 ? 1 : 0;
    print("object ${list.value[index].bookmarks}");
  }

  getLoggedinStatus() {
    prefrenceService.getLoggedIn().then((value) => {isLoggedin.value = value});
  }

  refreshToTop() {
    pageNumber = 1.obs;
    indexCurrent = 0.obs;
  }

  resetData() {
    list.value.clear();
    pageNumber = 1.obs;
    indexCurrent = 0.obs;
  }

  Future<List<KetitikModel>> getMyFeedData() async {
    resetData();

    list.value = (await _apiService.getFeedArticles(
        filter: "feeds",
        pageNumber: pageNumber.value.toString(),
        deviceId: deviceId))!;
    pageNumber.value = pageNumber.value + 1;

    return list.value;
  }

  Future<List<KetitikModel>> getTopStoriesData() async {
    resetData();
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    list.value = (await _apiService.getTopArticles(
        filter: "top",
        pageNumber: pageNumber.value.toString(),
        deviceId: deviceId))!;

    pageNumber.value = pageNumber.value + 1;

    print("ListData Top $pageNumber ${list.value.length}");

    return list.value;
  }

  List<KetitikModel> shuffle(List<KetitikModel> items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<List<KetitikModel>> getTrendingData() async {
    resetData();

    list.value = (await _apiService.gettrendingArticles(
        filter: "trending",
        pageNumber: pageNumber.value.toString(),
        deviceId: deviceId))!;

    pageNumber.value = pageNumber.value + 1;

    print("ListData Trending $pageNumber ${list.value.length}");

    return list.value;
  }

  Future<List<KetitikModel>> getUpdatedList() async {
    List<KetitikModel> newsUpdated = shuffle(list.value);
    return newsUpdated;
  }

  Future<List<KetitikModel>> getAllNewsData() async {
    resetData();

    list.value = (await _apiService.getAllArticles(
        filter: "allNews",
        pageNumber: pageNumber.value.toString(),
        deviceId: deviceId))!;

    pageNumber.value = pageNumber.value + 1;
    print("ListData All deviceToken $deviceId");

    return list.value;
  }

  getMoreData(int indexCurrentt) async {
    indexCurrent.value = indexCurrentt;
    List<KetitikModel> moreList = <KetitikModel>[];

    moreList = (await _apiService.getAllArticles(
        filter: filter.value,
        pageNumber: pageNumber.value.toString(),
        deviceId: deviceId))!;
    print("ListData More $pageNumber ${moreList.length}");

    if (moreList.isEmpty) {
    } else {
      pageNumber.value = pageNumber.value + 1;
      list.addAll(moreList);
      print("ListData More $pageNumber ${moreList.length}");
    }
  }

  getDeviceData() async {
    deviceId = await ApplicationUtils.getDeviceDetails();
    print("---- device $deviceId");
  }

  @override
  void onInit() {
    super.onInit();
    getDeviceData();
    onTapVisibilty();
    getAllNewsData();
  }
}
