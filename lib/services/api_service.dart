import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ketitik/models/newsdata.dart';

import '../models/allnewsmodel.dart';
import '../models/category.dart';
import '../models/news.dart';
import '../models/privacymodel.dart';
import '../models/staticcontentmodel.dart';
import '../screens/prefrences/preferencemodel.dart';
import '../utility/prefrence_service.dart';

class APIService {
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

  Future<List<DataArticle>?> getAllArticles(
      {required String filter, String? pageNumber}) async {
    try {
      var response = null;
      var box = await Hive.openBox<List<DataArticle>>('NewsDataservice');

      response = await http.post(allnewsurls,
          headers: {},
          body: {"page": pageNumber, "filter": filter}).catchError((err) {
        print('newsdata  : $err');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final news = newsDataFromJson(response.body);
        box.add(news.data);
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

  getUserToken() {
    prefrenceService.getToken().then((value) => {userToken = value!});
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
}
