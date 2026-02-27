import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

enum ReviewStatus { initial, loading, loaded, error }

class ReviewState extends Equatable {
  final ReviewStatus status;
  final List<ReviewEntity> reviews;
  final String? errorMessage;

  const ReviewState({
    this.status = ReviewStatus.initial,
    this.reviews = const [],
    this.errorMessage,
  });

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewEntity>? reviews,
    String? errorMessage,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reviews, errorMessage];
}
