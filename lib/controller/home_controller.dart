import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ketitik/models/newsdata.dart';
import 'package:ketitik/services/api_service.dart';

import '../utility/prefrence_service.dart';

class HomeController extends GetxController {
  RxBool isVisible = false.obs;
  RxInt pageNumber = 1.obs;
  RxList<DataArticle> list = <DataArticle>[].obs;
  APIService _apiService = APIService();
  RxString filter = "allNews".obs;
  RxInt indexCurrent = 0.obs;
  PrefrenceService prefrenceService = PrefrenceService();
  RxBool isLoggedin = false.obs;
  RxString userToken = "".obs;

  onTapVisibilty() {
    if (isVisible.value == true) {
      isVisible.value = false;
    } else {
      isVisible.value = true;
    }
  }

  getLoggedinStatus() {
    prefrenceService.getLoggedIn().then((value) => {isLoggedin.value = value});
  }

  getUserToken() {
    prefrenceService.getToken().then((value) => {userToken.value = value!});
  }

  resetData() {
    list.value.clear();
    pageNumber = 1.obs;
    indexCurrent = 0.obs;
  }

  Future<List<DataArticle>> getMyFeedData() async {
    resetData();

    list.value = (await _apiService.getFeedsData(
        filter: "feeds",
        pageNumber: pageNumber.value.toString(),
        tokenAuth: userToken.value))!;
    pageNumber.value = pageNumber.value + 1;

    return list.value;
  }

  Future<List<DataArticle>> getTopStoriesData() async {
    resetData();

    // list.value = (await _apiService.getAllArticles(
    //     filter: "top", pageNumber: pageNumber.value.toString()))!;
    try {
      final result = await InternetAddress.lookup('http://google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        list.value = (await _apiService.getAllArticles(
            filter: "top", pageNumber: pageNumber.value.toString()))!;
      }
    } on SocketException catch (_) {
      print('not connected');
      var box = await Hive.openBox<List<DataArticle>>('NewsDataservice');
      list.value = box.values.cast<DataArticle>().toList();
    }

    pageNumber.value = pageNumber.value + 1;

    print("ListData Top $pageNumber ${list.value.length}");

    return list.value;
  }

  Future<List<DataArticle>> getTrendingData() async {
    resetData();

    list.value = (await _apiService.getAllArticles(
        filter: "trending", pageNumber: pageNumber.value.toString()))!;

    pageNumber.value = pageNumber.value + 1;

    print("ListData Trending $pageNumber ${list.value.length}");

    return list.value;
  }

  Future<List<DataArticle>> getUpdatedList() async {
    return list.value;
  }

  Future<List<DataArticle>> getAllNewsData() async {
    resetData();

    list.value = (await _apiService.getAllArticles(
        filter: "allNews", pageNumber: pageNumber.value.toString()))!;

    pageNumber.value = pageNumber.value + 1;
    print("ListData All $pageNumber ${list.value.length}");

    return list.value;
  }

  getMoreData(int indexCurrentt) async {
    indexCurrent.value = indexCurrentt;
    List<DataArticle> moreList = <DataArticle>[];

    moreList = (await _apiService.getAllArticles(
        filter: filter.value, pageNumber: pageNumber.value.toString()))!;
    print("ListData More $pageNumber ${moreList.length}");

    if (moreList.isEmpty) {
    } else {
      pageNumber.value = pageNumber.value + 1;
      list.addAll(moreList);
      print("ListData More $pageNumber ${moreList.length}");
    }
  }

  @override
  void onInit() {
    super.onInit();
    onTapVisibilty();
    getUserToken();
    getAllNewsData();
  }
}
