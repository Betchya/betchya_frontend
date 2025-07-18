import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../robots/login_screen_robot.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGoRouter extends Mock implements GoRouter {}

final fakeUser = User(
  id: '123',
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: DateTime.now().toIso8601String(),
  email: 'test@example.com',
);

void main() {
  late MockAuthRepository authRepository;
  late MockGoRouter mockRouter;

  setUp(() {
    authRepository = MockAuthRepository();
    mockRouter = MockGoRouter();
    // Set initial state
    when(() => authRepository.currentUser).thenReturn(null);
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: InheritedGoRouter(
          goRouter: mockRouter,
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('LoginScreen', () {
    testWidgets('renders all required input fields', (tester) async {
      await pumpLoginScreen(tester);
      final robot = LoginScreenRobot(tester);
      await robot.expectFieldsPresent();
    });

    testWidgets('shows validation errors for invalid input', (tester) async {
      await pumpLoginScreen(tester);
      final robot = LoginScreenRobot(tester);
      await robot.enterEmail('notanemail');
      await robot.enterPassword('short');
      // Unfocus to trigger validation
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Invalid password'), findsOneWidget);
    });

    testWidgets('enables login button and can be tapped when form is valid',
        (tester) async {
      await pumpLoginScreen(tester);
      final robot = LoginScreenRobot(tester);
      // Initially disabled
      await robot.expectLoginButtonEnabled(isEnabled: false);
      // Enter invalid email and password
      await robot.enterEmail('bad');
      await robot.enterPassword('short');
      await robot.expectLoginButtonEnabled(isEnabled: false);
      // Enter valid email and valid password
      await robot.enterEmail('test@example.com');
      await robot.enterPassword('Abcd1234!');
      await robot.expectLoginButtonEnabled(isEnabled: true);
      // Verify we can tap the button
      await robot.tapLoginButton();
    });

    testWidgets('shows error on failed login', (tester) async {
      // Arrange: mock auth repository to fail
      const errorMessage = 'Invalid credentials';
      const error = AuthException(errorMessage);

      // Mock sign in to fail
      when(
        () => authRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(error);

      await pumpLoginScreen(tester);
      final robot = LoginScreenRobot(tester);

      // Enter valid credentials and verify form state
      await robot.enterEmail('test@example.com');
      await robot.enterPassword('Abcd1234!');
      await robot.expectLoginButtonEnabled(isEnabled: true);

      // Act: tap login button
      await robot.tapLoginButton();

      // Wait for the error to be processed
      await tester.pump(); // Build frame for tap
      await tester.pump(); // Build frame for async gap
      await tester.pump(); // Build frame for error state

      // Verify error appears in UI
      final errorFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.style?.color == Colors.red &&
            widget.data!.contains(errorMessage),
      );
      expect(errorFinder, findsOneWidget);
    });

    testWidgets('updates auth state and navigates on successful login',
        (tester) async {
      // Mock successful sign in
      when(
        () => authRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => fakeUser);

      // Mock router navigation
      when(() => mockRouter.goNamed(any())).thenReturn(null);

      await pumpLoginScreen(tester);
      final robot = LoginScreenRobot(tester);

      await robot.enterEmail('test@example.com');
      await robot.enterPassword('Abcd1234!');
      await robot.tapLoginButton();

      // Verify auth state is updated with the user
      await tester.pump();
      verify(
        () => authRepository.signIn(
          email: 'test@example.com',
          password: 'Abcd1234!',
        ),
      ).called(1);

      // Verify navigation is triggered
      verify(() => mockRouter.goNamed('home')).called(1);
    });

    testWidgets('toggles password visibility when icon is tapped',
        (tester) async {
      await pumpLoginScreen(tester);

      // Find password field and visibility toggle
      final passwordField = find.byKey(const Key('login_password_field'));
      final visibilityToggle = find.byIcon(Icons.visibility_off);

      // Initially password should be obscured
      var textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);

      // Tap visibility toggle
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Password should now be visible
      textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isFalse);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Password should be obscured again
      textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('navigates to signup when create account is tapped',
        (tester) async {
      // Mock router navigation
      when(() => mockRouter.goNamed(any())).thenReturn(null);

      await pumpLoginScreen(tester);

      // Find and tap create account button
      final createAccountButton = find.byKey(const Key('login_create_account'));
      await tester.tap(createAccountButton);
      await tester.pump();

      // Verify navigation to signup
      verify(() => mockRouter.goNamed('signUp')).called(1);
    });

    testWidgets('forgot login info button is present and tappable',
        (tester) async {
      await pumpLoginScreen(tester);

      final forgotInfoButton = find.byKey(const Key('login_forgot_info'));
      expect(forgotInfoButton, findsOneWidget);

      // Verify we can tap it (shouldn't throw)
      await tester.tap(forgotInfoButton);
      await tester.pump();
    });
  });
}
