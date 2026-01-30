// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }
}

void main() {
  testWidgets("Should have logo", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final Image imageWidget = tester.widget<Image>(imageFinder);
    final AssetImage assetImage = imageWidget.image as AssetImage;

    expect(assetImage.assetName, "assets/icons/logo.png");
  });

  testWidgets("Should have input field", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder emailField = find.byType(TextField).at(0);
    Finder passwordField = find.byType(TextField).at(1);

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
  });

  testWidgets("Should have login button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    Finder loginButton = find.widgetWithText(ElevatedButton, "Login");

    expect(loginButton, findsOneWidget);
  });
}
