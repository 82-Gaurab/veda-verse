import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/services/hive/hive_service.dart';
import 'package:vedaverse/features/books/data/datasources/book_datasource.dart';
import 'package:vedaverse/features/books/data/models/book_hive_model.dart';

final bookLocalDatasourceProvider = Provider<IBookLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return BookLocalDatasource(hiveService: hiveService);
});

class BookLocalDatasource implements IBookLocalDatasource {
  final HiveService _hiveService;

  BookLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<BookHiveModel>> getAllBooks() async {
    return _hiveService.getAllBooks();
  }

  @override
  Future<BookHiveModel?> getBookById(String bookId) async {
    return _hiveService.getBookById(bookId);
  }
}
