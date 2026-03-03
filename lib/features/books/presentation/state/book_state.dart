import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';

enum BookStatus { initial, loading, loaded, error, deleted }

class BookState extends Equatable {
  final BookStatus status;
  final List<BookEntity> books;
  final BookEntity? book;
  final String? errorMessage;

  const BookState({
    this.status = BookStatus.initial,
    this.books = const [],
    this.book,
    this.errorMessage,
  });

  BookState copyWith({
    BookStatus? status,
    List<BookEntity>? books,
    BookEntity? book,
    String? errorMessage,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      book: book ?? this.book,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}
