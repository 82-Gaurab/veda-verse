import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/usecases/get_my_cart_usecase.dart';

// Mock repository
class MockCartRepository extends Mock implements ICartRepository {}

void main() {
  late GetMyCartUsecase getMyCartUsecase;
  late MockCartRepository mockCartRepository;
  late List<CartEntity> tCartList;

  setUp(() {
    mockCartRepository = MockCartRepository();
    getMyCartUsecase = GetMyCartUsecase(cartRepository: mockCartRepository);

    tCartList = const [
      CartEntity(bookId: 'book1', quantity: 2),
      CartEntity(bookId: 'book2', quantity: 1),
    ];
  });

  group('GetMyCartUsecase', () {
    test(
      'should return list of CartEntity when repository call is successful',
      () async {
        when(
          () => mockCartRepository.getMyCart(),
        ).thenAnswer((_) async => Right(tCartList));

        final result = await getMyCartUsecase();

        expect(result, Right<Failure, List<CartEntity>>(tCartList));
        verify(() => mockCartRepository.getMyCart()).called(1);
        verifyNoMoreInteractions(mockCartRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch cart');

      when(
        () => mockCartRepository.getMyCart(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getMyCartUsecase();

      expect(result, const Left<Failure, List<CartEntity>>(tFailure));
      verify(() => mockCartRepository.getMyCart()).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });
  });
}
