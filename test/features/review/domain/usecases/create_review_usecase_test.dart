import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';
import 'package:vedaverse/features/review/domain/usecases/create_review_usecase.dart';

// Mock repository
class MockReviewRepository extends Mock implements IReviewRepository {}

// Fake ReviewEntity
class FakeReviewEntity extends Fake implements ReviewEntity {}

void main() {
  late CreateReviewUsecase createReviewUsecase;
  late MockReviewRepository mockReviewRepository;

  setUpAll(() {
    registerFallbackValue(FakeReviewEntity());
  });

  setUp(() {
    mockReviewRepository = MockReviewRepository();
    createReviewUsecase = CreateReviewUsecase(
      reviewRepository: mockReviewRepository,
    );
  });

  const tParams = CreateReviewUsecaseParams(
    bookId: 'book1',
    title: 'Great Book',
    comment: 'Really insightful and well-written.',
    rating: 5.0,
  );

  group('CreateReviewUsecase', () {
    test('should return true when review creation is successful', () async {
      when(
        () => mockReviewRepository.createReview(any(), any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await createReviewUsecase(tParams);

      expect(result, const Right(true));

      final captured = verify(
        () => mockReviewRepository.createReview(captureAny(), captureAny()),
      ).captured;

      expect(captured[0], tParams.bookId);
      expect((captured[1] as ReviewEntity).title, tParams.title);
      expect((captured[1] as ReviewEntity).comment, tParams.comment);
      expect((captured[1] as ReviewEntity).rating, tParams.rating);

      verifyNoMoreInteractions(mockReviewRepository);
    });

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to create review');

      when(
        () => mockReviewRepository.createReview(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await createReviewUsecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockReviewRepository.createReview(any(), any())).called(1);
      verifyNoMoreInteractions(mockReviewRepository);
    });
  });
}
