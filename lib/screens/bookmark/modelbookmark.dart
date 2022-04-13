// To parse this JSON data, do
//
//     final bookmark = bookmarkFromJson(jsonString);

import 'dart:convert';

Bookmark bookmarkFromJson(String str) => Bookmark.fromJson(json.decode(str));

String bookmarkToJson(Bookmark data) => json.encode(data.toJson());

class Bookmark {
  Bookmark({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<BookMarkData> data;

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    status: json["status"],
    message: json["message"],
    data: List<BookMarkData>.from(
        json["data"].map((x) => BookMarkData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BookMarkData {
  BookMarkData({
    required this.id,
    required this.title,
    required this.userId,
    required this.url,
    required this.bmkId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String userId;
  String url;
  int bmkId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory BookMarkData.fromJson(Map<String, dynamic> json) => BookMarkData(
    id: json["id"],
    title: json["title"],
    userId: json["user_id"],
    url: json["url"],
    bmkId: json["bmk_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "user_id": userId,
    "url": url,
    "bmk_id": bmkId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}