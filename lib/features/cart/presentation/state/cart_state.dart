import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, error, loaded }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? entity;
  final String? errorMessage;
  // store image temporarily
  final String? uploadPhotoName;

  const CartState({
    this.status = CartStatus.initial,
    this.entity,
    this.errorMessage,
    this.uploadPhotoName,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? entity,
    String? errorMessage,
    String? uploadPhotoName,
  }) {
    return CartState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  List<Object?> get props => [status, entity, errorMessage, uploadPhotoName];
}
