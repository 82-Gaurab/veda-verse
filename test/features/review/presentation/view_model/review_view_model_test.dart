import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/usecases/create_review_usecase.dart';
import 'package:vedaverse/features/review/domain/usecases/get_book_reviews_usecase.dart';
import 'package:vedaverse/features/review/domain/usecases/get_my_reviews_usecase.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';

// MOCKS
class MockGetBookReviewsUsecase extends Mock implements GetBookReviewsUsecase {}

class MockCreateReviewUsecase extends Mock implements CreateReviewUsecase {}

class MockGetMyReviewUsecase extends Mock implements GetMyReviewUsecase {}

class FakeGetBookReviewsUsecaseParams extends Fake
    implements GetBookReviewsUsecaseParams {}

class FakeCreateReviewUsecaseParams extends Fake
    implements CreateReviewUsecaseParams {}

void main() {
  late MockGetBookReviewsUsecase mockGetBookReviewsUsecase;
  late MockCreateReviewUsecase mockCreateReviewUsecase;
  late MockGetMyReviewUsecase mockGetMyReviewUsecase;
  late ProviderContainer container;
  late List<ReviewEntity> tBookReviews;
  late List<ReviewEntity> tMyReviews;

  setUpAll(() {
    registerFallbackValue(FakeGetBookReviewsUsecaseParams());
    registerFallbackValue(FakeCreateReviewUsecaseParams());
  });

  setUp(() {
    mockGetBookReviewsUsecase = MockGetBookReviewsUsecase();
    mockCreateReviewUsecase = MockCreateReviewUsecase();
    mockGetMyReviewUsecase = MockGetMyReviewUsecase();

    tBookReviews = [
      const ReviewEntity(
        reviewId: 'review-001',
        bookId: 'book-001',
        bookTitle: 'Flutter Guide',
        title: 'Awesome Book',
        comment: 'Very informative',
        rating: 4.5,
        username: 'John Doe',
        createdAt: null,
      ),
    ];

    tMyReviews = [
      const ReviewEntity(
        reviewId: 'review-002',
        bookId: 'book-002',
        bookTitle: 'Dart in Action',
        title: 'Good Read',
        comment: 'Learned a lot',
        rating: 5.0,
        username: 'John Doe',
        createdAt: null,
      ),
    ];

    container = ProviderContainer(
      overrides: [
        getBookReviewsUsecaseProvider.overrideWithValue(
          mockGetBookReviewsUsecase,
        ),
        createReviewUsecaseProvider.overrideWithValue(mockCreateReviewUsecase),
        getMyReviewUsecaseProvider.overrideWithValue(mockGetMyReviewUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  ReviewViewModel readViewModel() =>
      container.read(reviewViewModelProvider.notifier);
  ReviewState readState() => container.read(reviewViewModelProvider);

  group('ReviewViewModel', () {
    test('initial state should be correct', () {
      expect(readState().status, equals(ReviewStatus.initial));
      expect(readState().bookReviews, isEmpty);
      expect(readState().myReviews, isEmpty);
      expect(readState().errorMessage, isNull);
    });

    // GET BOOK REVIEWS
    group('getBookReview', () {
      const bookId = 'book-001';

      test(
        'should emit loading then loaded with book reviews on success',
        () async {
          when(
            () => mockGetBookReviewsUsecase(any()),
          ).thenAnswer((_) async => Right(tBookReviews));

          await readViewModel().getBookReview(bookId: bookId);

          expect(readState().status, equals(ReviewStatus.loaded));
          expect(readState().bookReviews, equals(tBookReviews));
          expect(readState().errorMessage, isNull);
        },
      );

      test('should emit error when getBookReview fails', () async {
        const tFailure = ApiFailure(message: 'Failed to fetch book reviews');
        when(
          () => mockGetBookReviewsUsecase(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().getBookReview(bookId: bookId);

        expect(readState().status, equals(ReviewStatus.error));
        expect(
          readState().errorMessage,
          equals('Failed to fetch book reviews'),
        );
        expect(readState().bookReviews, isEmpty);
      });
    });

    // GET MY REVIEWS
    group('getMyReviews', () {
      test(
        'should emit loading then loaded with my reviews on success',
        () async {
          when(
            () => mockGetMyReviewUsecase(),
          ).thenAnswer((_) async => Right(tMyReviews));

          await readViewModel().getMyReviews();

          expect(readState().status, equals(ReviewStatus.loaded));
          expect(readState().myReviews, equals(tMyReviews));
          expect(readState().errorMessage, isNull);
        },
      );

      test('should emit error when getMyReviews fails', () async {
        const tFailure = ApiFailure(message: 'Failed to fetch my reviews');
        when(
          () => mockGetMyReviewUsecase(),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().getMyReviews();

        expect(readState().status, equals(ReviewStatus.error));
        expect(readState().errorMessage, equals('Failed to fetch my reviews'));
        expect(readState().myReviews, isEmpty);
      });
    });

    // CREATE REVIEW
    group('createReview', () {
      const bookId = 'book-001';
      const title = 'Great Book';
      const comment = 'Loved it';
      const rating = 4.5;

      test(
        'should emit loading then loaded on successful review creation',
        () async {
          when(
            () => mockCreateReviewUsecase(any()),
          ).thenAnswer((_) async => const Right(true));

          await readViewModel().createReview(
            bookId: bookId,
            title: title,
            comment: comment,
            rating: rating,
          );

          expect(readState().status, equals(ReviewStatus.loaded));
          expect(readState().errorMessage, isNull);
        },
      );

      test('should emit error when createReview fails', () async {
        const tFailure = ApiFailure(message: 'Failed to create review');
        when(
          () => mockCreateReviewUsecase(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        await readViewModel().createReview(
          bookId: bookId,
          title: title,
          comment: comment,
          rating: rating,
        );

        expect(readState().status, equals(ReviewStatus.error));
        expect(readState().errorMessage, equals('Failed to create review'));
      });

      test('should emit error when createReview returns false', () async {
        when(
          () => mockCreateReviewUsecase(any()),
        ).thenAnswer((_) async => const Right(false));

        await readViewModel().createReview(
          bookId: bookId,
          title: title,
          comment: comment,
          rating: rating,
        );

        expect(readState().status, equals(ReviewStatus.error));
        expect(readState().errorMessage, equals('Failed To Create Review'));
      });
    });
  });
}
