import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

class BookApiModel {
  final String? bookId;
  final String title;
  final String author;
  final String? description;
  final List<String>? genre;
  final String? coverImg;
  final String? publishedYear;
  final double price;

  const BookApiModel({
    this.bookId,
    required this.title,
    required this.author,
    this.coverImg,
    this.genre,
    this.publishedYear,
    required this.price,
    this.description,
  });

  //note: From JSON
  factory BookApiModel.fromJson(Map<String, dynamic> json) {
    return BookApiModel(
      bookId: json["_id"] as String,
      title: json["title"] as String,
      author: json["author"] as String,
      genre:
          (json["genre"] as List?)?.map((e) => e["name"] as String).toList() ??
          [],
      publishedYear: json["publishedYear"] as String,
      price: (json["price"] as num).toDouble(),
    );
  }
  //note: To JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "imageUrl": coverImg,
      "publishedYear": publishedYear,
      "genre": genre,
      "rating": price,
    };
  }

  //note: To Entity
  BookEntity toEntity() {
    return BookEntity(
      bookId: bookId,
      title: title,
      author: author,
      coverImg: coverImg,
      genre: genre,
      publishedYear: publishedYear,
      price: price,
    );
  }

  //note: From Entity
  factory BookApiModel.fromEntity(BookEntity entity) {
    return BookApiModel(
      title: entity.title,
      author: entity.author,
      coverImg: entity.coverImg,
      genre: entity.genre,
      publishedYear: entity.publishedYear,
      price: entity.price,
    );
  }
  //note: To Entity List
  static List<BookEntity> toEntityList(List<BookApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
