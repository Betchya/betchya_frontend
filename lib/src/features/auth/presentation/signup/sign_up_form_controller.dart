import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/domain/confirm_password_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/full_name_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/password_input.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SignUpFormState {
  const SignUpFormState({
    this.fullName = const FullNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.consent = true,
    this.status = FormzStatus.pure,
    this.error,
    this.isSubmitting = false,
  });
  final FullNameInput fullName;
  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final bool consent;
  final FormzStatus status;
  final String? error;
  final bool isSubmitting;

  SignUpFormState copyWith({
    FullNameInput? fullName,
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    bool? consent,
    FormzStatus? status,
    String? error,
    bool? isSubmitting,
  }) {
    return SignUpFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      consent: consent ?? this.consent,
      status: status ?? this.status,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class SignUpFormController extends StateNotifier<SignUpFormState> {
  SignUpFormController(this._authRepository) : super(const SignUpFormState());
  final AuthRepository _authRepository;

  void fullNameChanged(String value) {
    final fullName = FullNameInput.dirty(value);
    state = state.copyWith(
      fullName: fullName,
      status: Formz.validate([
        fullName,
        state.email,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([
        state.fullName,
        email,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );
    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.email,
        password,
        confirmPassword,
      ]),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: value,
    );
    state = state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.email,
        state.password,
        confirmPassword,
      ]),
    );
  }

  void consentChanged({bool? value}) {
    state = state.copyWith(consent: value ?? true);
  }

  void validateAll() {
    final fullName = FullNameInput.dirty(state.fullName.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );
    state = state.copyWith(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      status: Formz.validate([
        fullName,
        email,
        password,
        confirmPassword,
      ]),
    );
  }

  Future<void> submit() async {
    if (state.status != FormzStatus.valid) return;
    state = state.copyWith(isSubmitting: true);

    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(
        isSubmitting: false,
        status: FormzStatus.submissionSuccess,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
    }
  }
}

final signUpFormControllerProvider =
    StateNotifierProvider.autoDispose<SignUpFormController, SignUpFormState>(
        (ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignUpFormController(authRepository);
});
