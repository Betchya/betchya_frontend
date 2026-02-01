import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/forgot_login_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/forgot_login_state.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/date_of_birth_input.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ForgotLoginCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is correct', () {
      expect(ForgotLoginCubit(authRepository).state, const ForgotLoginState());
    });

    group('submit', () {
      blocTest<ForgotLoginCubit, ForgotLoginState>(
        'does nothing when status is not valid',
        build: () => ForgotLoginCubit(authRepository),
        act: (cubit) => cubit.submit(),
        expect: () => const <ForgotLoginState>[],
      );

      blocTest<ForgotLoginCubit, ForgotLoginState>(
        'emits [inProgress, success] when resetPasswordForEmail succeeds',
        build: () {
          when(
            () => authRepository.resetPasswordForEmail(
              email: any(named: 'email'),
            ),
          ).thenAnswer((_) async {});
          return ForgotLoginCubit(authRepository);
        },
        seed: () => const ForgotLoginState(
          email: EmailInput.dirty('test@test.com'),
          dob: DateOfBirthInput.dirty('01/01/2000'),
          isValid: true,
        ),
        act: (cubit) => cubit.submit(),
        expect: () => [
          const ForgotLoginState(
            email: EmailInput.dirty('test@test.com'),
            dob: DateOfBirthInput.dirty('01/01/2000'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const ForgotLoginState(
            email: EmailInput.dirty('test@test.com'),
            dob: DateOfBirthInput.dirty('01/01/2000'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<ForgotLoginCubit, ForgotLoginState>(
        'emits [inProgress, failure] when resetPasswordForEmail fails',
        build: () {
          when(
            () => authRepository.resetPasswordForEmail(
              email: any(named: 'email'),
            ),
          ).thenThrow(Exception('oops'));
          return ForgotLoginCubit(authRepository);
        },
        seed: () => const ForgotLoginState(
          email: EmailInput.dirty('test@test.com'),
          dob: DateOfBirthInput.dirty('01/01/2000'),
          isValid: true,
        ),
        act: (cubit) => cubit.submit(),
        expect: () => [
          const ForgotLoginState(
            email: EmailInput.dirty('test@test.com'),
            dob: DateOfBirthInput.dirty('01/01/2000'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          const ForgotLoginState(
            email: EmailInput.dirty('test@test.com'),
            dob: DateOfBirthInput.dirty('01/01/2000'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Exception: oops',
          ),
        ],
      );
    });
  });
}
