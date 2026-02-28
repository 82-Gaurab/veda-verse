import 'package:vedaverse/features/books/data/models/book_api_model.dart';

abstract interface class IBookRemoteDatasource {
  Future<List<BookApiModel>> getAllBooks();
  Future<BookApiModel> getBookById(String bookId);
  Future<List<BookApiModel>> getBooksByGenreId(String genreId);
}
