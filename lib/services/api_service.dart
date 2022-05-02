import 'dart:async';
import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:ketitik/models/newsdata.dart';

import '../models/category.dart';
import '../models/ketitiknews.dart';
import '../models/privacymodel.dart';
import '../models/staticcontentmodel.dart';
import '../screens/bookmark/modelbookmark.dart';
import '../screens/prefrences/preferencemodel.dart';
import '../utility/application_utils.dart';
import '../utility/prefrence_service.dart';

class APIService {
  final getBookmarkUrl = "http://83.136.219.147/News/public/api/getBookmarks";
  final addBookmarkUrl = "http://83.136.219.147/News/public/api/addBookmark";
  final getPreferences = "http://83.136.219.147/News/public/api/getPrefrences";

  final terms = "http://83.136.219.147/News/public/api/terms_condition";

  final privacy = "http://83.136.219.147/News/public/api/privacy";

  final allnewsurl = "http://83.136.219.147/News/public/api/allnews_list";
  final allnewsurls =
      Uri.parse("http://83.136.219.147/News/public/api/allnews_list");
  final newsprefrence =
      Uri.parse("http://83.136.219.147/News/public/api/preferencesData");

  final searchUrl = Uri.parse("http://83.136.219.147/News/public/api/search");

  final readNewsUrl = "http://83.136.219.147/News/public/api/readNews";
  String userToken = "";
  PrefrenceService prefrenceService = PrefrenceService();

  final updateProfile = "http://83.136.219.147/News/public/api/update_profile";

  Future<String> updateUserProfile(
      String name, String email, String phone, String authtoken) async {
    try {
      var response = await http.post(Uri.parse(updateProfile), headers: {
        "token": authtoken
      }, body: {
        "email_id": email,
        "name": name,
        "contact": phone
      }).catchError((err) {
        print('Error : $err');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("profile update ${response.body.toString()}");

        return response.body.toString();
      } else {
        print("profile update failed ${response.body.toString()}");
        return "";
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return "";
    }
  }

  Future<List<BookMarkData>> getBookmarkNews(String deviceId) async {
    try {
      var response = await http.post(Uri.parse(getBookmarkUrl),
          headers: {}, body: {"device_id": deviceId}).catchError((err) {
        print('Bookmark Error : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Bookmark news : ${response.body}");
        final news = bookMarkDataFromJson(response.body);

        return news.data;
      } else {
        print("Bookmark news : 0 Data");
        return [];
      }
    } catch (e) {
      print("Bookmark Error ${e.toString()}");
      return [];
    }
  }

  hitReadNewsApi(String newsId) async {
    try {
      var response = await http
          .post(Uri.parse(readNewsUrl), body: {"id": newsId}).catchError((err) {
        print('Error : $err');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("News Id Hit ${response.body.toString()}");
      } else {
        print("News Id Hit Failed${response.body.toString()}");
        return "";
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return "";
    }
  }

  Future<List<KetitikModel>?> getAllArticles(
      {required String filter, String? pageNumber, String? deviceId}) async {
    try {
      bool statusLogin = await prefrenceService.getLoggedIn();
      bool statusInternet = await ApplicationUtils.isOnline();

      if (statusInternet) {
        print("loginStatus---->$statusLogin");

        var response = await http.post(allnewsurls, headers: {}, body: {
          "device_id": deviceId,
          "page": pageNumber.toString(),
          "filter": filter
        }).catchError((err) async {
          print('newsdata  : $err');
        });

        print("URl hit");
        print("response ${response.body.toString()}");
        print("response ${response.statusCode.toString()}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "API_Categories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = keTitikNewsFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("API_Categories");
        print("chace hit");
        final news = keTitikNewsFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");

      return [];
    }
  }

  //cached top Stories data
  Future<List<KetitikModel>?> getTopArticles(
      {required String filter, String? pageNumber, String? deviceId}) async {
    try {
      print("pageNumber---->$pageNumber");
      bool statusInternet = await ApplicationUtils.isOnline();
      if (statusInternet) {
        var response = null;
        String tokenAuth = await prefrenceService.getAuthToken();
        print("authToken Top --->$tokenAuth");
        response = await http.post(allnewsurls, headers: {}, body: {
          "device_id": deviceId,
          "page": pageNumber.toString(),
          "filter": filter
        }).catchError((err) async {
          print('newsdata  : $err');
        });

        print("URl hit");
        print(" top stories ${response.body.toString()}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body.toString());
          final news = keTitikNewsFromJson(response.body);

          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "Top_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);

          return news.data;
        } else {
          print("newsdata else : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("Top_Stories");
        print("chace hit");
        final news = keTitikNewsFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return [];
    }
  }

  //cached trending data
  Future<List<KetitikModel>?> gettrendingArticles(
      {required String filter, String? pageNumber, String? deviceId}) async {
    try {
      var isCacheExist =
          await APICacheManager().isAPICacheKeyExist("Trending_Stories");
      print("pageNumber---->$pageNumber");

      bool statusInternet = await ApplicationUtils.isOnline();
      if (statusInternet) {
        var response = null;
        //if (statusLogin) {
        String tokenAuth = await prefrenceService.getAuthToken();
        response = await http.post(allnewsurls, headers: {}, body: {
          "device_id": deviceId,
          "page": pageNumber.toString(),
          "filter": filter
        }).catchError((err) async {
          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "Trending_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = keTitikNewsFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData =
            await APICacheManager().getCacheData("Trending_Stories");
        print("chace hit");
        final news = keTitikNewsFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return [];
    }
  }

  Future<List<KetitikModel>?> getFeedArticles(
      {required String filter, String? pageNumber, String? deviceId}) async {
    try {
      print("pageNumber---->$pageNumber");

      bool statusInternet = await ApplicationUtils.isOnline();
      if (statusInternet) {
        var response = await http.post(allnewsurls, headers: {}, body: {
          "page": pageNumber.toString(),
          "device_id": deviceId,
          "filter": filter
        }).catchError((err) async {
          print('newsdata  : $err');
        });

        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "Feed_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);

          final news = keTitikNewsFromJson(response.body);
          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("Feed_Stories");
        print("Cache Hit");
        final news = keTitikNewsFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  Future<String> getStaticPrivacy() async {
    try {
      var response = await http.post(Uri.parse(privacy)).catchError((err) {
        print('Error : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = staticPrivacyFromJson(response.body);
        print("Search news : ${news.data[0].privacy}");
        return news.data[0].privacy;
      } else {
        return "";
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return "";
    }
  }

  Future<String> getStaticTerms() async {
    try {
      var response = await http.post(Uri.parse(terms)).catchError((err) {
        print('Error : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = staticContentFromJson(response.body);
        print("Search news : ${news.data[0].terms}");
        return news.data[0].terms;
      } else {
        return "";
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return "";
    }
  }

  Future<List<DataArticle>?> searchNews(String query) async {
    try {
      var response =
          await http.post(searchUrl, body: {"key": query}).catchError((err) {
        print('Error : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = newsDataFromJson(response.body);
        print("Search news : ${news.data}");
        return news.data;
      } else {
        return [];
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return [];
    }
  }

  String getCurrentDate() {
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    print(date);
    return date; // 2021-06-24
  }

  getUserToken() {
    prefrenceService.getToken().then((value) => {userToken = value!});
    print("token : $userToken");
  }

  Future<List<CategoryName>> getMyPreference(String token) async {
    final url = Uri.parse(getPreferences);

    try {
      var response = await http.post(
        url,
        body: {"device_id": token},
      ).catchError((err) {
        print('Error : $err');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final category = preferenceFromJson(response.body);
        print("News : ${category.data}");
        return category.data.categoryName;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Preference>> getCategory() async {
    final url =
        Uri.parse('http://83.136.219.147/News/public/api/getAllCategory');

    try {
      var response = await http.get(url).catchError((err) {
        print('Error : $err');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final category = categoryFromJson(response.body);
        print("News : ${category.data}");
        return category.data!;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  saveUserPrefrence(String category, String deviceId) async {
    final url =
        Uri.parse('http://83.136.219.147/News/public/api/userPreferences');

    Map<String, dynamic> mapData = {
      "category": category,
      "country": "[dl]",
      "device_id": deviceId,
    };

    print("$category --- $deviceId ---- [dl]");

    try {
      var response = await http.post(url, headers: {}, body: mapData);

      if (response.statusCode == 200) {
        var reponseData = json.decode(response.body);
        print('reponseData : $reponseData');
        return reponseData;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addBookmark(
      String? urlsss, String? news_id, String? title, String authToken) async {
    String deviceId = await ApplicationUtils.getDeviceDetails();
    String responseStr = "";
    final url = Uri.parse(addBookmarkUrl);

    Map<String, dynamic> mapData = {
      "url": urlsss,
      "device_id": deviceId,
      "news_id": news_id,
      "title": title,
    };

    print('response Add Bookmark : $mapData');

    try {
      var response = await http.post(url, headers: {}, body: mapData);
      print('response Add Bookmark : ${response.body.toString()}');

      if (response.statusCode == 200) {
        responseStr = response.body;
        print('response Add Bookmark : $responseStr');
      }
    } catch (e) {
      print('response Add Bookmark : ${e.toString()}');
      return e.toString();
    }
    return responseStr;
  }
}
