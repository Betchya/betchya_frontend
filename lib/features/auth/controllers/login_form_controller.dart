import 'package:betchya_frontend/features/auth/models/email_input.dart';
import 'package:betchya_frontend/features/auth/models/password_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class LoginFormState {
  const LoginFormState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isSubmitting = false,
  });

  final EmailInput email;
  final PasswordInput password;
  final FormzStatus status;
  final String? error;
  final bool isSubmitting;

  LoginFormState copyWith({
    EmailInput? email,
    PasswordInput? password,
    FormzStatus? status,
    String? error,
    bool? isSubmitting,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class LoginFormController extends StateNotifier<LoginFormState> {
  LoginFormController() : super(const LoginFormState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    );
  }

  void validateAll() {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    state = state.copyWith(
      email: email,
      password: password,
      status: Formz.validate([email, password]),
    );
  }
}

final loginFormControllerProvider =
    StateNotifierProvider.autoDispose<LoginFormController, LoginFormState>(
        (ref) {
  return LoginFormController();
});
