import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/order/domain/entities/order_entity.dart';
import 'package:vedaverse/features/order/domain/usecases/create_order_usecase.dart';
import 'package:vedaverse/features/order/domain/usecases/get_my_order_usecase.dart';
import 'package:vedaverse/features/order/domain/usecases/pay_order_usecase.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';
import 'package:vedaverse/features/order/presentation/view_model/order_view_model.dart';

// MOCKS
class MockCreateOrdersUsecase extends Mock implements CreateOrdersUsecase {}

class MockGetMyOrdersUsecase extends Mock implements GetMyOrdersUsecase {}

class MockPayOrderUsecase extends Mock implements PayOrderUsecase {}

class FakePayOrderUsecaseParams extends Fake implements PayOrderUsecaseParams {}

void main() {
  late MockCreateOrdersUsecase mockCreateOrdersUsecase;
  late MockGetMyOrdersUsecase mockGetMyOrdersUsecase;
  late MockPayOrderUsecase mockPayOrderUsecase;
  late ProviderContainer container;
  late List<OrderEntity> tOrders;

  setUpAll(() {
    registerFallbackValue(FakePayOrderUsecaseParams());
  });

  setUp(() {
    mockCreateOrdersUsecase = MockCreateOrdersUsecase();
    mockGetMyOrdersUsecase = MockGetMyOrdersUsecase();
    mockPayOrderUsecase = MockPayOrderUsecase();

    final orderBook = const OrderBookEntity(
      bookId: 'book-001',
      title: 'Flutter Guide',
      price: 29.99,
      quantity: 1,
    );

    tOrders = [
      OrderEntity(
        id: 'order-001',
        books: [orderBook],
        totalPrice: 29.99,
        status: 'pending',
        createdAt: DateTime.parse('2026-03-05T12:00:00'),
      ),
      OrderEntity(
        id: 'order-002',
        books: [orderBook],
        totalPrice: 59.98,
        status: 'paid',
        createdAt: DateTime.parse('2026-03-04T15:00:00'),
      ),
    ];

    container = ProviderContainer(
      overrides: [
        createOrderUsecaseProvider.overrideWithValue(mockCreateOrdersUsecase),
        getMyOrdersUsecaseProvider.overrideWithValue(mockGetMyOrdersUsecase),
        payOrderUsecaseProvider.overrideWithValue(mockPayOrderUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  OrderViewModel readViewModel() =>
      container.read(orderViewModelProvider.notifier);
  OrderState readState() => container.read(orderViewModelProvider);

  group('OrderViewModel', () {
    test('initial state should be correct', () {
      expect(readState().status, equals(OrderStatus.initial));
      expect(readState().orders, isEmpty);
      expect(readState().errorMessage, isNull);
    });

    // CREATE ORDER
    group('createOrder', () {
      test(
        'should emit loading then loaded when createOrder succeeds',
        () async {
          when(
            () => mockCreateOrdersUsecase(),
          ).thenAnswer((_) async => const Right(true));

          await readViewModel().createOrder();

          expect(readState().status, equals(OrderStatus.loaded));
          expect(readState().errorMessage, isNull);
        },
      );

      test('should emit error when createOrder fails', () async {
        const tFailure = ApiFailure(message: 'Failed to create order');
        when(
          () => mockCreateOrdersUsecase(),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().createOrder();

        expect(readState().status, equals(OrderStatus.error));
        expect(readState().errorMessage, equals('Failed to create order'));
      });

      test('should emit error when createOrder returns false', () async {
        when(
          () => mockCreateOrdersUsecase(),
        ).thenAnswer((_) async => const Right(false));

        await readViewModel().createOrder();

        expect(readState().status, equals(OrderStatus.error));
      });
    });

    // GET MY ORDERS
    group('getMyOrders', () {
      test('should emit loading then loaded with orders on success', () async {
        when(
          () => mockGetMyOrdersUsecase(),
        ).thenAnswer((_) async => Right(tOrders));

        await readViewModel().getMyOrders();

        expect(readState().status, equals(OrderStatus.loaded));
        expect(readState().orders, equals(tOrders));
        expect(readState().errorMessage, isNull);
      });

      test('should emit error when getMyOrders fails', () async {
        const tFailure = ApiFailure(message: 'Failed to fetch orders');
        when(
          () => mockGetMyOrdersUsecase(),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().getMyOrders();

        expect(readState().status, equals(OrderStatus.error));
        expect(readState().errorMessage, equals('Failed to fetch orders'));
        expect(readState().orders, isEmpty);
      });
    });

    // PAY ORDER
    group('payOrder', () {
      const orderId = 'order-001';

      test('should emit loading then loaded when payOrder succeeds', () async {
        when(
          () => mockPayOrderUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        await readViewModel().payOrder(orderId);

        expect(readState().status, equals(OrderStatus.paid));
        expect(readState().errorMessage, isNull);
      });

      test('should emit error when payOrder fails', () async {
        const tFailure = ApiFailure(message: 'Failed to pay order');
        when(
          () => mockPayOrderUsecase(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().payOrder(orderId);

        expect(readState().status, equals(OrderStatus.error));
        expect(readState().errorMessage, equals('Failed to pay order'));
      });

      test('should emit error when payOrder returns false', () async {
        when(
          () => mockPayOrderUsecase(any()),
        ).thenAnswer((_) async => const Right(false));

        await readViewModel().payOrder(orderId);

        expect(readState().status, equals(OrderStatus.error));
      });
    });
  });
}
