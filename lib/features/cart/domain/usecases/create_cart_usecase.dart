import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/cart/data/repository/cart_repository.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';

final createCartUsecaseProvider = Provider<CreateCartUsecase>((ref) {
  final cartRepository = ref.read(cartRepositoryProvider);
  return CreateCartUsecase(cartRepository: cartRepository);
});

class CreateCartUsecaseParams extends Equatable {
  final String bookId;
  final int quantity;

  const CreateCartUsecaseParams({required this.bookId, required this.quantity});

  @override
  List<Object?> get props => [bookId, quantity];
}

class CreateCartUsecase
    implements UseCaseWithParams<bool, CreateCartUsecaseParams> {
  final ICartRepository _cartRepository;

  const CreateCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;
  @override
  Future<Either<Failure, bool>> call(CreateCartUsecaseParams params) {
    final entity = CartEntity(bookId: params.bookId, quantity: params.quantity);
    return _cartRepository.createCart(entity);
  }
}
