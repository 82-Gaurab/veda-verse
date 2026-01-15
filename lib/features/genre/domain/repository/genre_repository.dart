import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';

abstract interface class IGenreRepository {
  Future<Either<Failure, List<GenreEntity>>> getAllGenre();
  Future<Either<Failure, GenreEntity>> getGenreById(String genreId);
  Future<Either<Failure, bool>> createBatch(GenreEntity genre);
  Future<Either<Failure, bool>> updateBatch(GenreEntity genre);
  Future<Either<Failure, bool>> deleteBatch(String genreId);
}
