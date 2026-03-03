import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/services/hive/hive_service.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/cart/data/datasource/cart_datasource.dart';
import 'package:vedaverse/features/cart/data/models/cart_hive_model.dart';

final cartLocalDatasourceProvider = Provider<ICartLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return CartLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class CartLocalDatasource implements ICartLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  CartLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<bool> addCartItem(CartHiveModel item) async {
    final authId = _userSessionService.getUserId();
    return await _hiveService.addOrUpdateCartItem(
      authId!,
      item.quantity,
      item.bookId,
      item,
    );
  }

  @override
  Future<bool> updateCartItem(CartHiveModel item) async {
    return _hiveService.updateCartItem(item);
  }

  @override
  Future<bool> deleteCartItem(String bookId) async {
    return _hiveService.deleteCartItem(bookId);
  }

  @override
  Future<void> clearCart() async {
    return _hiveService.clearCart();
  }

  @override
  List<CartHiveModel> getAllCartItems() {
    final authId = _userSessionService.getUserId();

    return _hiveService.getCart(authId!);
  }
}
