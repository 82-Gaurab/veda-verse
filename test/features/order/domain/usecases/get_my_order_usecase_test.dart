import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/order/domain/entities/order_entity.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';
import 'package:vedaverse/features/order/domain/usecases/get_my_order_usecase.dart';

// Mock repository
class MockOrderRepository extends Mock implements IOrderRepository {}

void main() {
  late GetMyOrdersUsecase getMyOrdersUsecase;
  late MockOrderRepository mockOrderRepository;
  late List<OrderEntity> tOrderList;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    getMyOrdersUsecase = GetMyOrdersUsecase(repository: mockOrderRepository);

    tOrderList = [
      OrderEntity(
        id: 'order1',
        books: const [
          OrderBookEntity(
            bookId: 'book1',
            title: 'Flutter for Beginners',
            price: 25.0,
            quantity: 2,
          ),
          OrderBookEntity(
            bookId: 'book2',
            title: 'Dart in Action',
            price: 30.0,
            quantity: 1,
          ),
        ],
        totalPrice: 80.0,
        status: 'pending',
        createdAt: DateTime.parse('2026-03-05T12:00:00Z'),
      ),
      OrderEntity(
        id: 'order2',
        books: const [
          OrderBookEntity(
            bookId: 'book3',
            title: 'Advanced Flutter',
            price: 40.0,
            quantity: 1,
          ),
        ],
        totalPrice: 40.0,
        status: 'completed',
        createdAt: DateTime.parse('2026-03-04T10:00:00Z'),
      ),
    ];
  });

  group('GetMyOrdersUsecase', () {
    test(
      'should return list of OrderEntity when repository call is successful',
      () async {
        when(
          () => mockOrderRepository.getMyOrders(),
        ).thenAnswer((_) async => Right(tOrderList));

        final result = await getMyOrdersUsecase();

        expect(result, Right<Failure, List<OrderEntity>>(tOrderList));
        verify(() => mockOrderRepository.getMyOrders()).called(1);
        verifyNoMoreInteractions(mockOrderRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch orders');

      when(
        () => mockOrderRepository.getMyOrders(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getMyOrdersUsecase();

      expect(result, const Left<Failure, List<OrderEntity>>(tFailure));
      verify(() => mockOrderRepository.getMyOrders()).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });
  });
}
