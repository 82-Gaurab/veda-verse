import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String? bookId;
  final String title;
  final String author;
  final String imageUrl;
  final double rating;

  const BookEntity({
    this.bookId,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [bookId, title, author, imageUrl, rating];
}
