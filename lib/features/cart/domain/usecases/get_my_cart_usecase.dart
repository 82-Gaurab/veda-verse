import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/cart/data/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';

final getMyCartUsecaseProvider = Provider<GetMyCartUsecase>((ref) {
  final cartRepository = ref.read(cartRepositoryProvider);
  return GetMyCartUsecase(cartRepository: cartRepository);
});

class GetMyCartUsecase implements UseCaseWithoutParams {
  final ICartRepository _cartRepository;
  const GetMyCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;
  @override
  Future<Either<Failure, List<CartEntity>>> call() {
    return _cartRepository.getMyCart();
  }
}
