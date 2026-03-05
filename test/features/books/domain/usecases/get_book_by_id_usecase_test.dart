import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/usecases/get_book_by_id_usecase.dart';

// Mock repository
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  late GetBookByIdUsecase getBookByIdUsecase;
  late MockBookRepository mockBookRepository;
  late GetBookByIdUsecaseParams tParams;
  late BookEntity tBook;

  setUp(() {
    mockBookRepository = MockBookRepository();
    getBookByIdUsecase = GetBookByIdUsecase(bookRepository: mockBookRepository);
    tParams = const GetBookByIdUsecaseParams(bookId: 'book123');
    tBook = BookEntity(
      bookId: 'book123',
      title: 'Flutter for Beginners',
      author: 'John Doe',
      description: 'A beginner-friendly guide to Flutter',
      coverImg: 'cover.png',
      price: 200,
    );
  });

  group('GetBookByIdUsecase', () {
    test(
      'should return BookEntity when repository call is successful',
      () async {
        when(
          () => mockBookRepository.getBookById(any()),
        ).thenAnswer((_) async => Right(tBook));

        final result = await getBookByIdUsecase(tParams);

        expect(result, Right<Failure, BookEntity>(tBook));
        verify(() => mockBookRepository.getBookById('book123')).called(1);
        verifyNoMoreInteractions(mockBookRepository);
      },
    );

    test('should return failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Book not found');

      when(
        () => mockBookRepository.getBookById(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await getBookByIdUsecase(tParams);

      expect(result, const Left<Failure, BookEntity>(tFailure));
      verify(() => mockBookRepository.getBookById('book123')).called(1);
      verifyNoMoreInteractions(mockBookRepository);
    });

    test('should call repository with correct bookId', () async {
      when(
        () => mockBookRepository.getBookById(any()),
      ).thenAnswer((_) async => Right(tBook));

      await getBookByIdUsecase(tParams);

      final captured = verify(
        () => mockBookRepository.getBookById(captureAny()),
      ).captured;
      expect(captured.first, equals('book123'));
    });
  });
}
