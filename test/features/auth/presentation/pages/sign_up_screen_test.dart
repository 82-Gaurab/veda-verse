import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/features/auth/presentation/pages/sign_up_screen.dart';
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
    child: const MaterialApp(home: SignUpScreen()),
  );
}

void main() {
  late MockAuthViewModel mock;

  setUp(() {
    mock = MockAuthViewModel();
  });

  group('rendering', () {
    testWidgets('Renders 5 text fields', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('Shows header texts', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.text('Join Us Today'), findsOneWidget);
      expect(find.text('Create your account to get started'), findsOneWidget);
    });

    testWidgets('Shows Sign Up button', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    });
  });

  group('password visibility', () {
    testWidgets('Passwords are obscured by default', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();

      // password field is index 3, confirm is 4
      expect(fields[3].obscureText, isTrue);
      expect(fields[4].obscureText, isTrue);
    });

    testWidgets('Tapping visibility toggles password', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: mock));

      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pump();

      final fields = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();

      expect(fields[3].obscureText, isFalse);
    });
  });

  group('loading state', () {
    testWidgets('Shows spinner when loading', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadingAuthViewModel()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Button disabled when loading', (tester) async {
      await tester.pumpWidget(buildWidget(notifier: LoadingAuthViewModel()));

      final btnFinder = find.byType(ElevatedButton);
      expect(btnFinder, findsOneWidget);

      final btn = tester.widget<ElevatedButton>(btnFinder);
      expect(btn.onPressed, isNull);
    });
  });
}
