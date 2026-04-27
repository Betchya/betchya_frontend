import 'dart:async';

import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

class MockAuthStateChange extends Mock implements AuthState {}

class MockSession extends Mock implements Session {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late AuthRepository authRepository;
  late StreamController<AuthState> authStateController;

  setUpAll(() {
    registerFallbackValue(MockAuthResponse());
    registerFallbackValue(MockUser());
    registerFallbackValue(MockAuthStateChange());
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    authStateController = StreamController<AuthState>();

    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(() => mockGoTrueClient.onAuthStateChange)
        .thenAnswer((_) => authStateController.stream);

    authRepository = AuthRepository(supabaseClient: mockSupabaseClient);
  });

  tearDown(() {
    authStateController.close();
  });

  group('AuthRepository', () {
    test('signUp returns a User on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(
        () => mockGoTrueClient.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await authRepository.signUp(
        email: 'test@test.com',
        password: 'password',
      );
      expect(result, mockUser);
    });

    test('signIn returns a User on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(
        () => mockGoTrueClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await authRepository.signIn(
        email: 'test@test.com',
        password: 'password',
      );
      expect(result, mockUser);
    });

    test('signOut calls supabase signOut', () async {
      when(() => mockGoTrueClient.signOut()).thenAnswer((_) async {});
      await authRepository.signOut();
      verify(() => mockGoTrueClient.signOut()).called(1);
    });

    test('currentUser returns the current user', () {
      final mockUser = MockUser();
      when(() => mockGoTrueClient.currentUser).thenReturn(mockUser);
      final result = authRepository.currentUser;
      expect(result, mockUser);
    });

    test('authStateChanges emits user on auth state change', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      final mockAuthState = MockAuthStateChange();

      // Setup mock auth state
      when(() => mockAuthState.session).thenReturn(mockSession);
      when(() => mockSession.user).thenReturn(mockUser);

      // Add the auth state to the stream
      authStateController.add(mockAuthState);

      // Verify the stream emits the user
      expect(
        authRepository.authStateChanges,
        emits(mockUser),
      );
    });

    test('authStateChanges emits null when session is null', () async {
      final mockAuthState = MockAuthStateChange();
      when(() => mockAuthState.session).thenReturn(null);

      // Add the auth state to the stream
      authStateController.add(mockAuthState);

      // Verify the stream emits null
      expect(
        authRepository.authStateChanges,
        emits(null),
      );
    });
  });
}
