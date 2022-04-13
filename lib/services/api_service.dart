import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ketitik/models/newsdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/allnewsmodel.dart';
import '../models/category.dart';
import '../models/news.dart';
import '../models/privacymodel.dart';
import '../models/staticcontentmodel.dart';
import '../screens/bookmark/modelbookmark.dart';
import '../screens/prefrences/preferencemodel.dart';
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


  Future<List<BookMarkData>> getBookmarkNews(String token) async {
    try {
      var response = await http.post(Uri.parse(getBookmarkUrl),
          headers: {"token": token}).catchError((err) {
        print('Error : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = bookmarkFromJson(response.body);
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
  //cached allnews data
  Future<List<DataArticle>?> getAllArticles(  {required String filter, String? pageNumber}) async {
    try {
      var isCacheExist =
      await APICacheManager().isAPICacheKeyExist("API_Categories");
      print("pageNumber---->$pageNumber");

      if (!isCacheExist) {
        var response = await http.post(allnewsurls,
            headers: {},
            body: {"page": pageNumber.toString(),"filter": filter}).catchError((err)async {

          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
          APICacheDBModel(key: "API_Categories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = newsDataFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("API_Categories");
        print("chace hit");
        final news = newsDataFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      var cacheData = await APICacheManager().getCacheData("API_Categories");
      print("chace hit");
      final news = newsDataFromJson(cacheData.syncData);

      return news.data;
      return [];
    }
  }
  //cached top Stories data
  Future<List<DataArticle>?> getTopArticles(  {required String filter, String? pageNumber}) async {
    try {
      var isCacheExist =
      await APICacheManager().isAPICacheKeyExist("Top_Stories");
      print("pageNumber---->$pageNumber");

      if (!isCacheExist) {
        var response = await http.post(allnewsurls,
            headers: {},
            body: {"page": pageNumber.toString(),"filter": "top"}).catchError((err)async {

          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
          APICacheDBModel(key: "Top_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = newsDataFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("Top_Stories");
        print("chace hit");
        final news = newsDataFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      var cacheData = await APICacheManager().getCacheData("Top_Stories");
      print("chace hit");
      final news = newsDataFromJson(cacheData.syncData);

      return news.data;
      return [];
    }
  }
  //cached trending data
  Future<List<DataArticle>?> gettrendingArticles(  {required String filter, String? pageNumber}) async {
    try {
      var isCacheExist =
      await APICacheManager().isAPICacheKeyExist("Trending_Stories");
      print("pageNumber---->$pageNumber");

      if (!isCacheExist) {
        var response = await http.post(allnewsurls,
            headers: {},
            body: {"page": pageNumber.toString(),"filter": "top"}).catchError((err)async {

          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
          APICacheDBModel(key: "Trending_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = newsDataFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("Trending_Stories");
        print("chace hit");
        final news = newsDataFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      var cacheData = await APICacheManager().getCacheData("Trending_Stories");
      print("chace hit");
      final news = newsDataFromJson(cacheData.syncData);

      return news.data;
      return [];
    }
  }
  Future<List<DataArticle>?> getFeedArticles(  {required String filter, String? pageNumber, String? tokenAuth}) async {
    try {
      var isCacheExist =
      await APICacheManager().isAPICacheKeyExist("Feed_Stories");
      print("pageNumber---->$pageNumber");

      if (!isCacheExist) {
        var response = await http.post(allnewsurls,
            headers: {},
            body: {"page": pageNumber.toString(),"filter": "feeds"}).catchError((err)async {

          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
          APICacheDBModel(key: "Feed_Stories", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = newsDataFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("Feed_Stories");
        print("chace hit");
        final news = newsDataFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
      var cacheData = await APICacheManager().getCacheData("Feed_Stories");
      print("chace hit");
      final news = newsDataFromJson(cacheData.syncData);

      return news.data;
      return [];
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

  List<ArticleNews> shuffle(List<ArticleNews> items) {
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

  String getCurrentDate() {
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    print(date);
    return date; // 2021-06-24
  }

  Future<List<ArticleNews>?> getDataArticles({page}) async {
    String urlAll =
        "https://newsapi.org/v2/everything?q=*&apiKey=65408a0791c443a09c98d1fb22117f04&language=id&from=${getCurrentDate()}&sortBy=publishedAt&pageSize=20&page=$page";
    try {
      var response = await http.get(Uri.parse(urlAll)).catchError((err) {
        print('newsdata  : $err');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = APINews.fromJson(json.decode(response.body));

        List<ArticleNews> newsUpdated = shuffle(news.articles!);

        return newsUpdated;
      } else {
        print("newsdataelse : ");
        return [];
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return [];
    }
  }

  // Future<List<DataArticle>?> getAllArticles(
  //     {required String filter, String? pageNumber}) async {
  //   try {
  //     var response = null;
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
  //       // I am connected to a mobile network.
  //       response = await http.post(allnewsurls,
  //           headers: {},
  //           body: {"page": pageNumber, "filter": filter}).catchError((err) {
  //         print('newsdata  : $err');
  //       });
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final news = newsDataFromJson(response.body);
  //
  //         return news.data;
  //       } else {
  //         print("newsdataelse : ");
  //          return [];
  //       }
  //       // box.p;
  //     }else{
  //        List<DataArticle> offlinrRes =  await boxFetch('NewsDataservice');
  //        print("listofdata : ${offlinrRes.length}");
  //      return offlinrRes;
  //     }
  //
  //
  //   } catch (e) {
  //     print("Error ${e.toString()}");
  //     return [];
  //   }
  // }
  Future<List<DataArticle>> boxFetch(String name)async{
    var box = await Hive.openBox(name);
    var listdata = box.toMap();
    print("offline : $listdata");
    List<DataArticle> dataList= [];
    listdata.forEach((k,v) => dataList.add(v as DataArticle));

    return dataList;
  }



  getUserToken() {
    prefrenceService.getToken().then((value) => {userToken = value!});
    print("token : $userToken");
  }

  Future<List<DataArticle>?> getFeedsData(
      {required String filter, String? pageNumber, String? tokenAuth}) async {
    try {
      getUserToken();
      var response = null;

      print('AuthToken  : $tokenAuth');
      response = await http.post(allnewsurls,
          headers: {"token": tokenAuth.toString()},
          body: {"page": pageNumber, "filter": filter}).catchError((err) {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = newsDataFromJson(response.body);

        return news.data;
      } else {
        print("newsdataelse : ");
        return [];
      }
    } catch (e) {
      print("Error ${e.toString()}");
      return [];
    }
  }

  Future<List<CategoryName>> getMyPreference(String token) async {
    final url = Uri.parse(getPreferences);

    try {
      var response =
          await http.post(url, headers: {"token": token}).catchError((err) {
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

  saveUserPrefrence(String category, String deviceId, String authToken) async {
    final url =
        Uri.parse('http://83.136.219.147/News/public/api/userPreferences');

    Map<String, dynamic> mapData = {
      "category": category,
      "country": "[dl]",
      "device_id": deviceId,
    };

    try {
      var response =
          await http.post(url, headers: {"token": authToken}, body: mapData);

      if (response.statusCode == 200) {
        var reponseData = json.decode(response.body);
        print('reponseData : $reponseData');
        return reponseData;
      }
    } catch (e) {
      return e.toString();
    }
  }

  addBookmark(
      String? urlsss, String? news_id, String? title, String authToken) async {
    final url = Uri.parse(addBookmarkUrl);

    Map<String, dynamic> mapData = {
      "url": urlsss,
      "news_id": news_id,
      "title": title,
    };

    print('response Add Bookmark : $mapData');

    try {
      var response =
      await http.post(url, headers: {"token": authToken}, body: mapData);

      print('response Add Bookmark : ${response.body.toString()}');

      if (response.statusCode == 200) {
        var reponseData = json.decode(response.body);
        print('response Add Bookmark : $reponseData');
        return reponseData;
      }
    } catch (e) {
      print('response Add Bookmark : ${e.toString()}');

      return e.toString();
    }
  }
}



