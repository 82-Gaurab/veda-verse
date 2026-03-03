import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/books/data/repository/book_repository.dart';
import 'package:vedaverse/features/books/domain/entity/book_entity.dart';
import 'package:vedaverse/features/books/domain/repository/book_repository.dart';

final getBooksByGenreIdUsecaseProvider = Provider<GetBooksByGenreIdUsecase>((
  ref,
) {
  final bookRepository = ref.read(bookRepositoryProvider);
  return GetBooksByGenreIdUsecase(bookRepository: bookRepository);
});

class GetBooksByGenreIdParams extends Equatable {
  final String genreId;

  const GetBooksByGenreIdParams({required this.genreId});

  @override
  List<Object?> get props => [genreId];
}

class GetBooksByGenreIdUsecase
    implements UseCaseWithParams<List<BookEntity>, GetBooksByGenreIdParams> {
  final IBookRepository _bookRepository;

  const GetBooksByGenreIdUsecase({required IBookRepository bookRepository})
    : _bookRepository = bookRepository;

  @override
  Future<Either<Failure, List<BookEntity>>> call(
    GetBooksByGenreIdParams params,
  ) {
    return _bookRepository.getBooksByGenreId(params.genreId);
  }
}
