import 'package:betchya_frontend/features/auth/presentation/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robots/signup_screen_robot.dart';

void main() {
  setUp(() {
    // Initialize any global mocks or dependencies here if needed
  });

  tearDown(() {
    // Clean up after tests if needed
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
      await pumpSignupScreen(tester);
      final robot = SignUpScreenRobot(tester);
      await robot.expectFieldsPresent();
    });

    testWidgets('shows validation errors for invalid input', (tester) async {
      await pumpSignupScreen(tester);
      final robot = SignUpScreenRobot(tester);
      // Enter invalid full name
      await robot.enterFullName('');
      // Enter invalid email
      await robot.enterEmail('invalid-email');
      // Enter invalid password (too short, no special char)
      await robot.enterPassword('123');
      // Enter non-matching confirm password
      await robot.enterConfirmPassword('different');
      // Tap signup to trigger validation
      await robot.tapSignupButton();
      // Check for error messages
      expect(find.text('Invalid name'), findsOneWidget);
      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Invalid password'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('enables signup button only when form is valid', (tester) async {
      await pumpSignupScreen(tester);
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

    testWidgets('shows loading indicator when signing up', (tester) async {
      // Should show a loading spinner when signup is in progress
    });

    testWidgets('navigates to home on successful signup', (tester) async {
      // Should navigate to home screen after successful signup
    });

    testWidgets('shows error on failed signup', (tester) async {
      // Should display an error message if signup fails
    });
  });
}
