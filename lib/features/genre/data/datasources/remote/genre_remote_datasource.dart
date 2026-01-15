import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/genre/data/datasources/genre_datasource.dart';
import 'package:vedaverse/features/genre/data/model/genre_api_model.dart';

final genreRemoteDatasourceProvider = Provider<IGenreRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GenreRemoteDatasource(apiClient: apiClient);
});

class GenreRemoteDatasource implements IGenreRemoteDatasource {
  final ApiClient _apiClient;

  GenreRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createGenre(GenreApiModel genre) async {
    final response = await _apiClient.post(ApiEndpoints.genre);
    return response.data["success"] == true;
  }

  @override
  Future<List<GenreApiModel>> getAllGenre() async {
    final response = await _apiClient.get(ApiEndpoints.genre);
    final data = response.data["data"] as List;

    // Note: json -> api model -> entity : from json
    return data.map((json) => GenreApiModel.fromJson(json)).toList();
  }

  @override
  Future<GenreApiModel?> getGenreById(String genreId) async {
    // TODO: implement updateGenre
    throw UnimplementedError();
  }

  @override
  Future<bool> updateGenre(GenreApiModel genre) {
    // TODO: implement updateGenre
    throw UnimplementedError();
  }
}
