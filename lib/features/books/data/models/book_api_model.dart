import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

class BookApiModel {
  final String? bookId;
  final String title;
  final String author;
  final String? genre;
  final String? imageUrl;
  final String? publishedYear;
  final double rating;

  const BookApiModel({
    this.bookId,
    required this.title,
    required this.author,
    this.imageUrl,
    this.genre,
    this.publishedYear,
    required this.rating,
  });

  //note: From JSON
  factory BookApiModel.fromJson(Map<String, dynamic> json) {
    return BookApiModel(
      bookId: json["_id"] as String,
      title: json["title"] as String,
      author: json["author"] as String,
      genre: json["genre"] as String,
      publishedYear: json["publishedYear"] as String,
      rating: json["rating"] as double,
    );
  }
  //note: To JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "imageUrl": imageUrl,
      "publishedYear": publishedYear,
      "genre": genre,
      "rating": rating,
    };
  }

  //note: To Entity
  BookEntity toEntity() {
    return BookEntity(
      bookId: bookId,
      title: title,
      author: author,
      imageUrl: imageUrl,
      genre: genre,
      publishedYear: publishedYear,
      rating: rating,
    );
  }

  //note: From Entity
  factory BookApiModel.fromEntity(BookEntity entity) {
    return BookApiModel(
      title: entity.title,
      author: entity.author,
      imageUrl: entity.imageUrl,
      genre: entity.genre,
      publishedYear: entity.publishedYear,
      rating: entity.rating,
    );
  }
  //note: To Entity List
  static List<BookEntity> toEntityList(List<BookApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
