import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/books/data/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';

final getAllBookUsecaseProvider = Provider<GetAllBookUsecase>((ref) {
  final bookRepository = ref.read(bookRepositoryProvider);
  return GetAllBookUsecase(bookRepository: bookRepository);
});

class GetAllBookUsecase implements UseCaseWithoutParams {
  final IBookRepository _bookRepository;

  const GetAllBookUsecase({required IBookRepository bookRepository})
    : _bookRepository = bookRepository;
  @override
  Future<Either<Failure, List<BookEntity>>> call() {
    return _bookRepository.getAllBooks();
  }
}
