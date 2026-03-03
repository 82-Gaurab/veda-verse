import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String bookId;
  final String? title;
  final String? author;
  final double? price;
  final String? publishedYear;
  final String? coverImg;
  final int quantity;

  const CartEntity({
    required this.bookId,
    this.title,
    this.author,
    this.price,
    this.publishedYear,
    this.coverImg,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    bookId,
    title,
    author,
    price,
    publishedYear,
    coverImg,
    quantity,
  ];
}
