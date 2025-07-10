import 'package:betchya_frontend/src/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robots/login_screen_robot.dart';
import 'package:mocktail/mocktail.dart';
import 'package:betchya_frontend/src/features/auth/providers/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  Future<void> pumpLoginScreen(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          home: LoginScreen(),
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

    testWidgets('enables login button only when form is valid', (tester) async {
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
    });

    testWidgets('navigates to home on successful login', (tester) async {
      // Arrange: mock auth repository to succeed
      when(
        () => authRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Future.value());
      final fakeUser = User(
        id: '123',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
        email: 'test@example.com',
      );
      when(authRepository.getCurrentUser).thenReturn(null);

      final robot = LoginScreenRobot(tester);
      await pumpLoginScreen(
        tester,
        overrides: [
          authRepositoryProvider.overrideWith((ref) => authRepository),
          authControllerProvider
              .overrideWith((ref) => AsyncValue.data<User?>(fakeUser)),
        ],
      );
      await robot.enterEmail('test@example.com');
      await robot.enterPassword('Abcd1234!');
      await robot.expectLoginButtonEnabled(isEnabled: true);
      await robot.tapLoginButton();
      await robot.expectNavigatedToHome();
    });

    testWidgets('shows error on failed login', (tester) async {
      // Should display an error message if login fails
    });
  });
}
