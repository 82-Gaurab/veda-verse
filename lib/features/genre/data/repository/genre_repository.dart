import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/domain/repository/genre_repository.dart';

class GenreRepository implements IGenreRepository {
  @override
  Future<Either<Failure, bool>> createBatch(GenreEntity genre) {
    // TODO: implement createBatch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String genreId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GenreEntity>>> getAllGenre() {
    // TODO: implement getAllGenre
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GenreEntity>> getGenreById(String genreId) {
    // TODO: implement getGenreById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateBatch(GenreEntity genre) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
