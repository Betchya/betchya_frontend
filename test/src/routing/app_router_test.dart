import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/login_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Fake AuthRepository for testing
class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const Stream<User?>.empty());
  });

  Future<void> pumpRouter(
    WidgetTester tester, {
    required ProviderContainer container,
  }) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: container.read(goRouterProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AppRouter', () {
    late _MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = _MockAuthRepository();
    });

    testWidgets('shows LoginScreen on /login', (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      container.read(goRouterProvider).go('/login');
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('shows HomeScreen on / when logged in', (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(_MockUser());
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      container.read(goRouterProvider).go('/');
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('redirects to /login when unauthenticated and accessing /',
        (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      container.read(goRouterProvider).go('/');
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('redirects to / when logged in and accessing /login',
        (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(_MockUser());
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      container.read(goRouterProvider).go('/login');
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows SignUpScreen on /login/signUp', (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      container.read(goRouterProvider).go('/login/signUp');
      await tester.pumpAndSettle();
      expect(find.byType(SignUpScreen), findsOneWidget);
    });

    testWidgets('shows login screen for unknown route', (tester) async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await pumpRouter(tester, container: container);
      // Navigate to a non-existent route to trigger errorBuilder
      container.read(goRouterProvider).go('/does-not-exist');
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
