import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/domain/confirm_password_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/full_name_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/password_input.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void fullNameChanged(String value) {
    final fullName = FullNameInput.dirty(value);
    emit(
      state.copyWith(
        fullName: fullName,
        isValid: Formz.validate([
          fullName,
          state.email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.fullName,
          email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate([
          state.fullName,
          state.email,
          password,
          confirmPassword,
        ]),
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate([
          state.fullName,
          state.email,
          state.password,
          confirmPassword,
        ]),
      ),
    );
  }

  void consentChanged({required bool value}) {
    emit(state.copyWith(consent: value));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        // Note: Full Name is not currently used in signUp method but might be
        // needed for user metadata later. The original implementation just
        // ignored it.
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
