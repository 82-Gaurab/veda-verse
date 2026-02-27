import 'package:vedaverse/features/review/data/model/review_api_model.dart';

abstract interface class IRemoteReviewDatasource {
  Future<List<ReviewApiModel>> getBookReviews(String bookId);
  Future<List<ReviewApiModel>> getMyReviews();
  Future<bool> createReview(String bookId, ReviewApiModel review);
}
