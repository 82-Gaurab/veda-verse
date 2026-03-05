import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/usecases/get_books_by_genre_id_usecase.dart';

// Mock repository
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  late GetBooksByGenreIdUsecase getBooksByGenreIdUsecase;
  late MockBookRepository mockBookRepository;
  late GetBooksByGenreIdParams tParams;
  late List<BookEntity> tBookList;

  setUp(() {
    mockBookRepository = MockBookRepository();
    getBooksByGenreIdUsecase = GetBooksByGenreIdUsecase(
      bookRepository: mockBookRepository,
    );

    tParams = const GetBooksByGenreIdParams(genreId: 'genre123');

    tBookList = [
      BookEntity(
        bookId: '1',
        title: 'Book One',
        author: 'Author One',
        description: 'Description One',
        coverImg: 'cover1.png',
        price: 200,
      ),
      BookEntity(
        bookId: '2',
        title: 'Book Two',
        author: 'Author Two',
        description: 'Description Two',
        coverImg: 'cover2.png',
        price: 200,
      ),
    ];
  });

  group('GetBooksByGenreIdUsecase', () {
    test(
      'should return list of books when repository call is successful',
      () async {
        when(
          () => mockBookRepository.getBooksByGenreId(any()),
        ).thenAnswer((_) async => Right(tBookList));

        final result = await getBooksByGenreIdUsecase(tParams);

        expect(result, Right<Failure, List<BookEntity>>(tBookList));
        verify(
          () => mockBookRepository.getBooksByGenreId('genre123'),
        ).called(1);
        verifyNoMoreInteractions(mockBookRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'No books found for this genre');

      when(
        () => mockBookRepository.getBooksByGenreId(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getBooksByGenreIdUsecase(tParams);

      expect(result, const Left<Failure, List<BookEntity>>(tFailure));
      verify(() => mockBookRepository.getBooksByGenreId('genre123')).called(1);
      verifyNoMoreInteractions(mockBookRepository);
    });

    test('should call repository with correct genreId', () async {
      when(
        () => mockBookRepository.getBooksByGenreId(any()),
      ).thenAnswer((_) async => Right(tBookList));

      await getBooksByGenreIdUsecase(tParams);

      final captured = verify(
        () => mockBookRepository.getBooksByGenreId(captureAny()),
      ).captured;
      expect(captured.first, equals('genre123'));
    });
  });
}
