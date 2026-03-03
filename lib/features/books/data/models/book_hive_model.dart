import 'package:hive/hive.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

part 'book_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bookTypeId)
class BookHiveModel extends HiveObject {
  @HiveField(0)
  final String? bookId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final List<String>? genre;

  @HiveField(4)
  final String? publishedYear;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final double price;

  BookHiveModel({
    this.bookId,
    required this.title,
    required this.author,
    this.genre,
    this.publishedYear,
    this.description,
    required this.price,
  });

  // Hive → Entity
  BookEntity toEntity() {
    return BookEntity(
      bookId: bookId,
      title: title,
      author: author,
      genre: genre,
      publishedYear: publishedYear,
      description: description,
      price: price,
    );
  }

  // Entity → Hive
  factory BookHiveModel.fromEntity(BookEntity entity) {
    return BookHiveModel(
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      genre: entity.genre,
      publishedYear: entity.publishedYear,
      description: entity.description,
      price: entity.price,
    );
  }
}
