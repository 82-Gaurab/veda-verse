import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, bool>> createCart(CartEntity entity);
}
