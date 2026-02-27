import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/review/data/repository/review_repository.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';

final getMyReviewUsecaseProvider = Provider<GetMyReviewUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return GetMyReviewUsecase(reviewRepository: reviewRepository);
});

class GetMyReviewUsecase implements UseCaseWithoutParams {
  final IReviewRepository _reviewRepository;

  GetMyReviewUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call() {
    return _reviewRepository.getMyReviews();
  }
}
