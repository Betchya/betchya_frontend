import 'package:betchya_frontend/src/features/auth/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late AuthRepository authRepository;

  setUpAll(() {
    registerFallbackValue(MockAuthResponse());
    registerFallbackValue(MockUser());
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    authRepository = AuthRepository(supabaseClient: mockSupabaseClient);
  });

  group('AuthRepository', () {
    test('signUp returns a User on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockGoTrueClient.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),).thenAnswer((_) async => mockResponse);

      final result = await authRepository.signUp(email: 'test@test.com', password: 'password');
      expect(result, mockUser);
    });

    test('signIn returns a User on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockGoTrueClient.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),).thenAnswer((_) async => mockResponse);

      final result = await authRepository.signIn(email: 'test@test.com', password: 'password');
      expect(result, mockUser);
    });

    test('signOut calls supabase signOut', () async {
      when(() => mockGoTrueClient.signOut()).thenAnswer((_) async {});
      await authRepository.signOut();
      verify(() => mockGoTrueClient.signOut()).called(1);
    });

    test('getCurrentUser returns the current user', () {
      final mockUser = MockUser();
      when(() => mockGoTrueClient.currentUser).thenReturn(mockUser);
      final result = authRepository.getCurrentUser();
      expect(result, mockUser);
    });
  });
}
