// Notifier provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/cart/domain/usecases/create_cart_usecase.dart';
import 'package:vedaverse/features/cart/domain/usecases/get_my_cart_usecase.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);

class CartViewModel extends Notifier<CartState> {
  late final CreateCartUsecase _createCartUseCase;
  late final GetMyCartUsecase _getMyCartUsecase;

  @override
  CartState build() {
    _createCartUseCase = ref.read(createCartUsecaseProvider);
    _getMyCartUsecase = ref.read(getMyCartUsecaseProvider);
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

  Future<void> getMyCart() async {
    state = state.copyWith(status: CartStatus.loading);

    final result = await _getMyCartUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
      },
      (result) {
        state = state.copyWith(status: CartStatus.loaded, entities: result);
      },
    );
  }
}
