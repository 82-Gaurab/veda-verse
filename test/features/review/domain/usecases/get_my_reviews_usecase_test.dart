import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';
import 'package:vedaverse/features/review/domain/usecases/get_my_reviews_usecase.dart';

// Mock repository
class MockReviewRepository extends Mock implements IReviewRepository {}

void main() {
  late GetMyReviewUsecase getMyReviewUsecase;
  late MockReviewRepository mockReviewRepository;
  late List<ReviewEntity> tReviewList;

  setUp(() {
    mockReviewRepository = MockReviewRepository();
    getMyReviewUsecase = GetMyReviewUsecase(
      reviewRepository: mockReviewRepository,
    );

    tReviewList = [
      ReviewEntity(
        reviewId: 'review1',
        userId: 'user1',
        bookId: 'book1',
        bookTitle: 'Flutter for Beginners',
        title: 'Amazing Book',
        comment: 'Really helped me understand Flutter.',
        rating: 5.0,
        username: 'john_doe',
        profilePicture: null,
        createdAt: DateTime.parse('2026-03-05T12:00:00Z'),
      ),
      ReviewEntity(
        reviewId: 'review2',
        userId: 'user2',
        bookId: 'book2',
        bookTitle: 'Dart in Action',
        title: 'Good Read',
        comment: 'Learned a lot about Dart.',
        rating: 4.5,
        username: 'jane_doe',
        profilePicture: null,
        createdAt: DateTime.parse('2026-03-04T10:00:00Z'),
      ),
    ];
  });

  group('GetMyReviewUsecase', () {
    test(
      'should return list of ReviewEntity when repository call is successful',
      () async {
        when(
          () => mockReviewRepository.getMyReviews(),
        ).thenAnswer((_) async => Right(tReviewList));

        final result = await getMyReviewUsecase();

        expect(result, Right<Failure, List<ReviewEntity>>(tReviewList));
        verify(() => mockReviewRepository.getMyReviews()).called(1);
        verifyNoMoreInteractions(mockReviewRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch reviews');

      when(
        () => mockReviewRepository.getMyReviews(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getMyReviewUsecase();

      expect(result, const Left<Failure, List<ReviewEntity>>(tFailure));
      verify(() => mockReviewRepository.getMyReviews()).called(1);
      verifyNoMoreInteractions(mockReviewRepository);
    });
  });
}
