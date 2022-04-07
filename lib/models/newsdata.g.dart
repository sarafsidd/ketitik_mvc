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
