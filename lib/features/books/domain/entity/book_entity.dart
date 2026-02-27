import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String? bookId;
  final String title;
  final String author;
  final List<String>? genre;
  final String? coverImg;
  final String? publishedYear;
  final double price;

  const BookEntity({
    this.bookId,
    required this.title,
    required this.author,
    this.coverImg,
    required this.price,
    this.genre,
    this.publishedYear,
  });

  @override
  List<Object?> get props => [
    bookId,
    title,
    author,
    coverImg,
    price,
    genre,
    publishedYear,
  ];
}
