import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/usecases/get_all_book_usecase.dart';
import 'package:vedaverse/features/books/domain/usecases/get_book_by_id_usecase.dart';
import 'package:vedaverse/features/books/domain/usecases/get_books_by_genre_id_usecase.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';

final bookViewModelProvider = NotifierProvider<BookViewModel, BookState>(() {
  return BookViewModel();
});

class BookViewModel extends Notifier<BookState> {
  late final GetAllBookUsecase _getAllBookUsecase;
  late final GetBooksByGenreIdUsecase _getBooksByGenreIdUsecase;
  late final GetBookByIdUsecase _getBookByIdUsecase;

  @override
  BookState build() {
    _getAllBookUsecase = ref.read(getAllBookUsecaseProvider);
    _getBooksByGenreIdUsecase = ref.read(getBooksByGenreIdUsecaseProvider);
    _getBookByIdUsecase = ref.read(getBookByIdUsecaseProvider);

    return const BookState();
  }

  Future<void> getAllBooks() async {
    state = state.copyWith(status: BookStatus.loading);

    final result = await _getAllBookUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
      (books) {
        if (books.isEmpty) {
          state = state.copyWith(
            status: BookStatus.loaded,
            books: [BookEntity(title: "title", author: "author", price: 4)],
          );
        } else {
          state = state.copyWith(status: BookStatus.loaded, books: books);
        }
      },
    );
  }

  Future<void> getBookById(String bookId) async {
    state = state.copyWith(status: BookStatus.loading);

    final params = GetBookByIdUsecaseParams(bookId: bookId);

    final result = await _getBookByIdUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
      (book) => state = state.copyWith(status: BookStatus.loaded, book: book),
    );
  }

  Future<void> getBooksByGenreId(String genreId) async {
    state = state.copyWith(status: BookStatus.loading);

    final params = GetBooksByGenreIdParams(genreId: genreId);

    final result = await _getBooksByGenreIdUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: BookStatus.error,
        errorMessage: failure.message,
      ),
      (books) =>
          state = state.copyWith(status: BookStatus.loaded, books: books),
    );
  }
}
