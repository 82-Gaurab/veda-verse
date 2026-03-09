import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';
import 'package:vedaverse/features/order/domain/usecases/create_order_usecase.dart';

// Mock repository
class MockOrderRepository extends Mock implements IOrderRepository {}

void main() {
  late CreateOrdersUsecase createOrdersUsecase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    createOrdersUsecase = CreateOrdersUsecase(repository: mockOrderRepository);
  });

  group('CreateOrdersUsecase', () {
    test('should return true when order creation is successful', () async {
      when(
        () => mockOrderRepository.createOrder(),
      ).thenAnswer((_) async => const Right(true));

      final result = await createOrdersUsecase();

      expect(result, const Right(true));
      verify(() => mockOrderRepository.createOrder()).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to create order');

      when(
        () => mockOrderRepository.createOrder(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await createOrdersUsecase();

      expect(result, const Left(tFailure));
      verify(() => mockOrderRepository.createOrder()).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });
  });
}
