import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class CartApiModel {
  final String bookId;
  final int quantity;

  CartApiModel({required this.bookId, required this.quantity});

  // info: toJson
  Map<String, dynamic> toJson() {
    return {"bookId": bookId, "quantity": quantity};
  }

  factory CartApiModel.fromEntity(CartEntity entity) {
    return CartApiModel(bookId: entity.bookId, quantity: entity.quantity);
  }
}
