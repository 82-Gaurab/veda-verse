import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/usecases/register_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

// Fake for AuthEntity to use with any() or captureAny()
class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase registerUsecase;
  late MockAuthRepository mockAuthRepository;
  late RegisterUsecaseParams tParams;
  // ignore: unused_local_variable
  late AuthEntity tAuthEntity;

  setUpAll(() {
    // Register fallback so `any()` works for AuthEntity
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
    tParams = const RegisterUsecaseParams(
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@email.com',
      username: 'johndoe',
      password: 'password123',
      confirmPassword: 'password123',
      profilePicture: 'profile.png',
    );
    tAuthEntity = AuthEntity(
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@email.com',
      username: 'johndoe',
      password: 'password123',
      confirmPassword: 'password123',
      profilePicture: 'profile.png',
    );
  });

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await registerUsecase(tParams);

      expect(result, const Right(true));
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ApiFailure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Email already exists');
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await registerUsecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should call repository with correct AuthEntity', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      await registerUsecase(tParams);

      final captured =
          verify(() => mockAuthRepository.register(captureAny())).captured.first
              as AuthEntity;

      expect(captured.firstName, equals('John'));
      expect(captured.lastName, equals('Doe'));
      expect(captured.email, equals('johndoe@email.com'));
      expect(captured.username, equals('johndoe'));
      expect(captured.password, equals('password123'));
      expect(captured.confirmPassword, equals('password123'));
      expect(captured.profilePicture, equals('profile.png'));
    });

    test('should call repository only once', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      await registerUsecase(tParams);

      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
