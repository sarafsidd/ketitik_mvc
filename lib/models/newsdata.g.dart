// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newsdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsDataAdapter extends TypeAdapter<NewsData> {
  @override
  final int typeId = 3;

  @override
  NewsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsData(
      success: fields[0] as bool,
      message: fields[1] as String,
      data: (fields[2] as List).cast<DataArticle>(),
    );
  }

  @override
  void write(BinaryWriter writer, NewsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataArticleAdapter extends TypeAdapter<DataArticle> {
  @override
  final int typeId = 4;

  @override
  DataArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataArticle(
      author: fields[1] as String?,
      source: fields[2] as String?,
      url: fields[3] as String?,
      image: fields[4] as String?,
      country: fields[5] as String?,
      category: fields[6] as String?,
      description: fields[7] as String?,
      id: fields[8] as int?,
      title: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataArticle obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
