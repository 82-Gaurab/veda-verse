import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/core/services/storage/token_service.dart';
import 'package:vedaverse/features/review/data/datasource/review_datasource.dart';
import 'package:vedaverse/features/review/data/model/review_api_model.dart';

final reviewRemoteDatasourceProvider = Provider<IRemoteReviewDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return ReviewRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class ReviewRemoteDatasource implements IRemoteReviewDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ReviewRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<ReviewApiModel>> getBookReviews(String bookId) async {
    final response = await _apiClient.get(ApiEndpoints.reviewsByBookId(bookId));
    final data = response.data["data"] as List;
    return data.map((json) => ReviewApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<ReviewApiModel>> getMyReviews() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.myReviews,
      option: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = response.data["data"] as List;
    return data.map((json) => ReviewApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> createReview(String bookId, ReviewApiModel review) async {
    final token = _tokenService.getToken();
    final data = review.toJson();
    final request = {...data, "bookId": bookId};
    final response = await _apiClient.post(
      ApiEndpoints.createReview,
      data: request,
      option: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data["success"];
  }
}
