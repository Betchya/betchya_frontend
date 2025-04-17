import 'package:betchya_frontend/features/auth/presentation/login_screen.dart';
import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuth extends Mock implements Auth {
  @override
  Future<void> signIn({required String email, required String password}) async {}
  @override
  Future<void> signUp({required String email, required String password}) async {}
  @override
  Future<void> signOut() async {}
}

class MockBuildContext extends Mock implements BuildContext {
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({Object? aspect}) => null;
}

class MockScaffoldMessengerState extends Mock implements ScaffoldMessengerState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => '';
}

void main() {
  late MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  testWidgets('renders login form correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('shows error message on failed login', (tester) async {
    when(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthException('Invalid credentials'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Enter credentials
    await tester.enterText(
      find.byType(TextField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextField).last,
      'password123',
    );

    // Tap the sign in button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error is shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('AuthException: Invalid credentials'), findsOneWidget);
  });

  testWidgets('successful login attempt calls signIn', (tester) async {
    when(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Enter credentials
    await tester.enterText(
      find.byType(TextField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextField).last,
      'password123',
    );

    // Tap the sign in button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify signIn was called with correct credentials
    verify(
      () => mockAuth.signIn(
        email: 'test@example.com',
        password: 'password123',
      ),
    ).called(1);
  });

  testWidgets('shows loading indicator during sign in', (tester) async {
    // Make sign in take some time
    when(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Enter credentials
    await tester.enterText(
      find.byType(TextField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextField).last,
      'password123',
    );

    // Tap the sign in button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Sign In'), findsNothing);

    // Wait for sign in to complete
    await tester.pumpAndSettle();

    // Verify loading indicator is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('button is disabled when fields are empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Initially both fields are empty
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify sign in was not called
    verifyNever(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );

    // Fill only email
    await tester.enterText(
      find.byType(TextField).first,
      'test@example.com',
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify sign in was not called
    verifyNever(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );

    // Fill only password
    await tester.enterText(
      find.byType(TextField).first,
      '',
    );
    await tester.enterText(
      find.byType(TextField).last,
      'password123',
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify sign in was not called
    verifyNever(
      () => mockAuth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });
}
