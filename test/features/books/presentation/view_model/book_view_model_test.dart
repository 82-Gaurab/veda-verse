import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/usecases/get_all_book_usecase.dart';
import 'package:vedaverse/features/books/domain/usecases/get_book_by_id_usecase.dart';
import 'package:vedaverse/features/books/domain/usecases/get_books_by_genre_id_usecase.dart';

import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';

/// Mocks

class MockGetAllBookUsecase extends Mock implements GetAllBookUsecase {}

class MockGetBookByIdUsecase extends Mock implements GetBookByIdUsecase {}

class MockGetBooksByGenreIdUsecase extends Mock
    implements GetBooksByGenreIdUsecase {}

/// Fakes

class FakeGetBookByIdParams extends Fake implements GetBookByIdUsecaseParams {}

class FakeGetBooksByGenreIdParams extends Fake
    implements GetBooksByGenreIdParams {}

void main() {
  late MockGetAllBookUsecase mockGetAllBookUsecase;
  late MockGetBookByIdUsecase mockGetBookByIdUsecase;
  late MockGetBooksByGenreIdUsecase mockGetBooksByGenreIdUsecase;

  late ProviderContainer container;

  late BookEntity tBook;
  late List<BookEntity> tBooks;

  setUpAll(() {
    registerFallbackValue(FakeGetBookByIdParams());
    registerFallbackValue(FakeGetBooksByGenreIdParams());
  });

  setUp(() {
    mockGetAllBookUsecase = MockGetAllBookUsecase();
    mockGetBookByIdUsecase = MockGetBookByIdUsecase();
    mockGetBooksByGenreIdUsecase = MockGetBooksByGenreIdUsecase();

    tBook = BookEntity(
      bookId: "1",
      title: "Clean Architecture",
      author: "Robert C. Martin",
      price: 20,
    );

    tBooks = [
      tBook,
      BookEntity(
        bookId: "2",
        title: "Flutter in Action",
        author: "Eric Windmill",
        price: 25,
      ),
    ];

    container = ProviderContainer(
      overrides: [
        getAllBookUsecaseProvider.overrideWithValue(mockGetAllBookUsecase),
        getBookByIdUsecaseProvider.overrideWithValue(mockGetBookByIdUsecase),
        getBooksByGenreIdUsecaseProvider.overrideWithValue(
          mockGetBooksByGenreIdUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  BookViewModel readViewModel() =>
      container.read(bookViewModelProvider.notifier);

  BookState readState() => container.read(bookViewModelProvider);

  group("BookViewModel", () {
    /// INITIAL STATE
    group("initial state", () {
      test("should have correct initial state", () {
        expect(readState().status, BookStatus.initial);
        expect(readState().books, isEmpty);
        expect(readState().book, isNull);
        expect(readState().errorMessage, isNull);
      });
    });

    /// GET ALL BOOKS
    group("getAllBooks", () {
      test("should emit loaded with books on success", () async {
        when(
          () => mockGetAllBookUsecase(),
        ).thenAnswer((_) async => Right(tBooks));

        await readViewModel().getAllBooks();

        expect(readState().status, BookStatus.loaded);
        expect(readState().books, tBooks);
      });

      test("should emit placeholder book when list is empty", () async {
        when(
          () => mockGetAllBookUsecase(),
        ).thenAnswer((_) async => const Right([]));

        await readViewModel().getAllBooks();

        expect(readState().status, BookStatus.loaded);
        expect(readState().books.isNotEmpty, true);
      });

      test("should emit error when fetching books fails", () async {
        const failure = ApiFailure(message: "Failed to fetch books");

        when(
          () => mockGetAllBookUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().getAllBooks();

        expect(readState().status, BookStatus.error);
        expect(readState().errorMessage, "Failed to fetch books");
      });
    });

    /// GET BOOK BY ID
    group("getBookById", () {
      test("should emit loaded with book on success", () async {
        when(
          () => mockGetBookByIdUsecase(any()),
        ).thenAnswer((_) async => Right(tBook));

        await readViewModel().getBookById("1");

        expect(readState().status, BookStatus.loaded);
        expect(readState().book, tBook);
      });

      test("should emit error when getBookById fails", () async {
        const failure = ApiFailure(message: "Book not found");

        when(
          () => mockGetBookByIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().getBookById("1");

        expect(readState().status, BookStatus.error);
        expect(readState().errorMessage, "Book not found");
      });
    });

    /// GET BOOKS BY GENRE
    group("getBooksByGenreId", () {
      test("should emit loaded books on success", () async {
        when(
          () => mockGetBooksByGenreIdUsecase(any()),
        ).thenAnswer((_) async => Right(tBooks));

        await readViewModel().getBooksByGenreId("genre1");

        expect(readState().status, BookStatus.loaded);
        expect(readState().books, tBooks);
      });

      test("should emit error when genre fetch fails", () async {
        const failure = ApiFailure(message: "Genre books not found");

        when(
          () => mockGetBooksByGenreIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().getBooksByGenreId("genre1");

        expect(readState().status, BookStatus.error);
        expect(readState().errorMessage, "Genre books not found");
      });
    });
  });
}
