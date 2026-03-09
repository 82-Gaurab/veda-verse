import 'package:vedaverse/features/cart/data/models/cart_api_model.dart';
import 'package:vedaverse/features/cart/data/models/cart_hive_model.dart';

abstract interface class ICartRemoteDatasource {
  Future<bool> createCart(CartApiModel cart);
  Future<bool> updateCartItem(CartApiModel cart);
  Future<bool> deleteCartItem(String bookId);
  Future<List<CartApiModel>> getMyCart();
}

abstract interface class ICartLocalDatasource {
  Future<bool> addCartItem(CartHiveModel item);
  Future<bool> updateCartItem(CartHiveModel item);
  Future<bool> deleteCartItem(String bookId);
  Future<void> clearCart();
  List<CartHiveModel> getAllCartItems();
}
