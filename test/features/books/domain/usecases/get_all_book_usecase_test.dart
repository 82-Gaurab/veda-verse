import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/usecases/get_all_book_usecase.dart';

// Mock repository
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  late GetAllBookUsecase getAllBookUsecase;
  late MockBookRepository mockBookRepository;
  late List<BookEntity> tBookList;

  setUp(() {
    mockBookRepository = MockBookRepository();
    getAllBookUsecase = GetAllBookUsecase(bookRepository: mockBookRepository);
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
        price: 500,
      ),
    ];
  });

  group('GetAllBookUsecase', () {
    test(
      'should return list of books when repository call is successful',
      () async {
        // arrange
        when(
          () => mockBookRepository.getAllBooks(),
        ).thenAnswer((_) async => Right(tBookList));

        // act
        final result = await getAllBookUsecase();

        // assert
        expect(result, Right<Failure, List<BookEntity>>(tBookList));
        verify(() => mockBookRepository.getAllBooks()).called(1);
        verifyNoMoreInteractions(mockBookRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch books');

      when(
        () => mockBookRepository.getAllBooks(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getAllBookUsecase();

      expect(result, const Left<Failure, List<BookEntity>>(tFailure));
      verify(() => mockBookRepository.getAllBooks()).called(1);
      verifyNoMoreInteractions(mockBookRepository);
    });
  });
}
