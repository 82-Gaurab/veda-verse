import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  register,
  error,
  loaded,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? entity;
  final String? errorMessage;
  final String? otp;
  // store image temporarily
  final String? uploadPhotoName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.entity,
    this.errorMessage,
    this.uploadPhotoName,
    this.otp,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? entity,
    String? errorMessage,
    String? uploadPhotoName,
    String? otp,
  }) {
    return AuthState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: errorMessage ?? this.errorMessage,
      otp: otp ?? this.otp,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  List<Object?> get props => [status, entity, errorMessage, uploadPhotoName];
}
