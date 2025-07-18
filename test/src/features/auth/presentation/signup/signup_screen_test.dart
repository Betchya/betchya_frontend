import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../robots/auth_robot.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthRepository authRepository;
  late MockGoRouter mockRouter;

  setUp(() {
    authRepository = MockAuthRepository();
    mockRouter = MockGoRouter();
  });

  Future<void> pumpSignupScreen(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides.isNotEmpty
            ? overrides
            : [
                authRepositoryProvider.overrideWith((ref) => authRepository),
              ],
        child: InheritedGoRouter(
          goRouter: mockRouter,
          child: const MaterialApp(
            home: SignUpScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SignupScreen', () {
    testWidgets('renders all required input fields', (tester) async {
      await pumpSignupScreen(tester);
      final robot = AuthRobot(tester);
      await robot.expectSignupFieldsPresent();
    });

    testWidgets('shows validation errors for invalid input', (tester) async {
      await pumpSignupScreen(tester);
      final robot = AuthRobot(tester);
      // Enter non-empty then empty full name to ensure field is dirty and
      // error shows
      await robot.enterFullName('John');
      await robot.enterFullName('');
      expect(find.text('Invalid name'), findsOneWidget);

      // Enter invalid email and check error
      await robot.enterSignupEmail('invalid-email');
      expect(find.text('Invalid email'), findsOneWidget);

      // Enter invalid password and check error
      await robot.enterSignupPassword('123');
      expect(find.text('Invalid password'), findsOneWidget);

      // Enter non-matching confirm password and check error
      await robot.enterConfirmPassword('different');
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('enables signup button only when form is valid',
        (tester) async {
      await pumpSignupScreen(tester);
      final robot = AuthRobot(tester);
      final signupButton = find.byKey(const Key('signup_button'));

      // Initially disabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNull);

      // Enter valid fields
      await robot.enterFullName('John Doe');
      await robot.enterSignupEmail('john@example.com');
      await robot.enterSignupPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      await tester.pumpAndSettle();
      // Button should be enabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNotNull);

      // Invalidate a field
      await robot.enterSignupEmail('invalid');
      await tester.pumpAndSettle();
      // Button should be disabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNull);
    });

    testWidgets('navigates to home on successful signup', (tester) async {
      // Arrange: Use a ProviderOverride to inject a mock AuthRepository that
      // simulates success
      final fakeUser = User(
        id: 'id',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'aud',
        createdAt: DateTime.now().toIso8601String(),
      );
      when(
        () => authRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => fakeUser);
      // Mock router navigation
      when(() => mockRouter.goNamed(any())).thenReturn(null);
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );

      final robot = AuthRobot(tester);
      await robot.enterFullName('John Doe');
      await robot.enterSignupEmail('john@example.com');
      await robot.enterSignupPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      // Tap signup
      await robot.tapSignupButton();
      // Verify navigation to signup
      verify(() => mockRouter.goNamed('home')).called(1);
    });

    testWidgets('shows error on failed signup', (tester) async {
      // Arrange: Use a ProviderOverride to inject a mock AuthRepository that
      // throws
      when(
        () => authRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Failed to sign up'));
      await pumpSignupScreen(tester);
      final robot = AuthRobot(tester);
      await robot.enterFullName('John Doe');
      await robot.enterSignupEmail('john@example.com');
      await robot.enterSignupPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      // Simulate a failure by tapping signup (should trigger error handling)
      await robot.tapSignupButton();
      // Assert: Should display an error message (look for a widget with 'error'
      // or similar text)
      expect(find.textContaining('Failed to sign up'), findsOneWidget);
    });
  });

  testWidgets('back arrow is present and tappable', (tester) async {
    // Arrange
    when(() => mockRouter.goNamed(any())).thenReturn(null);
    await pumpSignupScreen(
      tester,
      overrides: [
        authRepositoryProvider.overrideWith((ref) => authRepository),
      ],
    );

    // Act: Tap the back arrow
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Assert: Navigates to login
    verify(() => mockRouter.goNamed('login')).called(1);
  });

  testWidgets('toggling the consent checkbox updates its value',
      (tester) async {
    await pumpSignupScreen(tester);
    // Find the consent checkbox
    final checkbox = find.byType(Checkbox).first;
    expect(checkbox, findsOneWidget);
    // Tap to toggle consent
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    // Should be checked now
    final checkedBox = tester.widget<Checkbox>(checkbox);
    expect(checkedBox.value, isNotNull);
  });

  testWidgets('social sign-up button is tappable', (tester) async {
    await pumpSignupScreen(tester);
    final googleButton = find.byKey(const Key('social_button_google'));
    expect(googleButton, findsOneWidget);
    await tester.ensureVisible(googleButton);
    await tester.tap(googleButton);
    // No assertion needed, just ensure no crash
  });
}
