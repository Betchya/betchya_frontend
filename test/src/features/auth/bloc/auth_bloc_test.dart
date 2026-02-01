import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late AuthRepository authRepository;
    late User user;

    setUp(() {
      authRepository = MockAuthRepository();
      user = MockUser();
      when(() => authRepository.authStateChanges)
          .thenAnswer((_) => const Stream.empty());
      when(() => authRepository.currentUser).thenReturn(null);
    });

    test('initial state is unauthenticated when user is null', () {
      expect(
        AuthBloc(authRepository: authRepository).state,
        const AuthState.unauthenticated(),
      );
    });

    test('initial state is authenticated when user is not null', () {
      when(() => authRepository.currentUser).thenReturn(user);
      expect(
        AuthBloc(authRepository: authRepository).state,
        AuthState.authenticated(user),
      );
    });

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when authStateChanges emits user',
      build: () {
        when(() => authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(user));
        return AuthBloc(authRepository: authRepository);
      },
      expect: () => [AuthState.authenticated(user)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when authStateChanges emits null',
      build: () {
        when(() => authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(null));
        return AuthBloc(authRepository: authRepository);
      },
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'invokes signOut on AuthLogoutRequested',
      build: () {
        when(() => authRepository.signOut()).thenAnswer((_) async {});
        return AuthBloc(authRepository: authRepository);
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      verify: (_) {
        verify(() => authRepository.signOut()).called(1);
      },
    );
  });
}
