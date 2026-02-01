import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/domain/confirm_password_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/full_name_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/password_input.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/cubit/sign_up_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('SignUpCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is correct', () {
      expect(SignUpCubit(authRepository).state, const SignUpState());
    });

    group('signUpFormSubmitted', () {
      blocTest<SignUpCubit, SignUpState>(
        'does nothing when status is not valid',
        build: () => SignUpCubit(authRepository),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, success] when signUp succeeds',
        build: () {
          when(
            () => authRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => MockUser());
          return SignUpCubit(authRepository);
        },
        seed: () => const SignUpState(
          email: EmailInput.dirty('test@test.com'),
          password: PasswordInput.dirty('Password123!'),
          confirmPassword: ConfirmPasswordInput.dirty(
              password: 'Password123!', value: 'Password123!'),
          fullName: FullNameInput.dirty('John Doe'),
          isValid: true,
        ),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => [
          const SignUpState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            confirmPassword: ConfirmPasswordInput.dirty(
                password: 'Password123!', value: 'Password123!'),
            fullName: FullNameInput.dirty('John Doe'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const SignUpState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            confirmPassword: ConfirmPasswordInput.dirty(
                password: 'Password123!', value: 'Password123!'),
            fullName: FullNameInput.dirty('John Doe'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, failure] when signUp fails',
        build: () {
          when(
            () => authRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
          return SignUpCubit(authRepository);
        },
        seed: () => const SignUpState(
          email: EmailInput.dirty('test@test.com'),
          password: PasswordInput.dirty('Password123!'),
          confirmPassword: ConfirmPasswordInput.dirty(
              password: 'Password123!', value: 'Password123!'),
          fullName: FullNameInput.dirty('John Doe'),
          isValid: true,
        ),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => [
          const SignUpState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            confirmPassword: ConfirmPasswordInput.dirty(
                password: 'Password123!', value: 'Password123!'),
            fullName: FullNameInput.dirty('John Doe'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const SignUpState(
            email: EmailInput.dirty('test@test.com'),
            password: PasswordInput.dirty('Password123!'),
            confirmPassword: ConfirmPasswordInput.dirty(
                password: 'Password123!', value: 'Password123!'),
            fullName: FullNameInput.dirty('John Doe'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Exception: oops',
          ),
        ],
      );
    });
  });
}
