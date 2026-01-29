import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/core/widgets/my_input_form_field.dart';
import 'package:vedaverse/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/auth/presentation/widgets/password_field.dart';

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }
}

void main() {
  testWidgets("Should have Input fields", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: SignUpScreen()),
      ),
    );

    await tester.pumpAndSettle();

    Finder firstNameField = find.byType(TextField).at(0);
    Finder lastNameField = find.byType(TextField).at(1);
    Finder emailField = find.byType(MyInputFormField);
    Finder passwordField = find.byType(PasswordField).first;
    Finder confirmPasswordField = find.byType(PasswordField).last;

    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(confirmPasswordField, findsOneWidget);
  });

  testWidgets("Should have SignUp button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: SignUpScreen()),
      ),
    );

    await tester.pumpAndSettle();

    Finder signUpButton = find.widgetWithText(ElevatedButton, "Sign Up");

    expect(signUpButton, findsOneWidget);
  });
}
