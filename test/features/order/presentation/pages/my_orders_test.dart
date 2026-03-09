import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vedaverse/features/order/presentation/pages/my_orders.dart';
import 'package:vedaverse/features/order/presentation/view_model/order_view_model.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';
import 'package:vedaverse/features/order/domain/entities/order_entity.dart';

/// Fake ViewModel
class FakeOrderViewModel extends OrderViewModel {
  OrderState _state;

  FakeOrderViewModel(this._state);

  @override
  OrderState build() {
    return _state;
  }

  @override
  Future<void> getMyOrders() async {}

  @override
  Future<void> payOrder(String orderId) async {}
}

/// Fake Order Data
List<OrderEntity> fakeOrders() {
  return [
    OrderEntity(
      id: "o1111111111111111",
      status: "pending",
      totalPrice: 2000,
      createdAt: DateTime.now(),
      books: const [
        OrderBookEntity(
          bookId: "b1",
          title: "Atomic Habits",
          price: 1000,
          quantity: 1,
        ),
        OrderBookEntity(
          bookId: "b2",
          title: "Deep Work",
          price: 500,
          quantity: 2,
        ),
      ],
    ),
  ];
}

Widget buildWidget(OrderViewModel notifier) {
  return ProviderScope(
    overrides: [orderViewModelProvider.overrideWith(() => notifier)],
    child: const MaterialApp(home: MyOrders()),
  );
}

void main() {
  group("MyOrders Screen", () {
    testWidgets("shows loading spinner when loading", (tester) async {
      final fakeVM = FakeOrderViewModel(
        const OrderState(status: OrderStatus.loading),
      );

      await tester.pumpWidget(buildWidget(fakeVM));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("shows no orders text when empty", (tester) async {
      final fakeVM = FakeOrderViewModel(
        const OrderState(status: OrderStatus.loaded, orders: []),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      expect(find.text("No Orders found"), findsOneWidget);
    });

    testWidgets("shows orders when loaded", (tester) async {
      final fakeVM = FakeOrderViewModel(
        OrderState(status: OrderStatus.loaded, orders: fakeOrders()),
      );

      await tester.pumpWidget(buildWidget(fakeVM));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Atomic Habits"), findsOneWidget);
      expect(find.text("Deep Work"), findsOneWidget);
    });

    testWidgets("back button pops screen", (tester) async {
      final fakeVM = FakeOrderViewModel(
        const OrderState(status: OrderStatus.loaded, orders: []),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [orderViewModelProvider.overrideWith(() => fakeVM)],
          child: const MaterialApp(home: MyOrders()),
        ),
      );

      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });
  });
}
