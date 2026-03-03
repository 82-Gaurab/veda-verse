import '../../domain/entities/order_entity.dart';

class OrderApiModel {
  final String id;
  final List<OrderBookApiModel> books;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrderApiModel({
    required this.id,
    required this.books,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    return OrderApiModel(
      id: json["_id"],
      books: (json["books"] as List)
          .map((e) => OrderBookApiModel.fromJson(e))
          .toList(),
      totalPrice: (json["totalPrice"]).toDouble(),
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      books: books.map((e) => e.toEntity()).toList(),
      totalPrice: totalPrice,
      status: status,
      createdAt: createdAt,
    );
  }

  static List<OrderEntity> toEntityList(List<OrderApiModel> models) {
    return models.map((e) => e.toEntity()).toList();
  }
}

class OrderBookApiModel {
  final String bookId;
  final String title;
  final double price;
  final int quantity;

  OrderBookApiModel({
    required this.bookId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  factory OrderBookApiModel.fromJson(Map<String, dynamic> json) {
    return OrderBookApiModel(
      bookId: json["bookId"]["_id"],
      title: json["bookId"]["title"],
      price: (json["bookId"]["price"]).toDouble(),
      quantity: json["quantity"],
    );
  }

  OrderBookEntity toEntity() {
    return OrderBookEntity(
      bookId: bookId,
      title: title,
      price: price,
      quantity: quantity,
    );
  }
}
