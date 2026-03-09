// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/usecases/update_user_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

// Fake for AuthEntity to use with any() or captureAny()
class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late UpdateUserUsecase updateUserUsecase;
  late MockAuthRepository mockAuthRepository;
  late UpdateUserUsecaseParams tParams;
  late AuthEntity tAuthEntity;
  late File tProfileFile;

  setUpAll(() {
    // Register fallback for AuthEntity
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    updateUserUsecase = UpdateUserUsecase(authRepository: mockAuthRepository);
    tProfileFile = File('profile.png'); // dummy file
    tParams = UpdateUserUsecaseParams(
      authId: 'auth123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@email.com',
      username: 'johndoe',
      profilePicture: tProfileFile,
    );
    tAuthEntity = AuthEntity(
      authId: 'auth123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@email.com',
      username: 'johndoe',
      profilePicture: tProfileFile.path,
    );
  });

  group('UpdateUserUsecase', () {
    test('should return true when update is successful', () async {
      when(
        () => mockAuthRepository.updateUser(any(), any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await updateUserUsecase(tParams);

      expect(result, const Right(true));
      verify(() => mockAuthRepository.updateUser(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ApiFailure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Update failed');
      when(
        () => mockAuthRepository.updateUser(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await updateUserUsecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.updateUser(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository with correct AuthEntity and File', () async {
      when(
        () => mockAuthRepository.updateUser(any(), any()),
      ).thenAnswer((_) async => const Right(true));

      await updateUserUsecase(tParams);

      final captured = verify(
        () => mockAuthRepository.updateUser(
          captureAny<AuthEntity>(),
          captureAny<File?>(),
        ),
      ).captured;

      final capturedEntity = captured[0] as AuthEntity;
      final capturedFile = captured[1] as File;

      expect(capturedEntity.authId, equals('auth123'));
      expect(capturedEntity.firstName, equals('John'));
      expect(capturedEntity.lastName, equals('Doe'));
      expect(capturedEntity.email, equals('johndoe@email.com'));
      expect(capturedEntity.username, equals('johndoe'));
      expect(capturedEntity.profilePicture, equals('profile.png'));

      expect(capturedFile.path, equals('profile.png'));
    });
    test('should call repository only once', () async {
      when(
        () => mockAuthRepository.updateUser(any(), any()),
      ).thenAnswer((_) async => const Right(true));

      await updateUserUsecase(tParams);

      verify(() => mockAuthRepository.updateUser(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
