import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vedaverse/features/auth/presentation/pages/update_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';

class MockAuthViewModel extends AuthViewModel with Mock {
  @override
  AuthState build() => const AuthState(status: AuthStatus.initial);

  @override
  Future<void> updateUser({
    String? authId,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    File? profilePicture,
  }) async {}
}

class LoadingAuthViewModel extends AuthViewModel with Mock {
  @override
  AuthState build() => const AuthState(status: AuthStatus.loading);
}

class MockUserSessionService extends Mock implements UserSessionService {}

Widget buildWidget({
  required AuthViewModel notifier,
  required UserSessionService userSession,
}) {
  return ProviderScope(
    overrides: [
      authViewModelProvider.overrideWith(() => notifier),
      userSessionServiceProvider.overrideWithValue(userSession),
    ],
    child: const MaterialApp(home: UpdateScreen()),
  );
}

void main() {
  late MockAuthViewModel mockAuth;
  late MockUserSessionService mockSession;

  setUp(() {
    mockAuth = MockAuthViewModel();
    mockSession = MockUserSessionService();

    // Default session stub
    when(() => mockSession.getUserId()).thenReturn('123');
    when(() => mockSession.getUserFirstName()).thenReturn('John');
    when(() => mockSession.getUserLastName()).thenReturn('Doe');
    when(() => mockSession.getUserEmail()).thenReturn('john@example.com');
  });

  group('UpdateScreen rendering', () {
    testWidgets('renders header text and text fields', (tester) async {
      await tester.pumpWidget(
        buildWidget(notifier: mockAuth, userSession: mockSession),
      );

      expect(find.text('Update you profile'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // first, last, username
      expect(
        find.widgetWithText(ElevatedButton, 'Update Profile'),
        findsOneWidget,
      );
    });
  });

  group('loading state', () {
    testWidgets('shows spinner and disables button', (tester) async {
      await tester.pumpWidget(
        buildWidget(notifier: LoadingAuthViewModel(), userSession: mockSession),
      );

      final btnFinder = find.byType(ElevatedButton);
      expect(btnFinder, findsOneWidget);

      final btn = tester.widget<ElevatedButton>(btnFinder);
      expect(btn.onPressed, isNull);

      // Spinner inside button
      expect(
        find.descendant(
          of: btnFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });
  });
}
