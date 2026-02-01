import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/app.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/login_screen.dart';
import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'robots/auth_robot.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late User mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();

    // Default: no user logged in initially
    when(() => mockAuthRepository.currentUser).thenReturn(null);
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(null));
  });

  testWidgets('Full Login Flow (AuthRobot Smoke Test)', (tester) async {
    // 1. Arrange: Setup the real app with a mock repository
    // We use a StreamController to simulate auth state changes over time
    final authStreamController = StreamController<User?>();
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStreamController.stream);

    // Initial state: Unauthenticated
    authStreamController.add(null);

    when(
      () => mockAuthRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {
      // Simulate successful login logic
      authStreamController.add(mockUser);
      return mockUser;
    });

    // Run the full app
    await tester.pumpWidget(App(authRepository: mockAuthRepository));
    await tester.pumpAndSettle();

    // Initialize the Robot
    final authRobot = AuthRobot(tester);

    // 2. Assert: Check initial state is Login Screen
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    await authRobot.expectLoginFieldsPresent();

    // 3. Act: Use Robot to login
    await authRobot.enterLoginEmail('test@example.com');
    await authRobot.enterLoginPassword('Password123!');
    await authRobot.tapLoginButton();

    // 4. Act: Simulate repository emitting the new user (triggered by signIn
    // above) Wait for the stream listener to react and the router to redirect
    await tester.pumpAndSettle();

    // 5. Assert: Verify we are now on the Home Screen
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    // Cleanup
    await authStreamController.close();
  });

  testWidgets('Full Sign Up Flow (AuthRobot Smoke Test)', (tester) async {
    // 1. Arrange: Setup the real app with a mock repository
    final authStreamController = StreamController<User?>();
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStreamController.stream);

    // Initial state: Unauthenticated
    authStreamController.add(null);

    when(
      () => mockAuthRepository.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {
      // Simulate successful sign up logic
      authStreamController.add(mockUser);
      return mockUser;
    });

    await tester.pumpWidget(App(authRepository: mockAuthRepository));
    await tester.pumpAndSettle();

    final authRobot = AuthRobot(tester);

    // 2. Act: Navigate to Sign Up
    await authRobot.tapCreateAccountButton();
    await authRobot.expectSignupFieldsPresent();

    // 3. Act: Fill Sign Up Form
    await authRobot.enterFullName('John Doe');
    await authRobot.enterSignupEmail('newuser@example.com');
    await authRobot.enterSignupPassword('Password123!');
    await authRobot.enterConfirmPassword('Password123!');
    await authRobot.tapSignupButton();

    // 4. Act: Simulate repository emitting the new user
    await tester.pumpAndSettle();

    // 5. Assert: Verify navigation to Home
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    await authStreamController.close();
  });
}
