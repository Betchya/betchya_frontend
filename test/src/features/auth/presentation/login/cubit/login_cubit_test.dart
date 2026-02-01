import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/password_input.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('LoginCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is correct', () {
      expect(LoginCubit(authRepository).state, const LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email is invalid',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.emailChanged('invalid'),
        expect: () => [
          const LoginState(
            email: EmailInput.dirty('invalid'),
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email and password are valid',
        build: () => LoginCubit(authRepository),
        seed: () => const LoginState(
          password: PasswordInput.dirty('Password123!'),
        ),
        act: (cubit) => cubit.emailChanged('test@test.com'),
        expect: () => [
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when password is empty',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.passwordChanged(''),
        expect: () => [
          const LoginState(
            password: PasswordInput.dirty(),
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email and password are valid',
        build: () => LoginCubit(authRepository),
        seed: () => const LoginState(email: EmailInput.dirty('test@test.com')),
        act: (cubit) => cubit.passwordChanged('Password123!'),
        expect: () => [
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
          ),
        ],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not valid',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, success] when logIn succeeds',
        build: () {
          when(
            () => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => MockUser());
          return LoginCubit(authRepository);
        },
        seed: () => const LoginState(
          email: EmailInput.dirty('test@test.com'),
          password: PasswordInput.dirty('Password123!'),
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => [
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] when logIn fails',
        build: () {
          when(
            () => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
          return LoginCubit(authRepository);
        },
        seed: () => const LoginState(
          email: EmailInput.dirty('test@test.com'),
          password: PasswordInput.dirty('Password123!'),
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => [
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const LoginState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Exception: oops',
          ),
        ],
      );
    });
  });
}
