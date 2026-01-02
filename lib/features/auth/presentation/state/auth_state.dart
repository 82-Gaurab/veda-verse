import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus { initial, loading, authenticated, register, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? entity;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.entity,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? entity,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entity, errorMessage];
}
