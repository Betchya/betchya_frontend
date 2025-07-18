import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeAuthController extends AuthController {
  _FakeAuthController();

  bool signOutCalled = false;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<User?> build() async {
    return null; // No user info needed for this test
  }
}

void main() {
  Future<void> pumpHomeScreen(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeScreen', () {
    testWidgets('renders main UI elements', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const Key('home_logout_button')), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('calls signOut when logout button is tapped', (tester) async {
      // Use a mock for the AuthController
      final fakeAuthController = _FakeAuthController();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => fakeAuthController),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(fakeAuthController.signOutCalled, isFalse);

      await tester.tap(find.byKey(const Key('home_logout_button')));
      await tester.pump();

      expect(fakeAuthController.signOutCalled, isTrue);
    });
  });
}
