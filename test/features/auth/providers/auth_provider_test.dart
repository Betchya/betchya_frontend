import 'package:betchya_frontend/core/providers/supabase_providers.dart';
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

  test('initial state is AsyncData(null)', () async {
    final state = await container.read(authControllerProvider.future);
    expect(state, isNull);
    final asyncState = container.read(authControllerProvider);
    expect(asyncState, isA<AsyncData<User?>>());
    expect(asyncState.value, isNull);
  });

  group('signUp', () {
    test('updates state with user on successful signup', () async {
      final mockAuthResponse = MockAuthResponse();
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(() => mockGoTrueClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockAuthResponse);

      await container.read(authControllerProvider.notifier).signUp(
            email: 'test@test.com',
            password: 'password',
          );

      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncData<User?>>());
      expect(state.value, mockUser);
    });

    test('updates state with error on failed signup', () async {
      when(() => mockGoTrueClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Signup failed'));

      await container.read(authControllerProvider.notifier).signUp(
            email: 'fail@test.com',
            password: 'password',
          );

      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncError<User?>>());
      expect(state.error, isA<Exception>());
    });
  });

  group('signIn', () {
    test('updates state with user on successful sign in', () async {
      final mockAuthResponse = MockAuthResponse();
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(() => mockGoTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockAuthResponse);

      await container.read(authControllerProvider.notifier).signIn(
            email: 'test@test.com',
            password: 'password',
          );

      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncData<User?>>());
      expect(state.value, mockUser);
    });

    test('updates state with error on failed sign in', () async {
      when(() => mockGoTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Sign in failed'));

      await container.read(authControllerProvider.notifier).signIn(
            email: 'fail@test.com',
            password: 'password',
          );

      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncError<User?>>());
      expect(state.error, isA<Exception>());
    });
  });

  group('signOut', () {
    test('updates state to null after sign out', () async {
      when(() => mockGoTrueClient.signOut()).thenAnswer((_) async => null);
      await container.read(authControllerProvider.notifier).signOut();
      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncData<User?>>());
      expect(state.value, isNull);
    });

    test('updates state with error on failed sign out', () async {
      when(() => mockGoTrueClient.signOut())
          .thenThrow(Exception('Sign out failed'));
      await container.read(authControllerProvider.notifier).signOut();
      final state = container.read(authControllerProvider);
      expect(state, isA<AsyncError<User?>>());
      expect(state.error, isA<Exception>());
    });
  });
}
