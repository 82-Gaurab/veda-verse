// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenreHiveModelAdapter extends TypeAdapter<GenreHiveModel> {
  @override
  final int typeId = 1;

  @override
  GenreHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenreHiveModel(
      genreId: fields[0] as String?,
      genreTitle: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GenreHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.genreId)
      ..writeByte(1)
      ..write(obj.genreTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
