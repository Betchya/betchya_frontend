import 'package:betchya_frontend/features/auth/presentation/home_screen.dart';
import 'package:betchya_frontend/features/auth/presentation/signup_screen.dart';
import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:betchya_frontend/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'robots/signup_screen_robot.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });

  Future<void> pumpSignupScreen(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SignupScreen', () {
    testWidgets('renders all required input fields', (tester) async {
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );
      final robot = SignUpScreenRobot(tester);
      await robot.expectFieldsPresent();
    });

    testWidgets('shows validation errors for invalid input', (tester) async {
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );
      final robot = SignUpScreenRobot(tester);
      // Enter non-empty then empty full name to ensure field is dirty and error shows
      await robot.enterFullName('John');
      await robot.enterFullName('');
      expect(find.text('Invalid name'), findsOneWidget);

      // Enter invalid email and check error
      await robot.enterEmail('invalid-email');
      expect(find.text('Invalid email'), findsOneWidget);

      // Enter invalid password and check error
      await robot.enterPassword('123');
      expect(find.text('Invalid password'), findsOneWidget);

      // Enter non-matching confirm password and check error
      await robot.enterConfirmPassword('different');
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('enables signup button only when form is valid',
        (tester) async {
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );
      final robot = SignUpScreenRobot(tester);
      final signupButton = find.byKey(const Key('signup_button'));

      // Initially disabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNull);

      // Enter valid fields
      await robot.enterFullName('John Doe');
      await robot.enterEmail('john@example.com');
      await robot.enterPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      await tester.pumpAndSettle();
      // Button should be enabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNotNull);

      // Invalidate a field
      await robot.enterEmail('invalid');
      await tester.pumpAndSettle();
      // Button should be disabled
      expect(tester.widget<ElevatedButton>(signupButton).onPressed, isNull);
    });

    testWidgets('navigates to home on successful signup', (tester) async {
      // Arrange: Use a ProviderOverride to inject a mock AuthController that
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
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );

      final robot = SignUpScreenRobot(tester);
      await robot.enterFullName('John Doe');
      await robot.enterEmail('john@example.com');
      await robot.enterPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      // Tap signup
      await robot.tapSignupButton();
      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows error on failed signup', (tester) async {
      // Arrange: Use a ProviderOverride to inject a mock AuthController that
      // throws
      when(
        () => authRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Failed to sign up'));
      await pumpSignupScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
        ],
      );
      final robot = SignUpScreenRobot(tester);
      await robot.enterFullName('John Doe');
      await robot.enterEmail('john@example.com');
      await robot.enterPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      // Simulate a failure by tapping signup (should trigger error handling)
      await robot.tapSignupButton();
      // Assert: Should display an error message (look for a widget with 'error'
      // or similar text)
      expect(find.textContaining('Failed to sign up'), findsOneWidget);
    });
  });
}
