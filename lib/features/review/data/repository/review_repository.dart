import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/review/data/datasource/remote/review_remote_datasource.dart';
import 'package:vedaverse/features/review/data/datasource/review_datasource.dart';
import 'package:vedaverse/features/review/data/model/review_api_model.dart';
import 'package:vedaverse/features/review/domain/entities/review_entity.dart';
import 'package:vedaverse/features/review/domain/repository/review_repository.dart';

final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  final remoteReviewDatasource = ref.read(reviewRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ReviewRepository(
    remoteReviewDatasource: remoteReviewDatasource,
    networkInfo: networkInfo,
  );
});

class ReviewRepository implements IReviewRepository {
  final IRemoteReviewDatasource _remoteReviewDatasource;
  final NetworkInfo _networkInfo;

  ReviewRepository({
    required IRemoteReviewDatasource remoteReviewDatasource,
    required NetworkInfo networkInfo,
  }) : _networkInfo = networkInfo,
       _remoteReviewDatasource = remoteReviewDatasource;
  @override
  Future<Either<Failure, bool>> createReview(
    String bookId,
    ReviewEntity review,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = ReviewApiModel.fromEntity(review);

        final response = await _remoteReviewDatasource.createReview(
          bookId,
          model,
        );

        return Right(response);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to post review",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "NO internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getBookReviews(
    String bookId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteReviewDatasource.getBookReviews(bookId);
        final entities = ReviewApiModel.toEntityList(models);

        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data["message"] ??
                "Failed to fetch review for the book",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getMyReviews() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteReviewDatasource.getMyReviews();
        final entities = ReviewApiModel.toEntityList(models);

        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data["message"] ??
                "Failed to fetch review for the user",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet"));
    }
  }
}
