import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

enum ReviewStatus { initial, loading, loaded, error }

class ReviewState extends Equatable {
  final ReviewStatus status;

  final List<ReviewEntity> bookReviews;

  final List<ReviewEntity> myReviews;

  final String? errorMessage;

  final bool isSubmitting;

  const ReviewState({
    this.status = ReviewStatus.initial,
    this.bookReviews = const [],
    this.myReviews = const [],
    this.errorMessage,
    this.isSubmitting = false,
  });

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewEntity>? bookReviews,
    List<ReviewEntity>? myReviews,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return ReviewState(
      status: status ?? this.status,
      bookReviews: bookReviews ?? this.bookReviews,
      myReviews: myReviews ?? this.myReviews,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookReviews,
    myReviews,
    errorMessage,
    isSubmitting,
  ];
}
