import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, error, loaded }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? entity;
  final List<CartEntity>? entities;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.entity,
    this.errorMessage,
    this.entities,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? entity,
    String? errorMessage,
    List<CartEntity>? entities,
  }) {
    return CartState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: errorMessage ?? this.errorMessage,
      entities: entities ?? this.entities,
    );
  }

  @override
  List<Object?> get props => [status, entity, errorMessage, entities];
}
