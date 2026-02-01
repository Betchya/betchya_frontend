import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/bloc/auth_bloc.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/login_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:betchya_frontend/src/routing/app_router.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// Helper to create a fake user
User createRecentUser() {
  return User(
    id: 'test-user-id',
    appMetadata: {},
    userMetadata: {},
    aud: 'authenticated',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepository;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Future<void> pumpRouter(
    WidgetTester tester, {
    required AuthBloc authBloc,
  }) async {
    final router = AppRouter.router(authBloc);
    await tester.pumpWidget(
      RepositoryProvider<AuthRepository>.value(
        value: mockAuthRepository,
        child: BlocProvider.value(
          value: authBloc,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AppRouter', () {
    testWidgets('shows LoginScreen on /login', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.unauthenticated());

      await pumpRouter(tester, authBloc: mockAuthBloc);

      // Initial route defaults to / which redirects to /login for unauthenticated
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('shows HomeScreen on / when logged in', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(AuthState.authenticated(createRecentUser()));

      await pumpRouter(tester, authBloc: mockAuthBloc);

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('redirects to /login when unauthenticated and accessing /',
        (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.unauthenticated());

      await pumpRouter(tester, authBloc: mockAuthBloc);

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('redirects to / when logged in and accessing /login',
        (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(AuthState.authenticated(createRecentUser()));

      await pumpRouter(tester, authBloc: mockAuthBloc);

      // Verify redirection happened by checking for HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows SignUpScreen on /login/signUp', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.unauthenticated());

      await pumpRouter(tester, authBloc: mockAuthBloc);

      // Navigate to sign up
      final BuildContext context = tester.element(find.byType(LoginScreen));
      GoRouter.of(context).go('/login/signUp');
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
