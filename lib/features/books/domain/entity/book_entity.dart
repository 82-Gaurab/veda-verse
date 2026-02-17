import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String? bookId;
  final String title;
  final String author;
  final String? genre;
  final String? imageUrl;
  final String? publishedYear;
  final double rating;

  const BookEntity({
    this.bookId,
    required this.title,
    required this.author,
    this.imageUrl,
    required this.rating,
    this.genre,
    this.publishedYear,
  });

  @override
  List<Object?> get props => [
    bookId,
    title,
    author,
    imageUrl,
    rating,
    genre,
    publishedYear,
  ];
}
