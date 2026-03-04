import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';

class MockAuthViewModel extends AuthViewModel with Mock {
  @override
  AuthState build() => const AuthState(status: AuthStatus.initial);
}

class LoadingAuthViewModel extends AuthViewModel with Mock {
  @override
  AuthState build() => const AuthState(status: AuthStatus.loading);
}

Widget buildWidget({required AuthViewModel notifier}) {
  return ProviderScope(
    overrides: [authViewModelProvider.overrideWith(() => notifier)],
    child: const MaterialApp(home: LoginScreen()),
  );
}

Future<void> tapLogin(WidgetTester tester) async {
  final btn = find.widgetWithText(ElevatedButton, 'Login');
  await tester.ensureVisible(btn);
  await tester.tap(btn);
  await tester.pump();
}

void main() {
  late MockAuthViewModel mock;

  setUp(() {
    mock = MockAuthViewModel();
  });

  group('rendering', () {
    testWidgets('Renders 2 text fields', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Shows welcome texts', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to Continue'), findsOneWidget);
    });

    testWidgets('Shows login button', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Shows Sign Up link', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Shows Forgot Password link', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });

  group('validation', () {
    testWidgets('Shows errors on empty submit', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      await tapLogin(tester);

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows error for invalid email', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');

      await tapLogin(tester);

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Shows error for short password', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      await tester.enterText(find.byType(TextFormField).at(1), '123');

      await tapLogin(tester);

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
  });

  group('password visibility', () {
    testWidgets('Password is obscured by default', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();

      expect(fields[1].obscureText, isTrue);
    });

    testWidgets('Tapping visibility icon toggles password', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();

      expect(fields[1].obscureText, isFalse);
    });
  });

  group('loading state', () {
    testWidgets('Shows spinner when loading', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadingAuthViewModel()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Login button is disabled when loading', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadingAuthViewModel()));

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(btn.onPressed, isNull);
    });
  });
}
