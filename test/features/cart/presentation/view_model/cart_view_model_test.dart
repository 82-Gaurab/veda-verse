import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/usecases/create_cart_usecase.dart';
import 'package:vedaverse/features/cart/domain/usecases/get_my_cart_usecase.dart';

import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';

/// Mocks

class MockCreateCartUsecase extends Mock implements CreateCartUsecase {}

class MockGetMyCartUsecase extends Mock implements GetMyCartUsecase {}

/// Fakes
class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeCreateCartParams extends Fake implements CreateCartUsecaseParams {}

void main() {
  late MockCreateCartUsecase mockCreateCartUsecase;
  late MockGetMyCartUsecase mockGetMyCartUsecase;
  late MockSharedPreferences mockSharedPreferences;
  late ProviderContainer container;

  late List<CartEntity> tCartList;

  setUpAll(() {
    registerFallbackValue(FakeCreateCartParams());
  });

  setUp(() {
    mockCreateCartUsecase = MockCreateCartUsecase();
    mockGetMyCartUsecase = MockGetMyCartUsecase();
    mockSharedPreferences = MockSharedPreferences();

    tCartList = [
      CartEntity(bookId: "book1", quantity: 2),
      CartEntity(bookId: "book2", quantity: 1),
    ];

    container = ProviderContainer(
      overrides: [
        createCartUsecaseProvider.overrideWithValue(mockCreateCartUsecase),
        getMyCartUsecaseProvider.overrideWithValue(mockGetMyCartUsecase),
        sharedPreferenceProvider.overrideWithValue(mockSharedPreferences),
      ],
    );
  });

  tearDown(() => container.dispose());

  CartViewModel readViewModel() =>
      container.read(cartViewModelProvider.notifier);

  CartState readState() => container.read(cartViewModelProvider);

  group("CartViewModel", () {
    /// INITIAL STATE
    group("initial state", () {
      test("should have correct initial state", () {
        expect(readState().status, CartStatus.initial);
        expect(readState().entities, isNull);
        expect(readState().errorMessage, isNull);
      });
    });

    /// CREATE CART
    group("createCart", () {
      test("should emit loaded when createCart succeeds", () async {
        when(
          () => mockCreateCartUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        await readViewModel().createCart(bookId: "book1", quantity: 2);

        expect(readState().status, CartStatus.loaded);
      });

      test("should emit error when createCart returns false", () async {
        when(
          () => mockCreateCartUsecase(any()),
        ).thenAnswer((_) async => const Right(false));

        await readViewModel().createCart(bookId: "book1", quantity: 2);

        expect(readState().status, CartStatus.error);
        expect(readState().errorMessage, "Failed to Add to cart");
      });

      test("should emit error when createCart fails", () async {
        const failure = ApiFailure(message: "Add to cart failed");

        when(
          () => mockCreateCartUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().createCart(bookId: "book1", quantity: 2);

        expect(readState().status, CartStatus.error);
        expect(readState().errorMessage, "Add to cart failed");
      });
    });

    /// GET MY CART
    group("getMyCart", () {
      test("should emit loaded with cart entities on success", () async {
        when(
          () => mockGetMyCartUsecase(),
        ).thenAnswer((_) async => Right(tCartList));

        await readViewModel().getMyCart();

        expect(readState().status, CartStatus.loaded);
        expect(readState().entities, tCartList);
      });

      test("should emit error when getMyCart fails", () async {
        const failure = ApiFailure(message: "Failed to fetch cart");

        when(
          () => mockGetMyCartUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readViewModel().getMyCart();

        expect(readState().status, CartStatus.error);
        expect(readState().errorMessage, "Failed to fetch cart");
      });
    });
  });
}
