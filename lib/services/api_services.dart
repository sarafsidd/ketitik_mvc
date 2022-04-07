import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ketitik/models/newsdata.dart';

import '../models/allnewsmodel.dart';
import '../models/category.dart';

class APIServices {
  final newsOrg =
      "https://newsapi.org/v2/top-headlines?country=id&apiKey=65408a0791c443a09c98d1fb22117f04";
  //65408a0791c443a09c98d1fb22117f04
  //final allnewsurl = "http://83.136.219.147/News/public/api/allnews_list";
  final allnewsurls =
      Uri.parse("http://83.136.219.147/News/public/api/allnews_list");
  final newsprefrence =
      Uri.parse("http://83.136.219.147/News/public/api/preferencesData");

  final searchUrl = Uri.parse("http://83.136.219.147/News/public/api/search");

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

  Future<List<Article>?> getDataArticles() async {
    final client = Dio();
  // var box = await Hive.openBox<NewsAll>('Newsservice');
    try {
      final response = await client.post(newsOrg);
      if (response.statusCode == 200) {
        final news = newsAllFromJson(response.data);
        log("newsdataif : ${news.data}");
       // box.add(news);
        return news.data;
      } else {
        log("newsdataelse : ");
        print('${response.statusCode} : ${response.data}');
        throw response.statusCode!;
      }
    } catch (error) {
      log("newsdataelse : $error");
      print(error);
    }
    return null;
  }

  Future<List<DataArticle>?> getAllArticles({int? pageNumber}) async {
    try {
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("All_News");

      if (!isCacheExist) {
        var response = await http.post(allnewsurls,
            headers: {},
            body: {"page": pageNumber.toString()}).catchError((err) {
          print('newsdata  : $err');
        });
        print("URl hit");
        if (response.statusCode == 200 || response.statusCode == 201) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "All_News", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          final news = newsDataFromJson(response.body);

          return news.data;
        } else {
          print("newsdataelse : ");
          return [];
        }
      } else {
        var cacheData = await APICacheManager().getCacheData("All_News");
        print("chace hit");
        final news = newsDataFromJson(cacheData.syncData);

        return news.data;
      }
    } catch (e) {
      print("Error ${e.toString()}");
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
      "device_id": deviceId,
    };
    try {
      var response = await http.post(url, body: mapData);
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
