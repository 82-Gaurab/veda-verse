// Notifier provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/cart/domain/usecases/create_cart_usecase.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);

class CartViewModel extends Notifier<CartState> {
  late final CreateCartUsecase _createCartUseCase;

  @override
  CartState build() {
    _createCartUseCase = ref.read(createCartUsecaseProvider);
    return CartState();
  }

  Future<void> createCart({
    required String bookId,
    required int quantity,
  }) async {
    state = state.copyWith(status: CartStatus.loading);

    final params = CreateCartUsecaseParams(bookId: bookId, quantity: quantity);

    final result = await _createCartUseCase(params);

    result.fold(
      (left) => state = state.copyWith(
        status: CartStatus.error,
        errorMessage: left.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(status: CartStatus.loaded);
        } else {
          state = state.copyWith(
            status: CartStatus.error,
            errorMessage: "Failed to Add to cart",
          );
        }
      },
    );
  }
}
