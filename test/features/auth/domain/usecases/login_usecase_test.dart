import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/usecases/login_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;
  late LoginUsecaseParams tParams;
  late AuthEntity tAuthEntity;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
    tParams = const LoginUsecaseParams(
      email: 'johndoe@email.com',
      password: 'password123',
    );
    tAuthEntity = AuthEntity(
      email: 'johndoe@email.com',
      username: 'johndoe',
      password: 'password123',
      confirmPassword: 'password123',
      firstName: 'John',
      lastName: 'Doe',
    );
  });

  group('LoginUsecase', () {
    test('should return AuthEntity when login is successful', () async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      final result = await loginUsecase(tParams);

      expect(result, Right<Failure, AuthEntity>(tAuthEntity));
      verify(() => mockAuthRepository.login(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ApiFailure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Invalid credentials');
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await loginUsecase(tParams);

      expect(result, const Left<Failure, AuthEntity>(tFailure));
      verify(() => mockAuthRepository.login(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository with correct email and password', () async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      await loginUsecase(tParams);

      final captured = verify(
        () => mockAuthRepository.login(captureAny(), captureAny()),
      ).captured;

      expect(captured[0], equals('johndoe@email.com'));
      expect(captured[1], equals('password123'));
    });

    test('should call repository only once', () async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      await loginUsecase(tParams);

      verify(() => mockAuthRepository.login(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ApiFailure when password is wrong', () async {
      const tFailure = ApiFailure(message: 'Wrong password');
      const tWrongParams = LoginUsecaseParams(
        email: 'johndoe@email.com',
        password: 'wrongpassword',
      );
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await loginUsecase(tWrongParams);

      expect(result, const Left<Failure, AuthEntity>(tFailure));
      verify(() => mockAuthRepository.login(any(), any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
