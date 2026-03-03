import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/genre/data/datasources/genre_datasource.dart';
import 'package:vedaverse/features/genre/data/datasources/local/genre_local_datasource.dart';
import 'package:vedaverse/features/genre/data/datasources/remote/genre_remote_datasource.dart';
import 'package:vedaverse/features/genre/data/model/genre_api_model.dart';
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
  Future<Either<Failure, List<GenreEntity>>> getAllGenre() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _genreRemoteDatasource.getAllGenre();
        final entities = GenreApiModel.toEntityList(response);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Get All Genre Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveGenres = await _genreLocalDatasource.getAllGenre();
        return Right(hiveGenres.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(LocalDataBaseFailure(message: "Failed to get book by id"));
      }
    }
  }
}
