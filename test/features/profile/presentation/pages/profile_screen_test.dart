import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vedaverse/features/profile/presentation/pages/profile_screen.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/profile/presentation/widgets/profile_avatar.dart';

// MOCK AUTH VIEW MODEL

class FakeAuthViewModel extends AuthViewModel {
  bool logoutCalled = false;

  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.initial);
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}

// MOCK USER SESSION

class MockUserSessionService implements UserSessionService {
  @override
  String? getUserFirstName() => "John";

  @override
  String? getUserLastName() => "Doe";

  @override
  String? getUserEmail() => "john@example.com";

  @override
  String? getUsername() => "john_doe";

  @override
  String? getUserProfileImage() => "";
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// TEST MAIN

void main() {
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'token': 'fake-token',
      'userId': '1',
    });

    prefs = await SharedPreferences.getInstance();
  });

  Widget buildWidget({
    required FakeAuthViewModel authNotifier,
    required UserSessionService userSession,
  }) {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => authNotifier),
        userSessionServiceProvider.overrideWithValue(userSession),
        sharedPreferenceProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    );
  }

  group('ProfileScreen UI', () {
    testWidgets('shows user profile information', (tester) async {
      final fakeAuth = FakeAuthViewModel();

      await tester.pumpWidget(
        buildWidget(
          authNotifier: fakeAuth,
          userSession: MockUserSessionService(),
        ),
      );

      await tester.pump();

      expect(find.text("Profile"), findsOneWidget);
      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("john@example.com"), findsOneWidget);
    });
  });

  group('ProfileScreen Avatar Edit', () {
    testWidgets('tapping edit icon opens media picker sheet', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              imageUrl: "default",
              onEditTap: () => tapped = true,
            ),
          ),
        ),
      );

      final editButton = find.byIcon(Icons.edit);
      await tester.ensureVisible(editButton);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });

  group('ProfileScreen Logout', () {
    testWidgets('opens logout dialog', (tester) async {
      final fakeAuth = FakeAuthViewModel();

      await tester.pumpWidget(
        buildWidget(
          authNotifier: fakeAuth,
          userSession: MockUserSessionService(),
        ),
      );

      await tester.pump();

      await tester.ensureVisible(find.text("Log Out"));
      await tester.tap(find.text("Log Out"));
      await tester.pumpAndSettle();

      expect(find.text("Are you sure you want to logout?"), findsOneWidget);
      expect(find.text("Cancel"), findsOneWidget);
    });

    testWidgets("calls logout when confirmed", (tester) async {
      final fakeAuth = FakeAuthViewModel();

      await tester.pumpWidget(
        buildWidget(
          authNotifier: fakeAuth,
          userSession: MockUserSessionService(),
        ),
      );

      await tester.pump();

      await tester.ensureVisible(find.text("Log Out"));
      await tester.tap(find.text("Log Out"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Logout").last);
      await tester.pumpAndSettle();

      expect(fakeAuth.logoutCalled, true);
    });
  });
}
