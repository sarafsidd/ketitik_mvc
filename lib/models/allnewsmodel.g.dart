// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allnewsmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsAllAdapter extends TypeAdapter<NewsAll> {
  @override
  final int typeId = 2;

  @override
  NewsAll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsAll(
      success: fields[0] as bool,
      message: fields[1] as String,
      data: (fields[2] as List).cast<Article>(),
    );
  }

  @override
  void write(BinaryWriter writer, NewsAll obj) {
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
      other is NewsAllAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NewsAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 1;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      author: fields[0] as String,
      source: fields[1] as String,
      url: fields[2] as String,
      image: fields[3] as String,
      country: fields[4] as String,
      category: fields[5] as String,
      description: fields[6] as String,
      id: fields[7] as int,
      title: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
