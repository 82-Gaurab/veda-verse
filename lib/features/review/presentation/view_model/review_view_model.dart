import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/review/domain/usecases/create_review_usecase.dart';
import 'package:vedaverse/features/review/domain/usecases/get_book_reviews_usecase.dart';
import 'package:vedaverse/features/review/domain/usecases/get_my_reviews_usecase.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';

// NOTE: Dependency Injection using Provider
// NOTE: Here the class extends a Notifier so we use notifier provider
final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(
  () {
    return ReviewViewModel();
  },
);

class ReviewViewModel extends Notifier<ReviewState> {
  late final GetBookReviewsUsecase _getBookReviewsUsecase;
  late final CreateReviewUsecase _createReviewUsecase;
  late final GetMyReviewUsecase _getMyReviewUsecase;

  @override
  ReviewState build() {
    _getBookReviewsUsecase = ref.read(getBookReviewsUsecaseProvider);
    _createReviewUsecase = ref.read(createReviewUsecaseProvider);
    _getMyReviewUsecase = ref.read(getMyReviewUsecaseProvider);

    return const ReviewState();
  }

  Future<void> getBookReview({required String bookId}) async {
    state = state.copyWith(status: ReviewStatus.loading);

    final result = await _getBookReviewsUsecase(
      GetBookReviewsUsecaseParams(bookId: bookId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewStatus.error,
        errorMessage: failure.message,
      ),
      (reviews) => state = state = state.copyWith(
        status: ReviewStatus.loaded,
        bookReviews: reviews,
      ),
    );
  }

  Future<void> getMyReviews() async {
    state = state.copyWith(status: ReviewStatus.loading);

    final result = await _getMyReviewUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewStatus.error,
        errorMessage: failure.message,
      ),
      (reviews) => state = state = state.copyWith(
        status: ReviewStatus.loaded,
        myReviews: reviews,
      ),
    );
  }

  Future<void> createReview({
    required String bookId,
    required String title,
    required String comment,
    required double rating,
  }) async {
    state = state.copyWith(status: ReviewStatus.loading);

    final params = CreateReviewUsecaseParams(
      bookId: bookId,
      title: title,
      comment: comment,
      rating: rating,
    );

    final result = await _createReviewUsecase(params);

    result.fold(
      (left) => state = state.copyWith(
        status: ReviewStatus.error,
        errorMessage: left.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(status: ReviewStatus.loaded);
        } else {
          state = state.copyWith(
            status: ReviewStatus.error,
            errorMessage: "Failed To Create Review",
          );
        }
      },
    );
  }
}
