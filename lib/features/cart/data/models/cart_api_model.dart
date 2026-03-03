import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class CartApiModel {
  final String bookId;
  final int quantity;
  final String? title;
  final String? author;
  final String? coverImg;
  final String? publishedYear;
  final double? price;

  CartApiModel({
    required this.bookId,
    required this.quantity,
    this.title,
    this.author,
    this.coverImg,
    this.publishedYear,
    this.price,
  });

  // info: from JSON
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      bookId: json["bookId"]["_id"],
      quantity: json["quantity"],
      title: json["bookId"]["title"],
      author: json["bookId"]["author"],
      publishedYear: json["bookId"]["publishedYear"],
      coverImg: json["bookId"]["coverImg"],
      price: (json["bookId"]["price"] as num).toDouble(),
    );
  }

  // info: toJson
  Map<String, dynamic> toJson() {
    return {"product": bookId, "quantity": quantity};
  }

  // info: to Entity
  CartEntity toEntity() {
    return CartEntity(
      bookId: bookId,
      quantity: quantity,
      author: author,
      title: title,
      coverImg: coverImg,
      price: price,
      publishedYear: publishedYear,
    );
  }

  // info: from Entity
  factory CartApiModel.fromEntity(CartEntity entity) {
    return CartApiModel(bookId: entity.bookId, quantity: entity.quantity);
  }

  //info: to Entity List
  static List<CartEntity> toEntityList(List<CartApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
