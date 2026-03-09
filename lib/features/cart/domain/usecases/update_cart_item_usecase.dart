import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/cart/data/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/usecases/create_cart_usecase.dart';

final updateCartUsecaseProvider = Provider<UpdateCartUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return UpdateCartUsecase(cartRepository: repo);
});

class UpdateCartUsecase
    implements UseCaseWithParams<bool, CreateCartUsecaseParams> {
  final ICartRepository _cartRepository;

  const UpdateCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call(CreateCartUsecaseParams params) {
    final entity = CartEntity(bookId: params.bookId, quantity: params.quantity);
    return _cartRepository.updateCartItem(entity);
  }
}
