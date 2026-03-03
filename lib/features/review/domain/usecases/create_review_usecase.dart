import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/review/data/repository/review_repository.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';

final createReviewUsecaseProvider = Provider<CreateReviewUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return CreateReviewUsecase(reviewRepository: reviewRepository);
});

class CreateReviewUsecaseParams extends Equatable {
  final String bookId;
  final String title;
  final String comment;
  final double rating;

  const CreateReviewUsecaseParams({
    required this.bookId,
    required this.title,
    required this.comment,
    required this.rating,
  });

  @override
  List<Object?> get props => [bookId, title, comment, rating];
}

class CreateReviewUsecase
    implements UseCaseWithParams<bool, CreateReviewUsecaseParams> {
  final IReviewRepository _reviewRepository;

  CreateReviewUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, bool>> call(CreateReviewUsecaseParams params) {
    final entity = ReviewEntity(
      title: params.title,
      rating: params.rating,
      comment: params.comment,
    );
    return _reviewRepository.createReview(params.bookId, entity);
  }
}
