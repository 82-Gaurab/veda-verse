import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/review/data/repository/review_repository.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';

final getBookReviewsUsecaseProvider = Provider<GetBookReviewsUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return GetBookReviewsUsecase(reviewRepository: reviewRepository);
});

class GetBookReviewsUsecaseParams extends Equatable {
  final String bookId;

  const GetBookReviewsUsecaseParams({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class GetBookReviewsUsecase
    implements
        UseCaseWithParams<List<ReviewEntity>, GetBookReviewsUsecaseParams> {
  final IReviewRepository _reviewRepository;

  GetBookReviewsUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(
    GetBookReviewsUsecaseParams params,
  ) {
    return _reviewRepository.getBookReviews(params.bookId);
  }
}
