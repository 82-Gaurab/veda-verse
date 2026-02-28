import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/order/domain/usecases/create_order_usecase.dart';
import 'package:vedaverse/features/order/domain/usecases/get_my_order_usecase.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';

final orderViewModelProvider = NotifierProvider<OrderViewModel, OrderState>(() {
  return OrderViewModel();
});

class OrderViewModel extends Notifier<OrderState> {
  // late final CreateOrderUsecase _createOrderUsecase;
  late final GetMyOrdersUsecase _getMyOrdersUsecase;
  late final CreateOrdersUsecase _createOrdersUsecase;

  @override
  OrderState build() {
    // _createOrderUsecase = ref.read(createOrderUsecaseProvider);
    _getMyOrdersUsecase = ref.read(getMyOrdersUsecaseProvider);
    _createOrdersUsecase = ref.read(createOrderUsecaseProvider);

    return const OrderState();
  }

  Future<void> createOrder() async {
    state = state.copyWith(status: OrderStatus.loading);

    final result = await _createOrdersUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: OrderStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: success ? OrderStatus.loaded : OrderStatus.error,
      ),
    );
  }

  Future<void> getMyOrders() async {
    state = state.copyWith(status: OrderStatus.loading);

    final result = await _getMyOrdersUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: OrderStatus.error,
        errorMessage: failure.message,
      ),
      (orders) =>
          state = state.copyWith(status: OrderStatus.loaded, orders: orders),
    );
  }
}
