import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/auth/domain/usecases/login_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/register_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/upload_image_usecase.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';

// Notifier provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UploadImageUsecase _uploadImageUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUseCaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadImageUsecase = ref.read(uploadImageUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      firstName: firstName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      lastName: lastName,
      profilePicture: 'default',
    );

    final result = await _registerUsecase(params);

    result.fold(
      (left) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: left.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(status: AuthStatus.register);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Registration Failed",
          );
        }
      },
    );
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);

    result.fold(
      (left) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: left.message,
      ),
      (entity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        entity: entity,
      ),
    );
  }

  // upload photo
  Future<void> uploadPhoto(File image) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = UploadImageUsecaseParams(image: image);
    final result = await _uploadImageUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) {
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadPhotoName: imageName,
        );
      },
    );
  }

  //Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        entity: null,
      ),
    );
  }
}
