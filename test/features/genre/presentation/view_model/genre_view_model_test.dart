import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/domain/usecases/get_all_genre_usecase.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';
import 'package:vedaverse/features/genre/presentation/view_model/genre_view_model.dart';
import 'package:vedaverse/core/error/failures.dart';

// Mock
class MockGetAllGenreUsecase extends Mock implements GetAllGenreUsecase {}

void main() {
  late MockGetAllGenreUsecase mockGetAllGenreUsecase;
  late ProviderContainer container;
  late List<GenreEntity> tGenres;

  setUp(() {
    mockGetAllGenreUsecase = MockGetAllGenreUsecase();

    // Sample GenreEntity list
    tGenres = [
      const GenreEntity(genreId: '1', genreTitle: 'Action'),
      const GenreEntity(genreId: '2', genreTitle: 'Comedy'),
      const GenreEntity(genreId: '3', genreTitle: 'Drama'),
    ];

    container = ProviderContainer(
      overrides: [
        getAllGenreUsecaseProvider.overrideWithValue(mockGetAllGenreUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  GenreViewModel readViewModel() =>
      container.read(genreViewModelProvider.notifier);
  GenreState readState() => container.read(genreViewModelProvider);

  group('GenreViewModel', () {
    test('initial state should be correct', () {
      expect(readState().status, equals(GenreStatus.initial));
      expect(readState().genres, isEmpty);
      expect(readState().errorMessage, isNull);
    });

    test('getAllGenres success should emit loading then loaded', () async {
      when(
        () => mockGetAllGenreUsecase(),
      ).thenAnswer((_) async => Right(tGenres));

      await readViewModel().getAllGenres();

      expect(readState().status, equals(GenreStatus.loaded));
      expect(readState().genres, equals(tGenres));
      expect(readState().errorMessage, isNull);
    });

    test('getAllGenres failure should emit loading then error', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch genres');
      when(
        () => mockGetAllGenreUsecase(),
      ).thenAnswer((_) async => const Left(tFailure));

      await readViewModel().getAllGenres();

      expect(readState().status, equals(GenreStatus.error));
      expect(readState().errorMessage, equals('Failed to fetch genres'));
      expect(readState().genres, isEmpty);
    });
  });
}
