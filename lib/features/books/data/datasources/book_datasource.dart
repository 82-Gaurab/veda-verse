import 'package:vedaverse/features/books/data/models/book_api_model.dart';
import 'package:vedaverse/features/books/data/models/book_hive_model.dart';

abstract interface class IBookRemoteDatasource {
  Future<List<BookApiModel>> getAllBooks();
  Future<BookApiModel> getBookById(String bookId);
  Future<List<BookApiModel>> getBooksByGenreId(String genreId);
}

abstract interface class IBookLocalDatasource {
  Future<List<BookHiveModel>> getAllBooks();
  Future<BookHiveModel?> getBookById(String bookId);
}
