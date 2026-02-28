import 'package:vedaverse/features/cart/data/models/cart_api_model.dart';

abstract interface class ICartRemoteDatasource {
  Future<bool> createCart(CartApiModel cart);
}
