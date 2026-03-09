import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';
import 'package:vedaverse/features/genre/domain/repository/genre_repository.dart';
import 'package:vedaverse/features/genre/domain/usecases/get_all_genre_usecase.dart';

// Mock repository
class MockGenreRepository extends Mock implements IGenreRepository {}

void main() {
  late GetAllGenreUsecase getAllGenreUsecase;
  late MockGenreRepository mockGenreRepository;
  late List<GenreEntity> tGenreList;

  setUp(() {
    mockGenreRepository = MockGenreRepository();
    getAllGenreUsecase = GetAllGenreUsecase(
      genreRepository: mockGenreRepository,
    );

    tGenreList = const [
      GenreEntity(genreId: '1', genreTitle: 'Fiction'),
      GenreEntity(genreId: '2', genreTitle: 'Science'),
    ];
  });

  group('GetAllGenreUsecase', () {
    test(
      'should return list of GenreEntity when repository call is successful',
      () async {
        when(
          () => mockGenreRepository.getAllGenre(),
        ).thenAnswer((_) async => Right(tGenreList));

        final result = await getAllGenreUsecase();

        expect(result, Right<Failure, List<GenreEntity>>(tGenreList));
        verify(() => mockGenreRepository.getAllGenre()).called(1);
        verifyNoMoreInteractions(mockGenreRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch genres');

      when(
        () => mockGenreRepository.getAllGenre(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getAllGenreUsecase();

      expect(result, const Left<Failure, List<GenreEntity>>(tFailure));
      verify(() => mockGenreRepository.getAllGenre()).called(1);
      verifyNoMoreInteractions(mockGenreRepository);
    });
  });
}
