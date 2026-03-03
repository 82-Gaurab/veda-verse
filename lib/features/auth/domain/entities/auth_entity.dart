import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  final List<CartEntity> cart;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.profilePicture,
    this.confirmPassword,
    this.password,
    this.cart = const [],
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    username,
    profilePicture,
    cart,
  ];
}
