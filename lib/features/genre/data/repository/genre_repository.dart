import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/genre/data/datasources/genre_datasource.dart';
import 'package:vedaverse/features/genre/data/datasources/local/genre_local_datasource.dart';
import 'package:vedaverse/features/genre/data/datasources/remote/genre_remote_datasource.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/domain/repository/genre_repository.dart';

final genreRepositoryProvider = Provider<IGenreRepository>((ref) {
  final genreLocalDatasource = ref.read(genreLocalDatasourceProvider);
  final genreRemoteDatasource = ref.read(genreRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return GenreRepository(
    genreLocalDatasource: genreLocalDatasource,
    genreRemoteDatasource: genreRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class GenreRepository implements IGenreRepository {
  final IGenreLocalDatasource _genreLocalDatasource;
  final IGenreRemoteDatasource _genreRemoteDatasource;
  final NetworkInfo _networkInfo;

  GenreRepository({
    required IGenreLocalDatasource genreLocalDatasource,
    required IGenreRemoteDatasource genreRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _genreLocalDatasource = genreLocalDatasource,
       _genreRemoteDatasource = genreRemoteDatasource,
       _networkInfo = networkInfo;

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
