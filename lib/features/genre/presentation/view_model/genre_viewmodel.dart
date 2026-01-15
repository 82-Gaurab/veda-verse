import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/genre/domain/usecases/get_all_genre_usecase.dart';
import 'package:vedaverse/features/genre/domain/usecases/get_genre_by_id_usecase.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';

// NOTE: Dependency Injection using Provider
// NOTE: Here the class extends a Notifier so we use notifier provider
final genreViewModelProvider = NotifierProvider<GenreViewModel, GenreState>(() {
  return GenreViewModel();
});

class GenreViewModel extends Notifier<GenreState> {
  late final GetAllGenreUsecase _getAllGenreUsecase;
  late final GetGenreByIdUsecase _getGenreByIdUsecase;

  @override
  GenreState build() {
    // Initialize the usecases here using ref, which we will do later
    _getAllGenreUsecase = ref.read(getAllGenreUsecaseProvider);
    _getGenreByIdUsecase = ref.read(getGenreByIdUsecaseProvider);
    return const GenreState();
  }

  Future<void> getAllGenres() async {
    state = state.copyWith(status: GenreStatus.loading);

    final result = await _getAllGenreUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: GenreStatus.error,
        errorMessage: failure.message,
      ),
      (genres) =>
          state = state.copyWith(status: GenreStatus.loaded, genres: genres),
    );
  }

  Future<void> getGenreById(String genreId) async {
    state = state.copyWith(status: GenreStatus.loading);

    final result = await _getGenreByIdUsecase(
      GetGenreByIdUsecaseParams(genreId: genreId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: GenreStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(status: GenreStatus.loaded),
    );
  }
}
