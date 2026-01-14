import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/genre/data/repository/genre_repository.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/domain/repository/genre_repository.dart';

// NOTE: Dependency Injection using Provider
final getAllGenreUsecaseProvider = Provider<GetAllGenreUsecase>((ref) {
  return GetAllGenreUsecase(genreRepository: ref.read(genreRepositoryProvider));
});

class GetAllGenreUsecase implements UseCaseWithoutParams<List<GenreEntity>> {
  final IGenreRepository _genreRepository;

  GetAllGenreUsecase({required IGenreRepository genreRepository})
    : _genreRepository = genreRepository;

  @override
  Future<Either<Failure, List<GenreEntity>>> call() {
    return _genreRepository.getAllGenre();
  }
}
