import 'package:equatable/equatable.dart';

class OrderBookEntity extends Equatable {
  final String bookId;
  final String title;
  final double price;
  final int quantity;

  const OrderBookEntity({
    required this.bookId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {"bookId": bookId, "quantity": quantity};
  }

  @override
  List<Object?> get props => [bookId, title, price, quantity];
}

class OrderEntity extends Equatable {
  final String id;
  final List<OrderBookEntity> books;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.books,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, books, totalPrice, status, createdAt];
}
