// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookHiveModelAdapter extends TypeAdapter<BookHiveModel> {
  @override
  final int typeId = 3;

  @override
  BookHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookHiveModel(
      bookId: fields[0] as String?,
      title: fields[1] as String,
      author: fields[2] as String,
      genre: (fields[3] as List?)?.cast<String>(),
      publishedYear: fields[4] as String?,
      description: fields[5] as String?,
      price: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BookHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.publishedYear)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
