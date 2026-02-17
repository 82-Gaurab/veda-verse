import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/books/data/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';

final getBookByIdUsecaseProvider = Provider<GetBookByIdUsecase>((ref) {
  final bookRepository = ref.read(bookRepositoryProvider);
  return GetBookByIdUsecase(bookRepository: bookRepository);
});

class GetBookByIdUsecaseParams extends Equatable {
  final String bookId;

  const GetBookByIdUsecaseParams({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}

class GetBookByIdUsecase
    implements UseCaseWithParams<BookEntity, GetBookByIdUsecaseParams> {
  final IBookRepository _bookRepository;

  const GetBookByIdUsecase({required IBookRepository bookRepository})
    : _bookRepository = bookRepository;
  @override
  Future<Either<Failure, BookEntity>> call(GetBookByIdUsecaseParams params) {
    return _bookRepository.getBookById(params.bookId);
  }
}
