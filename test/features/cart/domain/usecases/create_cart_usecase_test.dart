// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/usecases/create_cart_usecase.dart';

// Mock repository
class MockCartRepository extends Mock implements ICartRepository {}

// Fake for CartEntity to allow any() in mocktail
class FakeCartEntity extends Fake implements CartEntity {}

void main() {
  late CreateCartUsecase createCartUsecase;
  late MockCartRepository mockCartRepository;
  late CreateCartUsecaseParams tParams;
  late CartEntity tCartEntity;

  setUpAll(() {
    registerFallbackValue(FakeCartEntity());
  });

  setUp(() {
    mockCartRepository = MockCartRepository();
    createCartUsecase = CreateCartUsecase(cartRepository: mockCartRepository);

    tParams = const CreateCartUsecaseParams(bookId: 'book123', quantity: 2);
    tCartEntity = const CartEntity(bookId: 'book123', quantity: 2);
  });

  group('CreateCartUsecase', () {
    test('should return true when cart creation is successful', () async {
      when(
        () => mockCartRepository.createCart(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await createCartUsecase(tParams);

      expect(result, const Right(true));
      verify(() => mockCartRepository.createCart(any())).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to create cart');
      when(
        () => mockCartRepository.createCart(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await createCartUsecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockCartRepository.createCart(any())).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });

    test('should call repository with correct CartEntity', () async {
      when(
        () => mockCartRepository.createCart(any()),
      ).thenAnswer((_) async => const Right(true));

      await createCartUsecase(tParams);

      final captured = verify(
        () => mockCartRepository.createCart(captureAny()),
      ).captured;
      final capturedEntity = captured.first as CartEntity;

      expect(capturedEntity.bookId, equals('book123'));
      expect(capturedEntity.quantity, equals(2));
    });

    test('should call repository only once', () async {
      when(
        () => mockCartRepository.createCart(any()),
      ).thenAnswer((_) async => const Right(true));

      await createCartUsecase(tParams);

      verify(() => mockCartRepository.createCart(any())).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });
  });
}
