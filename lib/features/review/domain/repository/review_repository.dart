import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getBookReviews(String bookId);
  Future<Either<Failure, List<ReviewEntity>>> getMyReviews();
  Future<Either<Failure, bool>> createReview(
    String bookId,
    ReviewEntity review,
  );
}
