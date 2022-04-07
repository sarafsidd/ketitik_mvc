// To parse this JSON data, do
//
//     final newsAll = newsAllFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'allnewsmodel.g.dart';


NewsAll newsAllFromJson(String str) => NewsAll.fromJson(json.decode(str));

String newsAllToJson(NewsAll data) => json.encode(data.toJson());
@HiveType(typeId: 2,adapterName: "NewsAllAdapter")
class NewsAll {
  NewsAll({
    required this.success,
    required this.message,
    required this.data,
  });
  @HiveField(0)
  bool success;
  @HiveField(1)
  String message;
  @HiveField(2)
  List<Article> data;

  factory NewsAll.fromJson(Map<String, dynamic> json) => NewsAll(
        success: json["Success"],
        message: json["Message"],
        data: List<Article>.from(json["Data"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Success": success,
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
@HiveType(typeId: 1,adapterName: "NewsAdapter")
class Article {
  Article({
   required this.author,
    required this.source,
    required this.url,
    required this.image,
    required this.country,
    required this.category,
    required this.description,
    required this.id,
    required this.title,
  });
  @HiveField(0)
  String author;
  @HiveField(1)
  String source;
  @HiveField(2)
  String url;
  @HiveField(3)
  String image;
  @HiveField(4)
  String country;
  @HiveField(5)
  String category;
  @HiveField(6)
  String description;
  @HiveField(7)
  int id;
  @HiveField(8)
  String title;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        author: json["author"],
        source: json["source"],
        url: json["url"],
        image: json["image"] == null ? null : json["image"],
        country: json["country"],
        category: json["category"],
        description: json["description"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "source": source,
        "url": url,
        "image": image == null ? null : image,
        "country": country,
        "category": category,
        "description": description,
        "id": id,
        "title": title,
      };
}
