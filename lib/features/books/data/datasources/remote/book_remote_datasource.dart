import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/books/data/datasources/book_datasource.dart';
import 'package:vedaverse/features/books/data/models/book_api_model.dart';

final bookRemoteDatasourceProvider = Provider<IBookRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookRemoteDatasource(apiClient: apiClient);
});

class BookRemoteDatasource implements IBookRemoteDatasource {
  final ApiClient _apiClient;

  const BookRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<List<BookApiModel>> getAllBooks() async {
    final response = await _apiClient.get(ApiEndpoints.books);
    final data = response.data["data"] as List;

    return data.map((json) => BookApiModel.fromJson(json)).toList();
  }

  @override
  Future<BookApiModel> getBookById(String bookId) async {
    final response = await _apiClient.get(ApiEndpoints.bookById(bookId));
    final data = response.data["data"];

    return BookApiModel.fromJson(data);
  }
}
