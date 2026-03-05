import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/cart/data/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';

final deleteCartUsecaseProvider = Provider<DeleteCartUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return DeleteCartUsecase(cartRepository: repo);
});

class DeleteCartUsecase implements UseCaseWithParams<bool, String> {
  final ICartRepository _cartRepository;

  const DeleteCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call(String bookId) {
    return _cartRepository.deleteCartItem(bookId);
  }
}
