import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../robots/auth_robot.dart';

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
    AuthRepository? authRepositoryOverride,
  }) async {
    await tester.pumpWidget(
      RepositoryProvider<AuthRepository>.value(
        value: authRepositoryOverride ?? authRepository,
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
      await tester.enterText(
        find.byKey(const Key('signup_confirm_password_field')),
        'password123',
      );
      await tester.pump();

      final signUpButton = find.byKey(const Key('signup_button'));

      // Initially disabled
      expect(tester.widget<ElevatedButton>(signUpButton).onPressed, isNull);

      // Enter valid fields
      await robot.enterFullName('John Doe');
      await robot.enterSignupEmail('john@example.com');
      await robot.enterSignupPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');
      await tester.pumpAndSettle();
      // Button should be enabled
      expect(tester.widget<ElevatedButton>(signUpButton).onPressed, isNotNull);

      // Invalidate a field
      await robot.enterSignupEmail('invalid');
      await tester.pumpAndSettle();
      // Button should be disabled
      expect(tester.widget<ElevatedButton>(signUpButton).onPressed, isNull);
    });

    testWidgets('calls signUp on valid submission', (tester) async {
      // Arrange
      // We don't need to return a value because the Cubit mocks the call
      when(
        () => authRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => null,
      ); // Return null User? or valid User? Cubit ignores return

      await pumpSignupScreen(tester);

      final robot = AuthRobot(tester);
      await robot.enterFullName('John Doe');
      await robot.enterSignupEmail('john@example.com');
      await robot.enterSignupPassword('Valid123!');
      await robot.enterConfirmPassword('Valid123!');

      // Act
      await robot.tapSignupButton();

      // Assert
      verify(
        () => authRepository.signUp(
          email: 'john@example.com',
          password: 'Valid123!',
        ),
      ).called(1);
    });

    testWidgets('shows error on failed signup', (tester) async {
      // Arrange
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

      // Act
      await robot.tapSignupButton();
      await tester.pumpAndSettle(); // allow error state to propagate

      // Assert
      expect(find.textContaining('Failed to sign up'), findsOneWidget);
    });
  });

  testWidgets('back arrow is present and tappable', (tester) async {
    // Arrange
    when(() => mockRouter.goNamed(any())).thenReturn(null);
    await pumpSignupScreen(tester);

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

    // Initially true (default state)
    // Tap to toggle consent -> false
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(checkbox).value, isFalse);

    // Tap again -> true
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
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
