// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

CategoryData categoryFromJson(String str) =>
    CategoryData.fromJson(json.decode(str));

String categoryToJson(CategoryData data) => json.encode(data.toJson());

class CategoryData {
  CategoryData({
    this.status,
    this.data,
  });

  String? status;
  List<Preference>? data;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        status: json["status"],
        data: List<Preference>.from(
            json["data"].map((x) => Preference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Preference {
  Preference({
    this.id,
    this.categories,
  });

  int? id;
  String? categories;

  factory Preference.fromJson(Map<String, dynamic> json) => Preference(
        id: json["id"],
        categories: json["categories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categories": categories,
      };
}
