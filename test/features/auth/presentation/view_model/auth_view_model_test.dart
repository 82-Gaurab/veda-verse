import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';

import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/login_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/register_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:vedaverse/features/auth/domain/usecases/upload_image_usecase.dart';

import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';

/// Mocks

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateUserUsecase extends Mock implements UpdateUserUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

class MockGetMyInfoUsecase extends Mock implements GetMyInfoUsecase {}

/// Fakes

class FakeRegisterParams extends Fake implements RegisterUsecaseParams {}

class FakeLoginParams extends Fake implements LoginUsecaseParams {}

class FakeUpdateUserParams extends Fake implements UpdateUserUsecaseParams {}

class FakeUploadImageParams extends Fake implements UploadImageUsecaseParams {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUpdateUserUsecase mockUpdateUserUsecase;
  late MockUploadImageUsecase mockUploadImageUsecase;
  late MockGetMyInfoUsecase mockGetMyInfoUsecase;

  late ProviderContainer container;

  late AuthEntity tUser;

  setUpAll(() {
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeUpdateUserParams());
    registerFallbackValue(FakeUploadImageParams());
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUpdateUserUsecase = MockUpdateUserUsecase();
    mockUploadImageUsecase = MockUploadImageUsecase();
    mockGetMyInfoUsecase = MockGetMyInfoUsecase();

    tUser = AuthEntity(
      authId: "1",
      firstName: "John",
      lastName: "Doe",
      email: "john@email.com",
      username: "john123",
      profilePicture: "profile.jpg",
    );

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUseCaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        updateUserUsecaseProvider.overrideWithValue(mockUpdateUserUsecase),
        uploadImageUsecaseProvider.overrideWithValue(mockUploadImageUsecase),
        getMyInfoUsecaseProvider.overrideWithValue(mockGetMyInfoUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  AuthViewModel readViewModel() =>
      container.read(authViewModelProvider.notifier);

  AuthState readState() => container.read(authViewModelProvider);

  group("AuthViewModel", () {
    /// INITIAL STATE
    group("initial state", () {
      test("should have correct initial state", () {
        expect(readState().status, AuthStatus.initial);
        expect(readState().entity, isNull);
        expect(readState().errorMessage, isNull);
      });
    });

    /// REGISTER
    group("register", () {
      test("should emit register status on success", () async {
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        await readViewModel().register(
          firstName: "John",
          lastName: "Doe",
          username: "john",
          email: "john@email.com",
          password: "123456",
          confirmPassword: "123456",
        );

        expect(readState().status, AuthStatus.register);
      });

      test("should emit error when register fails", () async {
        const failure = ApiFailure(message: "Registration failed");

        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().register(
          firstName: "John",
          lastName: "Doe",
          username: "john",
          email: "john@email.com",
          password: "123456",
          confirmPassword: "123456",
        );

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Registration failed");
      });
    });

    /// LOGIN
    group("login", () {
      test("should authenticate user on success", () async {
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => Right(tUser));

        await readViewModel().login(
          email: "john@email.com",
          password: "123456",
        );

        expect(readState().status, AuthStatus.authenticated);
        expect(readState().entity, tUser);
      });

      test("should emit error when login fails", () async {
        const failure = ApiFailure(message: "Login failed");

        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().login(
          email: "john@email.com",
          password: "123456",
        );

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Login failed");
      });
    });

    /// UPDATE USER
    group("updateUser", () {
      test("should emit loaded status when update succeeds", () async {
        when(
          () => mockUpdateUserUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        await readViewModel().updateUser(
          firstName: "John",
          lastName: "Doe",
          username: "john",
          email: "john@email.com",
        );

        expect(readState().status, AuthStatus.loaded);
      });

      test("should emit error when update fails", () async {
        const failure = ApiFailure(message: "Update failed");

        when(
          () => mockUpdateUserUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().updateUser(
          firstName: "John",
          lastName: "Doe",
          username: "john",
          email: "john@email.com",
        );

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Update failed");
      });
    });

    /// UPLOAD PHOTO
    group("uploadPhoto", () {
      test("should upload photo successfully", () async {
        when(
          () => mockUploadImageUsecase(any()),
        ).thenAnswer((_) async => const Right("image.png"));

        await readViewModel().uploadPhoto(File("test.png"));

        expect(readState().status, AuthStatus.loaded);
        expect(readState().uploadPhotoName, "image.png");
      });

      test("should emit error when upload fails", () async {
        const failure = ApiFailure(message: "Upload failed");

        when(
          () => mockUploadImageUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().uploadPhoto(File("test.png"));

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Upload failed");
      });
    });

    /// GET MY INFO
    group("getMyInfo", () {
      test("should load user info successfully", () async {
        when(
          () => mockGetMyInfoUsecase(),
        ).thenAnswer((_) async => Right(tUser));

        await readViewModel().getMyInfo();

        expect(readState().status, AuthStatus.loaded);
        expect(readState().entity, tUser);
      });

      test("should emit error when getMyInfo fails", () async {
        const failure = ApiFailure(message: "Failed to fetch user");

        when(
          () => mockGetMyInfoUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().getMyInfo();

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Failed to fetch user");
      });
    });

    /// LOGOUT
    group("logout", () {
      test("should logout successfully", () async {
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Right(true));

        await readViewModel().logout();

        expect(readState().status, AuthStatus.unauthenticated);
        expect(readState().entity, isNull);
      });

      test("should emit error when logout fails", () async {
        const failure = ApiFailure(message: "Logout failed");

        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().logout();

        expect(readState().status, AuthStatus.error);
        expect(readState().errorMessage, "Logout failed");
      });
    });
  });
}
