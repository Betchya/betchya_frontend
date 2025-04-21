import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabase extends Mock implements Supabase {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUser mockUser;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUser = MockUser();

    // Mock the dependencies
    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(() => mockGoTrueClient.currentUser).thenReturn(null);

    // Create a test provider that uses our mock client
    container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(mockSupabaseClient),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is null', () {
    expect(container.read(authProvider), null);
  });

  group('signUp', () {
    test('updates state with user on successful signup', () async {
      final mockAuthResponse = MockAuthResponse();
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(
        () => mockGoTrueClient.signUp(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => mockAuthResponse);

      await container.read(authProvider.notifier).signUp(
            email: 'test@example.com',
            password: 'password123',
          );

      verify(
        () => mockGoTrueClient.signUp(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);

      expect(container.read(authProvider), mockUser);
    });

    test('signUp failed signup throws error and keeps state null', () async {
      // Mock failed signup
      when(
        () => mockGoTrueClient.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Signup failed'));

      // Attempt signup
      expect(
        () => container.read(authProvider.notifier).signUp(
              email: 'test@example.com',
              password: 'password',
            ),
        throwsA(isA<AuthException>()),
      );

      // State should remain null
      expect(container.read(authProvider), null);
    });
  });

  group('signIn', () {
    test('signIn updates state with user on successful signin', () async {
      // Mock successful signin
      when(() => mockGoTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => AuthResponse(user: mockUser));

      // Sign in
      await container.read(authProvider.notifier).signIn(
            email: 'test@example.com',
            password: 'password',
          );

      // State should be updated with user
      expect(container.read(authProvider), mockUser);
    });

    test('signIn failed signin throws error and keeps state null', () async {
      // Mock failed signin
      when(() => mockGoTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenThrow(const AuthException('Signin failed'));

      // Attempt signin
      expect(
        () => container.read(authProvider.notifier).signIn(
              email: 'test@example.com',
              password: 'password',
            ),
        throwsA(isA<AuthException>()),
      );

      // State should remain null
      expect(container.read(authProvider), null);
    });
  });

  group('signOut', () {
    test('signOut sets state to null on successful signout', () async {
      // Mock successful signout
      when(() => mockGoTrueClient.signOut()).thenAnswer((_) async {});

      // Sign out
      await container.read(authProvider.notifier).signOut();

      // State should be null
      expect(container.read(authProvider), null);
    });

    test('failed signout throws error and keeps state unchanged', () async {
      // Set initial state to mockUser
      when(() => mockGoTrueClient.currentUser).thenReturn(mockUser);
      container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        ],
      );

      // Verify initial state
      expect(container.read(authProvider), mockUser);

      when(() => mockGoTrueClient.signOut())
          .thenThrow(const AuthException('Signout failed'));

      await expectLater(
        container.read(authProvider.notifier).signOut(),
        throwsA(isA<AuthException>()),
      );

      // State should remain unchanged
      expect(container.read(authProvider), mockUser);
    });
  });
}
