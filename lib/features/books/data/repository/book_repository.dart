import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/books/data/datasources/book_datasource.dart';
import 'package:vedaverse/features/books/data/datasources/remote/book_remote_datasource.dart';
import 'package:vedaverse/features/books/data/models/book_api_model.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';

final bookRepositoryProvider = Provider<IBookRepository>((ref) {
  final bookRemoteDatasource = ref.read(bookRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BookRepository(
    bookRemoteDatasource: bookRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BookRepository implements IBookRepository {
  final IBookRemoteDatasource _bookRemoteDatasource;
  final NetworkInfo _networkInfo;

  const BookRepository({
    required IBookRemoteDatasource bookRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _bookRemoteDatasource = bookRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    if (await _networkInfo.isConnected) {
      try {
        final bookModels = await _bookRemoteDatasource.getAllBooks();
        final result = BookApiModel.toEntityList(bookModels);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet connection"));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> getBookById(String bookId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _bookRemoteDatasource.getBookById(bookId);
        final result = model.toEntity();
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooksByGenreId(
    String genreId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final bookModels = await _bookRemoteDatasource.getBooksByGenreId(
          genreId,
        );

        final result = BookApiModel.toEntityList(bookModels);

        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
