import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

abstract interface class IBookRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks();
  Future<Either<Failure, BookEntity>> getBookById(String id);
  Future<Either<Failure, List<BookEntity>>> getBooksByGenreId(String genreId);
}
