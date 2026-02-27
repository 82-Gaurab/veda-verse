import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/genre/data/repository/genre_repository.dart';
import 'package:vedaverse/features/genre/domain/repository/genre_repository.dart';

class GetGenreByIdUsecaseParams extends Equatable {
  final String genreId;

  const GetGenreByIdUsecaseParams({required this.genreId});

  @override
  List<Object?> get props => [genreId];
}

// NOTE: Dependency Injection using Provider
final getGenreByIdUsecaseProvider = Provider<GetGenreByIdUsecase>((ref) {
  return GetGenreByIdUsecase(
    batchRepository: ref.read(genreRepositoryProvider),
  );
});

class GetGenreByIdUsecase
    implements UseCaseWithParams<void, GetGenreByIdUsecaseParams> {
  final IGenreRepository _genreRepository;

  GetGenreByIdUsecase({required IGenreRepository batchRepository})
    : _genreRepository = batchRepository;

  @override
  Future<Either<Failure, void>> call(GetGenreByIdUsecaseParams params) {
    return _genreRepository.getGenreById(params.genreId);
  }
}
