// order_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/features/order/presentation/widgets/order_card.dart';
import 'package:esewa_flutter/esewa_flutter.dart';

class FakeEsewaPaymentResponse extends Fake implements EsewaPaymentResponse {}

void main() {
  // Helper to build the widget
  Widget buildWidget({
    String orderId = 'order123456',
    String status = 'pending',
    double totalPrice = 2500,
    DateTime? createdAt,
    List<Map<String, dynamic>> books = const [
      {"title": "Book A", "quantity": 1},
      {"title": "Book B", "quantity": 2},
    ],
    VoidCallback? onPay,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: OrderCard(
          orderId: orderId,
          status: status,
          totalPrice: totalPrice,
          createdAt: createdAt ?? DateTime(2026, 3, 5),
          books: books,
          onPay: onPay,
        ),
      ),
    );
  }

  group('OrderCard rendering', () {
    testWidgets('shows order ID', (tester) async {
      await tester.pumpWidget(buildWidget(orderId: 'order123456'));
      expect(find.text('Order #order1'), findsOneWidget);
    });

    testWidgets('shows status badge', (tester) async {
      await tester.pumpWidget(buildWidget(status: 'paid'));
      expect(find.text('PAID'), findsOneWidget);

      await tester.pumpWidget(buildWidget(status: 'pending'));
      expect(find.text('PENDING'), findsOneWidget);

      await tester.pumpWidget(buildWidget(status: 'cancelled'));
      expect(find.text('CANCELLED'), findsOneWidget);
    });

    testWidgets('shows formatted created date', (tester) async {
      final date = DateTime(2025, 6, 1);
      await tester.pumpWidget(buildWidget(createdAt: date));
      expect(find.text('Placed on 01 Jun 2025'), findsOneWidget);
    });

    testWidgets('renders all books with quantity', (tester) async {
      final books = [
        {"title": "Book A", "quantity": 1},
        {"title": "Book B", "quantity": 3},
      ];
      await tester.pumpWidget(buildWidget(books: books));

      expect(find.text('Book A'), findsOneWidget);
      expect(find.text('x1'), findsOneWidget);

      expect(find.text('Book B'), findsOneWidget);
      expect(find.text('x3'), findsOneWidget);
    });

    testWidgets('shows total price', (tester) async {
      await tester.pumpWidget(buildWidget(totalPrice: 5000));
      expect(find.text('Rs. 5000'), findsOneWidget);
    });
  });

  group('OrderCard pay button', () {
    testWidgets('shows EsewaPayButton when status is pending', (tester) async {
      await tester.pumpWidget(buildWidget(status: 'pending'));
      expect(find.byType(EsewaPayButton), findsOneWidget);
    });

    testWidgets('shows status container when status is not pending', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(status: 'paid'));
      expect(find.byType(EsewaPayButton), findsNothing);
      expect(find.text('paid'), findsOneWidget);
    });

    testWidgets('calls onPay callback on successful payment', (tester) async {
      bool paid = false;

      await tester.pumpWidget(
        buildWidget(status: 'pending', onPay: () => paid = true),
      );

      // Find the EsewaPayButton
      final button = tester.widget<EsewaPayButton>(find.byType(EsewaPayButton));

      // Call the onSuccess callback with a fake response
      button.onSuccess.call(FakeEsewaPaymentResponse());

      expect(paid, isTrue);
    });
  });
}
