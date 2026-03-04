import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

import 'package:vedaverse/features/cart/presentation/pages/cart_screen.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';
import 'package:vedaverse/features/order/presentation/view_model/order_view_model.dart';

// MOCK

class MockCartViewModel extends CartViewModel with Mock {
  @override
  CartState build() => const CartState(status: CartStatus.initial);

  @override
  Future<void> getMyCart() async {}
}

class LoadingCartViewModel extends CartViewModel with Mock {
  @override
  CartState build() => const CartState(status: CartStatus.loading);

  @override
  Future<void> getMyCart() async {}
}

class ErrorCartViewModel extends CartViewModel with Mock {
  @override
  CartState build() => const CartState(
    status: CartStatus.error,
    errorMessage: 'Failed to fetch cart data',
  );

  @override
  Future<void> getMyCart() async {}
}

class LoadedCartViewModel extends CartViewModel with Mock {
  @override
  CartState build() => CartState(
    status: CartStatus.loaded,
    entities: [
      CartEntity(
        bookId: 'b1',
        quantity: 2,
        author: "Ram",
        title: 'Atomic Habits',
        price: 1200,
      ),
    ],
  );

  @override
  Future<void> getMyCart() async {}
}

class MockOrderViewModel extends OrderViewModel with Mock {
  @override
  OrderState build() => const OrderState(status: OrderStatus.initial);

  @override
  Future<void> createOrder() async {}
}

class LoadingOrderViewModel extends OrderViewModel with Mock {
  @override
  OrderState build() => const OrderState(status: OrderStatus.loading);

  @override
  Future<void> createOrder() async {}
}

// HELPER

Widget buildWidget({
  required CartViewModel cartNotifier,
  required OrderViewModel orderNotifier,
}) {
  return ProviderScope(
    overrides: [
      cartViewModelProvider.overrideWith(() => cartNotifier),
      orderViewModelProvider.overrideWith(() => orderNotifier),
    ],
    child: const MaterialApp(home: CartScreen()),
  );
}

void main() {
  group('loading state', () {
    testWidgets('shows spinner when cart is loading', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          cartNotifier: LoadingCartViewModel(),
          orderNotifier: MockOrderViewModel(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('empty state', () {
    testWidgets('shows no item message when cart is empty', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          cartNotifier: MockCartViewModel(),
          orderNotifier: MockOrderViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('No Item in Cart'), findsOneWidget);
    });
  });

  group('loaded state', () {
    testWidgets('shows checkout button when cart has items', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          cartNotifier: LoadedCartViewModel(),
          orderNotifier: MockOrderViewModel(),
        ),
      );

      await tester.pump();

      expect(find.text('Checkout'), findsOneWidget);
    });
  });
}
